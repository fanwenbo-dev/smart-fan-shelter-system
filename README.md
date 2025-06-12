# Smart Cooling Fan Shelter System

A smart embedded system project built using an STM32 microcontroller, designed to provide shelter, cooling, and real-time safety alerts for elderly, young, or vulnerable individuals during harsh weather conditions such as high temperatures or heavy rain. The system is intended for public deployment at park connectors and uses various sensors and components to ensure responsive and user-friendly operation.

## 🌟 Features

- 🌡️ Real-time temperature and humidity monitoring using DHT11
- 🚶‍♂️ IR sensor detects human presence and activates system
- 🌈 RGB LED status indicator for safety (Red: Unsafe / Green: Safe)
- 💨 DC motor controls fan speed automatically or manually
- 🔢 Keypad to switch modes (Auto / Manual) and control fan speed
- 📟 LCD displays temperature and safety status
- 🌐 ESP01 Wi-Fi module displays live readings via a browser-accessible website
- ⏲️ Auto shutdown after 20 seconds of inactivity to save power

## 🧩 Components Used

- STM32 Microcontroller (NUCLEO board)
- DHT11 Temperature and Humidity Sensor
- IR Proximity Sensor
- ESP-01 Wi-Fi Module (UART Communication)
- LCD 16x2 Display
- 4x4 Keypad
- RGB LED
- DC Fan Motor
- Push Button (Shutdown)
- Breadboard, jumper wires, power supply, etc.

## 🔧 System Modes

- **AUTO**: Fan speed adjusts based on temperature.
- **MANUAL**: User selects fan speed using keypad.
- **Shutdown**: Triggered by button or inactivity.

## 🌐 Web Interface

The ESP-01 module creates a simple web server that displays:
- Current temperature
- Humidity
- Fan speed

Access the web server by entering the IP address displayed on the terminal after startup.

## 👨‍💻 Contributors

| Name       | Role                                                                 |
|------------|----------------------------------------------------------------------|
| Wen Bo     | Main Programmer, Code Integration, System Architecture               |
| Chandan    | ESP01 Programming, Project Planning, Model Supervision               |
| Yan Tiong  | DC Motor Integration, Concept Contributor, Debugging Assistance      |
| Marco      | Structure Designer, Soldering, Motor Circuit Troubleshooting         |


