# UART-transmitter-and-reciever
UART Transmitter and Receiver

Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system using Verilog HDL. It contains both a UART transmitter and receiver for serial communication of 8-bit data.

Features

- 8-bit data transmission
- UART transmitter
- UART receiver
- Start bit and stop bit generation
- Serial data transmission
- Serial data reception
- Loopback testing
- Verilog testbench
- Simulation waveform generation

UART Frame Format

Each transmitted frame consists of:

| Start Bit | 8-bit Data | Stop Bit |
|     0     |   DATA     |    1     |

Files

UART-Transmitter-Receiver/
│
├── README.md
├── src/
│   └── uart_tx_rx.v
├── testbench/
│   └── uart_tb.v
└── simulation/
    └── uart_simulation.vcd

Working

The transmitter converts parallel 8-bit data into a serial UART frame. It first sends a logic "0" start bit, followed by the 8 data bits, and finally a logic "1" stop bit.

The receiver detects the start bit, samples the incoming serial data, reconstructs the 8-bit data, and indicates when the complete byte has been received.

Simulation

The testbench sends an 8-bit data value through the UART transmitter and connects the transmitter output to the receiver input using a loopback connection.

The simulation verifies that the receiver correctly reconstructs the transmitted data.

Tools

- Verilog HDL
- Icarus Verilog / ModelSim / QuestaSim
- GTKWave

Applications

- Serial communication
- Embedded systems
- FPGA projects
- Microcontroller communication
- Hardware communication interfaces

Author

Created as a digital design / Verilog HDL project for learning and simulation.
author: Sai teja sree 
