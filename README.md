# RISC-V CPU FPGA Implementation using VHDL Overview
Welcome to the RISC-V CPU FPGA Implementation project! Inspired by my computer architecture course at Case Western, this project aims to design and implement a processor based on the RISC-V architecture using VHDL.

## Overview 
This project involves creating a RISC-V compatible CPU on an FPGA, focusing on the hardware components and CPU architecture. The CPU follows the standard instruction cycle: fetch → decode → execute → memory access → write-back, interacting with RAM to store computation results.

## Hardware Approach
The hardware component includes:
- Instruction Memory (RAM): Stores the uploaded program and interacts with the CPU during execution.
- RISC-V Compatible CPU: Written in VHDL, the CPU begins execution once all instructions are received.
</br>
The CPU follows the standard instruction cycle: fetch → decode → execute → memory access → write-back, and interacts with RAM to store computation results.


## CPU Architecture Theory

### Instruction Memory
The instruction memory is crucial for loading instructions onto the FPGA via UART. It works in tandem with a receiver that writes to memory whenever the valid flag is asserted. The program counter (PC) reads the address of the instruction, which is then pipelined into the instruction register and control unit.

### Register File
The register file consists of 32 registers, each 32 bits wide. It uses a 5-bit standard logic vector to index the registers and includes:
- Two read addresses
- A write enable input
- A write address
- A 32-bit wide read value

### Program Counter
The program counter is a register that stores the current instruction address (in bytes) and increments by 4 once the instruction has been completed in the CPU.

### Control Unit
The control unit processes the instruction fetched from the instruction memory and sends out the appropriate control flags to the rest of the CPU. This includes ALU opcodes, writing to the appropriate registers, and reading from the correct memory address.

### Arithmetic Logic Unit
The ALU performs all mathematical computations within the CPU, including addition, subtraction, bitwise operations, and more.

### Datapath
The datapath takes the results from the ALU and control flags to determine where to write back to the register files, completing the CPU execution cycle.

---

Please go into each subproject folder to see more in detail.
