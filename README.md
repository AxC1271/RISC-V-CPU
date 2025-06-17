# MIPS-CPU FPGA Implementation using VHDL Overview
After taking a computer architecture course at Case Western, I was inspired to design and implement a processor based on the MIPS architecture. This project is divided into two main components: software (compiler/assembler + UART communication) and hardware (CPU implementation on FPGA).

## Software Approach
The software component consists of a compiler that translates simplified C-style code such as:
```c
#include <stdio.h>

int main() {
    int a = 5; 
    int b = 3; 
    int c = a + b; 
    printf("%d\n", c); 
    return 0;
}
```

into 32-bit MIPS machine instructions. These instructions are then transmitted from my Mac to the FPGA over UART using the Python pyserial library.
Each 32-bit instruction is divided into four 8-bit packets (bytes) for serial transmission.

## Hardware Approach
The hardware component includes:
- A UART receiver that collects incoming 8-bit packets and reconstructs them into 32-bit instructions.
- An instruction memory (RAM) that stores the uploaded program.
- A MIPS-compatible CPU written in VHDL, which begins execution once all instructions are received. </br>
</br>
The CPU follows the standard instruction cycle: fetch → decode → execute → memory access → write-back, and interacts with RAM to store computation results.

## Compiler Design
<figure>
  <p align="center">
    <img src="images/compilation.jpeg">
  </p>
  <p align="center"><em>Credit goes to Arseny Morozov for this picture.</em></p>
</figure>

### Lexer

### Parser

### Semantic Analyzer

### IR (Intermediate Representation) Generator

### Optimizer

### Code Generation

### Linker


## CPU Architecture Design
<figure>
  <p align="center">
    <img src="images/MIPS.jpg">
  </p>
  <p align="center"><em>MIPS CPU Architecture.</em></p>
</figure>

### Instruction Memory
The instruction memory is where the instructions get loaded onto the FPGA via UART. This entity acts in tandem with a receiver that writes to memory every time the valid flag gets asserted. It also takes the pc for reading the address of the instruction which later gets pipelined into the instruction register → control unit.

### Register File
In this project, the register file contains 32 registers, each being 32 bits wide. The address is a 5 bit standard logic vector that indexes the registers, and the register file includes two read addresses, a write enable input, a write address, and a 32-bit wide read value.

### Program Counter
The program counter is a register that stores the current instruction address (in bytes) and increments by 4 once the instruction has been completed in the CPU.

### Control Unit
The control unit takes the instruction fetched from the instruction memory and sends out the appropriate control flags to the rest of the CPU, such as the ALU opcodes, writing to the appropriate registers, and reading from the correct memory address.

### Arithmetic Logic Unit
The arithmetic logic unit (or ALU) performs all mathematical computations within the CPU, such as adding, subtracting, bitwise operations, etc.


## Experiment

## Deliverables
