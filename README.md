# UART Controller Design in Verilog

This project implements a full-duplex UART (Universal Asynchronous Receiver-Transmitter) controller on an FPGA.

## Features:
- Transmitter with Start, Data, and Stop bit generation.
- Receiver with oversampling logic for noise immunity.
- Configurable Baud Rate Generator.

## Architecture:
- FSM-based design for both TX and RX.
- Developed and verified using Xilinx Vivado.

## Project Structure:
- `uart_top.v`: Top-level module.
- `uart_tx.v`: Transmitter module.
- `uart_rx.v`: Receiver module.
- `baud_gen.v`: Baud rate generator.
- `tb_uart.v`: Testbench for functional verification.

## Documentation:
Included state diagrams and tables for the FSM logic in the repository.
