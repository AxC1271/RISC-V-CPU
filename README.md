# MIPS-CPU FPGA Implementation using VHDL

Hi!

After taking a computer architecture course at Case Western, I felt inspired to design and write my own processor using the MIPS architecture. This project is divided into two stages: software and hardware. 

# Overview

The software component consists of a compiler/assembler that converts some C code based string such as:

int a = 5; </br>
int b = 3; </br>
int c = a + b; </br>
printf(c, %d); </br>

and turns that code into 32-bit instructions. These 32-bit instructions are then transmitted serially via UART from my Mac laptop to the FPGA board in 4 packets(each packet being 8 bits) per instruction. 

The hardware component consists of the actual CPU architecture + a UART receiver that can receive the transmitted instructions and writes to memory the instructions for any particular program. 

# Theory

# Experiment

# Deliverables
