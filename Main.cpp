#undef __ARM_FP
#include "mbed.h"
#include <stdio.h>
#include <string.h>
#include "lcd.h"
#include "keypad.h"
#include "DHT11.h"

// DHT11 sensor setup
#define DHT11_PIN PD_2
DHT11 dht11(DHT11_PIN);

// IR sensor setup
#define IR_SENSOR_PIN PA_1
InterruptIn IRSensor(IR_SENSOR_PIN);  // Changed from DigitalIn to InterruptIn

// RGB LED setup
DigitalOut red(PB_5);
DigitalOut green(PB_6);
DigitalOut blue(PB_7);

// Keypad setup
InterruptIn keypadInterrupt(PA_0);
char userInput[4];
int inputIndex = 0;

// Shutdown button setup
InterruptIn shutdownButton(PC_12);  // Interrupt for shutdown button

// UART setup for ESP-01 communication
#define MAXIMUM_BUFFER_SIZE 512

#define UART3_TX PC_10
#define UART3_RX PC_11
static BufferedSerial serial_port(UART3_TX, UART3_RX, 115200);

// Buffers for UART communication
char bufRx[MAXIMUM_BUFFER_SIZE] = {0};
char bufTx[MAXIMUM_BUFFER_SIZE] = {0};

// Timer setup for inactivity shutdown
Timer inactivityTimer;

// System modes
enum SystemMode { AUTO, MANUAL };
SystemMode currentMode = AUTO;

// Fan speed levels
enum FanSpeed { OFF, LOW, MEDIUM, HIGH };
FanSpeed currentFanSpeed = OFF;

// Function to display a string on the LCD
void displayString(const char *str, int line) {
    lcd_write_cmd(line == 1 ? 0x80 : 0xC0);
    for (int i = 0; str[i] != '\0'; i++) {
        lcd_write_data(str[i]);
    }
}

// Function to properly clear the LCD screen
void clearLCD() {
    lcd_write_cmd(0x01);
    thread_sleep_for(2);
}

// Function to update RGB LED based on temperature
void updateLED(int temperature) {
    red = (temperature >= 27);
    green = (temperature < 27);
    blue = 0;
}

// Function to turn off the LCD and RGB LED
void shutdownPeripherals() {
    clearLCD();
    red = 0;
    green = 0;
    blue = 0;
    printf("Peripherals shut down.\n");
}

// Shutdown button ISR
void shutdownISR() {
    printf("Shutdown button pressed! Turning off peripherals.\n");
    shutdownPeripherals();
    inactivityTimer.stop();  // Stop the inactivity timer when shutdown occurs
}

// Keypad interrupt ISR
void keypadISR() {
    static Timer debounceTimer;
    if (debounceTimer.elapsed_time() >= 50ms) {
        char key = getkey();
        if (key != 0) {
            userInput[inputIndex++] = key;
            if (inputIndex >= 4) inputIndex = 0;
            printf("Keypad Input: %c\n", key);
            inactivityTimer.reset();  // Reset the inactivity timer on valid keypress
            debounceTimer.reset();  // Reset debounce timer after processing key

            switch (key) {
                case '0': currentFanSpeed = OFF; printf("Fan OFF\n"); break;
                case '1': currentFanSpeed = LOW; printf("Fan LOW\n"); break;
                case '2': currentFanSpeed = MEDIUM; printf("Fan MEDIUM\n"); break;
                case '3': currentFanSpeed = HIGH; printf("Fan HIGH\n"); break;
                case '7': 
                    currentMode = (currentMode == AUTO) ? MANUAL : AUTO;
                    printf("Mode: %s\n", (currentMode == AUTO) ? "AUTO" : "MANUAL");
                    shutdownPeripherals();
                    break;
                default: printf("Invalid key: %c\n", key); break;
            }
        }
    }
}

// IR Sensor ISR
void irSensorISR() {
    inactivityTimer.reset();  // Reset the inactivity timer when motion is detected
    printf("Motion detected, resetting inactivity timer.\n");
}

// Function to send a command to ESP-01 and read the response
void send_command(const char *command, int delay) {
    serial_port.write(command, strlen(command));
    thread_sleep_for(delay);
    int num2 = serial_port.read(bufRx, sizeof(bufRx) - 1);
    if (num2 > 0) {
        bufRx[num2] = '\0';
        printf("%s\n", bufRx);
    }
}

// Function to connect to Wi-Fi
bool connect_to_wifi(const char *ssid, const char *password) {
    printf("Connecting to Wi-Fi...\n");
    for (int i = 0; i < 5; i++) {
        snprintf(bufTx, sizeof(bufTx), "AT+CWJAP=\"%s\",\"%s\"\r\n", ssid, password);
        serial_port.write(bufTx, strlen(bufTx));
        thread_sleep_for(5000);

        int num2 = serial_port.read(bufRx, sizeof(bufRx) - 1);
        if (num2 > 0) {
            bufRx[num2] = '\0';
            printf("Wi-Fi Response: %s\n", bufRx);
            if (strstr(bufRx, "OK")) {
                printf("Connected to Wi-Fi!\n");
                return true;
            }
        }
        printf("Retrying Wi-Fi connection...\n");
    }
    return false;
}

// Function to get the IP address
void get_ip_address() {
    printf("Getting IP Address...\n");
    send_command("AT+CIFSR\r\n", 2000);
}

// Main loop
int main() {
    // Initialize peripherals
    lcd_init();
    keypadInterrupt.rise(&keypadISR);
    shutdownButton.fall(&shutdownISR);
    IRSensor.fall(&irSensorISR);  // Attach IR sensor interrupt
    inactivityTimer.start();

    // Initialize ESP-01
    serial_port.set_baud(115200);
    serial_port.set_format(8, BufferedSerial::None, 1);
    serial_port.set_flow_control(mbed::BufferedSerial::Disabled);

    printf("Initializing ESP-01...\n");
    send_command("AT+RST\r\n", 3000);
    send_command("AT\r\n", 2000);
    send_command("AT+CWMODE=1\r\n", 1000);

    // Connect to Wi-Fi
    char ssid[] = "Galaxy";
    char password[] = "vhut6335";
    if (connect_to_wifi(ssid, password)) {
        get_ip_address();
    } else {
        printf("Failed to connect to Wi-Fi. Please check credentials.\n");
        return 1;
    }

    // Start TCP server
    send_command("AT+CIPMUX=1\r\n", 1000);
    send_command("AT+CIPSERVER=1,80\r\n", 1000);
    printf("Server started. Enter the IP address in your browser.\n");

    int temperature = 0, humidity = 0;
    char buffer[20];

    while (true) {
        // Check for incoming HTTP requests
        memset(bufRx, 0, sizeof(bufRx));
        int num2 = serial_port.read(bufRx, sizeof(bufRx));
        if (num2 > 0) {
            bufRx[num2] = '\0';
            printf("Received: %s\n", bufRx);

            // Check if the request is a GET request
            if (strstr(bufRx, "GET /")) {
                // Prepare HTTP response with sensor data
                snprintf(bufTx, sizeof(bufTx),
                    "HTTP/1.1 200 OK\r\n"
                    "Content-Type: text/html\r\n"
                    "Content-Length: 310\r\n\r\n"
                    "<!DOCTYPE html>"
                    "<html lang=\"en\">"
                    "<head>"
                    "<meta charset=\"UTF-8\">"
                    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                    "<title>Sensor Readings</title>"
                    "</head>"
                    "<body>"
                    "<h2>Sensor Readings</h2>"
                    "Temperature: %d°C<br>"
                    "Humidity: %d%%<br>"
                    "Fan Speed: %d<br>"
                    "</body></html>\r\n",
                    temperature, humidity, currentFanSpeed
                );

                // Send HTTP response
                char sendCommand[30];
                snprintf(sendCommand, sizeof(sendCommand), "AT+CIPSEND=0,%d\r\n", strlen(bufTx));
                serial_port.write(sendCommand, strlen(sendCommand));
                thread_sleep_for(200);
                serial_port.write(bufTx, strlen(bufTx));
                thread_sleep_for(100);
                printf("✅ Data sent!\n");
            }
        }

        // Read temperature and humidity
        int result = dht11.readTemperatureHumidity(temperature, humidity);

        if (result == 0) {
            snprintf(buffer, sizeof(buffer), "Temp: %d C", temperature);
            displayString(buffer, 1);
            displayString((temperature >= 27) ? "Temp High, Seek Cover" : "Temp Safe, All Good!", 2);
            updateLED(temperature);
            printf("Temperature: %d C, Humidity: %d%%\n", temperature, humidity);

            if (currentMode == AUTO) {
                currentFanSpeed = (temperature >= 27) ? HIGH : (temperature >= 25) ? MEDIUM : LOW;
                printf("Auto mode: Fan speed %d\n", currentFanSpeed);
            }
        } else {
            displayString("DHT11 Error", 1);
            displayString(dht11.getErrorString(result), 2);
        }

        // Check for inactivity
        if (inactivityTimer.elapsed_time() >= 20s) {
            printf("No activity for 20s. Shutting down peripherals.\n");
            shutdownPeripherals();
        }

        thread_sleep_for(2000);
    }
}
