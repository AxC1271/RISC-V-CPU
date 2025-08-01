# RISC-V CPU FPGA Implementation
Welcome to the RISC-V CPU FPGA Implementation project! Inspired by my computer architecture course at Case Western, this project aims to design and implement a processor based on the RISC-V architecture using VHDL.

## 🧠 Overview 
This project involves creating a RISC-V compatible CPU on an FPGA, focusing on the hardware components and CPU architecture. The CPU follows the standard instruction cycle: fetch → decode → execute → memory access → write-back, interacting with RAM to store computation results.

## ⚙️ CPU Architecture Theory
<img src="./riscv-architecture.png" />

### Instruction Memory
The instruction memory is crucial for loading instructions onto the FPGA via UART. It works in tandem with a receiver that writes to memory whenever the valid flag is asserted. The program counter (PC) reads the address of the instruction, which is then pipelined into the instruction register and control unit.

### Register File
The register file consists of 32 registers, each 32 bits wide. It uses a 5-bit standard logic vector to index the registers and includes:
- Two read addresses
- A write enable input
- A write address
- A 32-bit wide read value

### Program Counter
The program counter is a register that stores the current instruction address (in bytes) and increments by 4 or by whatever immediate value from a branch/jump instruction. For this project, since I'm not using byte addressing and just plain word addressing, the increment is 1.

### Control Unit
The control unit processes the instruction fetched from the instruction memory and sends out the appropriate control flags to the rest of the CPU. This includes ALU opcodes, writing to the appropriate registers, and reading from the correct memory address.

### Immediate Generator
The immediate generator takes in the instruction as a separate unit and derives the immediate from checking the opcode of the instruction. There's a multiplexer where the output of this gets passed through, which is allowed to propagate based on appropriate control signals from the control unit.

### Arithmetic Logic Unit
The ALU performs all mathematical computations within the CPU, including addition, subtraction, bitwise operations, and more.

### Datapath
The datapath takes the results from the ALU and control flags to determine where to write back to the register files, completing the CPU execution cycle.

## 🖥️ Software Implementation
Eventually, the goal is to take any simple C code (for the video demo we'll use the following provided C code) and convert it to the 32-bit instructions necessary for the CPU to perform calculations.

```C
int main() {
   int a = 0;
   int b = 1;
   int sum = 1;

   for (int i = 0; i < 10; i++) {
      sum = a + b;
      a = b;
      b = sum;
      printf("%d\n", sum);
   }
   return 0;
}
```

## 📹 Video Demo

**[Watch the working demo here](https://youtu.be/ghEym8AjQQo)** of the RISC-V processor handling the assembly code. I want the FPGA board to "print" the first ten Fibonacci numbers.

## ⚠️ Limitations

This is a CPU running one instruction per program counter cycle but has no multi-stage pipelining, branch predictions, etc. to optimize the hardware to execute instructions as fast as possible. The reason I opted for the 1 Hz program counter was to:

- Visually see the program counter update incrementally using the Basys3 LED's
- Easily validate the seven-seg output from the multiplexer module
- Focus on the instruction decoding, computation, and writeback stages
- No way of handling data hazards (RAW hazards for example)

Despite these limitations, the CPU is still able to execute instructions in sequential order and handle branch jumps as shown in the video demo. For a future project, optimization techniques such as the ones listed above will be considered to improve overall hardware performance. Since the clock frequency is so slow, the lack of such features wouldn't impact functionality.

In regards to data hazards,:
```asm
; define x0 as the zero register  
; define x1 as the first Fibonacci number (a)
; define x2 as the second Fibonacci number (b)  
; define x3 as the temp printed value (fib)
; define x4 as i
; define x5 as limit of loop
0.  addi x1, x0, 0   ; a = 0
1.  addi x2, x0, 1   ; b = 1  
2.  addi x4, x0, 0   ; i = 0
3.  addi x5, x0, 10  ; loop limit = 10
4.  beq x4, x5, 7    ; if i == 10, branch 7 instructions ahead
5.  add x3, x1, x2   ; fib = a + b
6.  addi x1, x2, 0   ; a = b
7.  addi x2, x3, 0   ; b = fib  
8.  prnt x3          ; print fib, defined custom opcode as "1111111"
9.  addi x4, x4, 1   ; i++
10. beq x0, x0, -6   ; goto loop condition check
11. prnt x3          ; print last Fibonacci number
12. beq x0, x0, -1   ; infinite loop printing last value
```

This was the old assembly code that I wrote for this CPU and the massive problem was on line 9: `addi x4, x4, 0`. Since my register file was clocked and reg_writes were updated on the rising edge of the clock, this meant that register '0x00000004' was incremented by 1 at least a couple million times, meaning that the BEQ condition on line 4 was never satisfied, therefore the Fibonacci sequence repeated itself infinitely, which was not what I wanted.


--- 

Please go into each subproject folder to see more in detail.
