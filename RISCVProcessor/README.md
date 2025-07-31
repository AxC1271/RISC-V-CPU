# RISC-V Processor

Welcome to the top-level `RISC-V processor` module of this RISC-V CPU project. This module brings together all critical components—control logic, arithmetic units, memory, and I/O—to form a fully functioning single-cycle RISC-V CPU. It is designed with modularity, clarity, and debugging features in mind.

## 🧠 Overview
The RISC-V processor module acts as the central hub for instruction execution. It connects submodules such as the program counter, control unit, ALU, register file, and data memory to process instructions based on the RISC-V ISA. It also integrates a seven-segment display and LED-based debugging support for observing runtime values like instruction count and printf outputs.

## ⚙️ Functionality

- **Instruction Execution**: Orchestrates instruction fetch, decode, execute, memory access, and write-back.
- **PC Control**: Uses a clock divider to slow execution for step-by-step debugging.
- **Branching & Jumping**: Supports branching logic through multiplexers and control signals.
- **Memory Access**: Interfaces with instruction and data memory modules.
- **Display Output**: Shows memory-mapped printf-style output on a 7-segment display.
- **Instruction Count Debugging**: Uses 16 on-board LEDs to show number of executed instructions.

## 🧪 Testing

Simulation and hardware debugging strategies:

- Preload instructions into memory.
- Use waveform viewer in Vivado to observe PC, ALU, and register values.
- Monitor:
  - PC and instruction progression.
  - LED display for instruction counter.
  - 7-segment output for printf values.

When deployed on hardware, the 2 Hz slow clock allows visual step-by-step execution of instructions using visible LEDs and 7-segment display output.

### Script for the CPU
Here's the C code for our Fibonacci sequence. To find how I derived the 32-bit instructions in binary, check out the [InstructionMemory](../InstructionMemory) module.

```C
// Simple C program to print out the Fibonacci sequence
int main() {
    int a = 0;
    int b = 1;
    int fib = 0;

    for (int i = 0; i < 11; i++) {
        fib = a + b;
        a = b;
        b = fib;
        printf("%d\n", fib);
    }

  return 0;
}
```
<br/>

```
// Converted Binary Instructions
0      => x"00000093", -- addi x1, x0, 0
1      => x"00100113", -- addi x2, x0, 1
2      => x"00000213", -- addi x4, x0, 0
3      => x"00B00293", -- addi x5, x0, 11
4      => x"00520763", -- beq x4, x5, 7
5      => x"002081B3", -- add x3, x1, x2
6      => x"00010093", -- addi x1, x2, 0
7      => x"00018113", -- addi x2, x3, 0
8      => x"0001807F", -- prnt x3
9      => x"00120213", -- addi x4, x4, 1
10     => x"FE000AE3", -- beq x0, x0, -6, wrap around
11     => x"0001807F", -- prnt x3 ; this should stop at 144!
12     => x"FE000FE3", -- beq x0, x0, -1
others => x"00000000"
```

## 💡 Importance
This top-level module:

- Integrates and coordinates the entire RISC-V CPU pipeline.

- Provides observable hardware debugging tools.

- Enables hands-on education in ISA-level design and hardware-software integration.

- Serves as a template for expanding the CPU with pipelining, caching, or interrupt handling.

## 🛠️ Requirements
- Vivado or compatible VHDL toolchain

- Basys 3 FPGA (or compatible board with 7-seg and LED output)

- Simulation testbench files

- Instruction binary for loading into memory

## ▶️ Video Demo

**[Watch the working demo](https://youtu.be/ghEym8AjQQo)** of the RISC-V processor handling the following assembly file. I want the FPGA board to "print" the first ten Fibonacci numbers.

## 🎢 Next Steps
The current implementation of the processor handles instruction fetching, decoding, computation, and writeback all within a single clock cycle. As a result, the clock cycle must be slow enough to ensure that clock slack is negligible. For the scope of this project, this wasn't an issue and the CPU worked as expected.

To optimize and accelerate the hardware, several techniques can be employed:
- Branch Predictors: Improve instruction flow by predicting the outcome of branches, reducing stalls and increasing  throughput.
- Vector Processing: Enhance data parallelism by executing vector instructions, which can significantly speed up computations involving large data sets.
- Multi-Stage Pipelining: Break down instruction processing into multiple stages, allowing for simultaneous execution of different instructions and improving overall throughput.
- Cache Hierarchy (L1, L2 caching): Implement a cache hierarchy to reduce memory access times, thereby increasing the efficiency of data retrieval and storage.
- Compiler Integration: It is a pain to write the assembly code and then convert it into 32-bit instructions by hand. There are open-source toolchains out there but writing a compiler from scratch and customizing it to my ISA would streamline the generation of instructions.

These techniques are commonly used by modern processors to optimize their CPI (cycles per instruction). In a later project, I plan to adapt these techniques to develop a more efficient processor in the future.

---

Thanks for stopping by and reading through this project!
