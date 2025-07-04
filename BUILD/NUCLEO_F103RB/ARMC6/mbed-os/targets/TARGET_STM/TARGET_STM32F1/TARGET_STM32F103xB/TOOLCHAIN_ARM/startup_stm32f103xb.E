# 1 "./mbed-os/targets/TARGET_STM/TARGET_STM32F1/TARGET_STM32F103xB/TOOLCHAIN_ARM/startup_stm32f103xb.S"
# 1 "<built-in>" 1
# 382 "<built-in>"
# 1 "./BUILD/NUCLEO_F103RB/ARMC6/mbed_config.h" 1
# 383 "<built-in>" 2
# 1 "./mbed-os/targets/TARGET_STM/TARGET_STM32F1/TARGET_STM32F103xB/TOOLCHAIN_ARM/startup_stm32f103xb.S" 2
;******************** (C) COPYRIGHT 2017 STMicroelectronics ********************
;* File Name : startup_stm32f103xb.s
;* Author : MCD Application Team
;* Description : 1 Devices vector table for MDK-ARM toolchain.
;* This module performs:
;* - Set the initial SP
;* - Set the initial PC == Reset_Handler
;* - Set the vector table entries with the exceptions ISR address
;* - Configure the clock system
;* - Branches to __main in the C library (which eventually
;* calls main()).
;* After Reset the Cortex-M3 processor is in Thread mode,
;* priority is Privileged, and the Stack is set to Main.
;******************************************************************************
;* @attention
;*
;* Copyright (c) 2017 STMicroelectronics.
;* All rights reserved.
;*
;* This software component is licensed by ST under BSD 3-Clause license,
;* the "License"; You may not use this file except in compliance with the
;* License. You may obtain a copy of the License at:
;* opensource.org/licenses/BSD-3-Clause
;*
;******************************************************************************

                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset
                AREA RESET, DATA, READONLY
                EXPORT __Vectors
                EXPORT __Vectors_End
                EXPORT __Vectors_Size

                IMPORT |Image$$ARM_LIB_STACK$$ZI$$Limit|
__Vectors DCD |Image$$ARM_LIB_STACK$$ZI$$Limit| ; Top of Stack
                DCD Reset_Handler ; Reset Handler
                DCD NMI_Handler ; NMI Handler
                DCD HardFault_Handler ; Hard Fault Handler
                DCD MemManage_Handler ; MPU Fault Handler
                DCD BusFault_Handler ; Bus Fault Handler
                DCD UsageFault_Handler ; Usage Fault Handler
                DCD 0 ; Reserved
                DCD 0 ; Reserved
                DCD 0 ; Reserved
                DCD 0 ; Reserved
                DCD SVC_Handler ; SVCall Handler
                DCD DebugMon_Handler ; Debug Monitor Handler
                DCD 0 ; Reserved
                DCD PendSV_Handler ; PendSV Handler
                DCD SysTick_Handler ; SysTick Handler

                ; External Interrupts
                DCD WWDG_IRQHandler ; Window Watchdog
                DCD PVD_IRQHandler ; PVD through EXTI Line detect
                DCD TAMPER_IRQHandler ; Tamper
                DCD RTC_IRQHandler ; RTC
                DCD FLASH_IRQHandler ; Flash
                DCD RCC_IRQHandler ; RCC
                DCD EXTI0_IRQHandler ; EXTI Line 0
                DCD EXTI1_IRQHandler ; EXTI Line 1
                DCD EXTI2_IRQHandler ; EXTI Line 2
                DCD EXTI3_IRQHandler ; EXTI Line 3
                DCD EXTI4_IRQHandler ; EXTI Line 4
                DCD DMA1_Channel1_IRQHandler ; DMA1 Channel 1
                DCD DMA1_Channel2_IRQHandler ; DMA1 Channel 2
                DCD DMA1_Channel3_IRQHandler ; DMA1 Channel 3
                DCD DMA1_Channel4_IRQHandler ; DMA1 Channel 4
                DCD DMA1_Channel5_IRQHandler ; DMA1 Channel 5
                DCD DMA1_Channel6_IRQHandler ; DMA1 Channel 6
                DCD DMA1_Channel7_IRQHandler ; DMA1 Channel 7
                DCD ADC1_2_IRQHandler ; ADC1_2
                DCD USB_HP_CAN1_TX_IRQHandler ; USB High Priority or CAN1 TX
                DCD USB_LP_CAN1_RX0_IRQHandler ; USB Low Priority or CAN1 RX0
                DCD CAN1_RX1_IRQHandler ; CAN1 RX1
                DCD CAN1_SCE_IRQHandler ; CAN1 SCE
                DCD EXTI9_5_IRQHandler ; EXTI Line 9..5
                DCD TIM1_BRK_IRQHandler ; TIM1 Break
                DCD TIM1_UP_IRQHandler ; TIM1 Update
                DCD TIM1_TRG_COM_IRQHandler ; TIM1 Trigger and Commutation
                DCD TIM1_CC_IRQHandler ; TIM1 Capture Compare
                DCD TIM2_IRQHandler ; TIM2
                DCD TIM3_IRQHandler ; TIM3
                DCD TIM4_IRQHandler ; TIM4
                DCD I2C1_EV_IRQHandler ; I2C1 Event
                DCD I2C1_ER_IRQHandler ; I2C1 Error
                DCD I2C2_EV_IRQHandler ; I2C2 Event
                DCD I2C2_ER_IRQHandler ; I2C2 Error
                DCD SPI1_IRQHandler ; SPI1
                DCD SPI2_IRQHandler ; SPI2
                DCD USART1_IRQHandler ; USART1
                DCD USART2_IRQHandler ; USART2
                DCD USART3_IRQHandler ; USART3
                DCD EXTI15_10_IRQHandler ; EXTI Line 15..10
                DCD RTC_Alarm_IRQHandler ; RTC Alarm through EXTI Line
                DCD USBWakeUp_IRQHandler ; USB Wakeup from suspend
__Vectors_End

__Vectors_Size EQU __Vectors_End - __Vectors

                AREA |.text|, CODE, READONLY

; Reset handler
Reset_Handler PROC
                 EXPORT Reset_Handler [WEAK]
     IMPORT __main
     IMPORT SystemInit
                 LDR R0, =SystemInit
                 BLX R0
                 LDR R0, =__main
                 BX R0
                 ENDP

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler PROC
                EXPORT NMI_Handler [WEAK]
                B .
                ENDP
HardFault_Handler PROC

                EXPORT HardFault_Handler [WEAK]
                B .
                ENDP
MemManage_Handler PROC

                EXPORT MemManage_Handler [WEAK]
                B .
                ENDP
BusFault_Handler PROC

                EXPORT BusFault_Handler [WEAK]
                B .
                ENDP
UsageFault_Handler PROC

                EXPORT UsageFault_Handler [WEAK]
                B .
                ENDP
SVC_Handler PROC
                EXPORT SVC_Handler [WEAK]
                B .
                ENDP
DebugMon_Handler PROC

                EXPORT DebugMon_Handler [WEAK]
                B .
                ENDP
PendSV_Handler PROC
                EXPORT PendSV_Handler [WEAK]
                B .
                ENDP
SysTick_Handler PROC
                EXPORT SysTick_Handler [WEAK]
                B .
                ENDP

Default_Handler PROC

                EXPORT WWDG_IRQHandler [WEAK]
                EXPORT PVD_IRQHandler [WEAK]
                EXPORT TAMPER_IRQHandler [WEAK]
                EXPORT RTC_IRQHandler [WEAK]
                EXPORT FLASH_IRQHandler [WEAK]
                EXPORT RCC_IRQHandler [WEAK]
                EXPORT EXTI0_IRQHandler [WEAK]
                EXPORT EXTI1_IRQHandler [WEAK]
                EXPORT EXTI2_IRQHandler [WEAK]
                EXPORT EXTI3_IRQHandler [WEAK]
                EXPORT EXTI4_IRQHandler [WEAK]
                EXPORT DMA1_Channel1_IRQHandler [WEAK]
                EXPORT DMA1_Channel2_IRQHandler [WEAK]
                EXPORT DMA1_Channel3_IRQHandler [WEAK]
                EXPORT DMA1_Channel4_IRQHandler [WEAK]
                EXPORT DMA1_Channel5_IRQHandler [WEAK]
                EXPORT DMA1_Channel6_IRQHandler [WEAK]
                EXPORT DMA1_Channel7_IRQHandler [WEAK]
                EXPORT ADC1_2_IRQHandler [WEAK]
                EXPORT USB_HP_CAN1_TX_IRQHandler [WEAK]
                EXPORT USB_LP_CAN1_RX0_IRQHandler [WEAK]
                EXPORT CAN1_RX1_IRQHandler [WEAK]
                EXPORT CAN1_SCE_IRQHandler [WEAK]
                EXPORT EXTI9_5_IRQHandler [WEAK]
                EXPORT TIM1_BRK_IRQHandler [WEAK]
                EXPORT TIM1_UP_IRQHandler [WEAK]
                EXPORT TIM1_TRG_COM_IRQHandler [WEAK]
                EXPORT TIM1_CC_IRQHandler [WEAK]
                EXPORT TIM2_IRQHandler [WEAK]
                EXPORT TIM3_IRQHandler [WEAK]
                EXPORT TIM4_IRQHandler [WEAK]
                EXPORT I2C1_EV_IRQHandler [WEAK]
                EXPORT I2C1_ER_IRQHandler [WEAK]
                EXPORT I2C2_EV_IRQHandler [WEAK]
                EXPORT I2C2_ER_IRQHandler [WEAK]
                EXPORT SPI1_IRQHandler [WEAK]
                EXPORT SPI2_IRQHandler [WEAK]
                EXPORT USART1_IRQHandler [WEAK]
                EXPORT USART2_IRQHandler [WEAK]
                EXPORT USART3_IRQHandler [WEAK]
                EXPORT EXTI15_10_IRQHandler [WEAK]
                EXPORT RTC_Alarm_IRQHandler [WEAK]
                EXPORT USBWakeUp_IRQHandler [WEAK]

WWDG_IRQHandler
PVD_IRQHandler
TAMPER_IRQHandler
RTC_IRQHandler
FLASH_IRQHandler
RCC_IRQHandler
EXTI0_IRQHandler
EXTI1_IRQHandler
EXTI2_IRQHandler
EXTI3_IRQHandler
EXTI4_IRQHandler
DMA1_Channel1_IRQHandler
DMA1_Channel2_IRQHandler
DMA1_Channel3_IRQHandler
DMA1_Channel4_IRQHandler
DMA1_Channel5_IRQHandler
DMA1_Channel6_IRQHandler
DMA1_Channel7_IRQHandler
ADC1_2_IRQHandler
USB_HP_CAN1_TX_IRQHandler
USB_LP_CAN1_RX0_IRQHandler
CAN1_RX1_IRQHandler
CAN1_SCE_IRQHandler
EXTI9_5_IRQHandler
TIM1_BRK_IRQHandler
TIM1_UP_IRQHandler
TIM1_TRG_COM_IRQHandler
TIM1_CC_IRQHandler
TIM2_IRQHandler
TIM3_IRQHandler
TIM4_IRQHandler
I2C1_EV_IRQHandler
I2C1_ER_IRQHandler
I2C2_EV_IRQHandler
I2C2_ER_IRQHandler
SPI1_IRQHandler
SPI2_IRQHandler
USART1_IRQHandler
USART2_IRQHandler
USART3_IRQHandler
EXTI15_10_IRQHandler
RTC_Alarm_IRQHandler
USBWakeUp_IRQHandler

                B .

                ENDP

                ALIGN

;*******************************************************************************
; User Stack and Heap initialization
;*******************************************************************************

                 END

;************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE*****
