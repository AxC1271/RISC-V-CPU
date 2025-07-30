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

### Block Diagram


### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv_processor is
    port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        ade : out STD_LOGIC_VECTOR (3 downto 0);
        led : out STD_LOGIC_VECTOR (11 downto 0)
    );
end riscv_processor;

architecture Behavioral of riscv_processor is
    component adder is
        port (
            op1 : in STD_LOGIC_VECTOR(31 downto 0);
            op2 : in STD_LOGIC_VECTOR(31 downto 0);
            sum : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component mux is
        port (
            input1 : in STD_LOGIC_VECTOR(31 downto 0);
            input2 : in STD_LOGIC_VECTOR(31 downto 0);
            sel : in STD_LOGIC;
            mux_output : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component program_counter is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            enable : in STD_LOGIC;
            pc_src : in STD_LOGIC_VECTOR(31 downto 0);
            pc : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component instruction_memory is
        port (
            pc : in STD_LOGIC_VECTOR(11 downto 0);
            instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component register_file is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            read_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
            read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);
            write_addr : in STD_LOGIC_VECTOR(4 downto 0);
            write_data : in STD_LOGIC_VECTOR(31 downto 0);
            reg_write : in STD_LOGIC;
            read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
            read_data2 : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component immediate_generator is
        port (
            instruction : in STD_LOGIC_VECTOR(31 downto 0);
            immediate : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component control_unit is
        port (
            opcode : in STD_LOGIC_VECTOR(6 downto 0);
            funct3 : in STD_LOGIC_VECTOR(2 downto 0);
            funct7 : in STD_LOGIC_VECTOR(6 downto 0);
            RegWrite : out STD_LOGIC;
            MemRead : out STD_LOGIC;
            MemWrite : out STD_LOGIC;
            BranchEq : out STD_LOGIC;
            memToReg : out STD_LOGIC;
            AluSrc : out STD_LOGIC;
            ALUCont : out STD_LOGIC_VECTOR(2 downto 0);
            jmp : out STD_LOGIC;
            print : out STD_LOGIC
        );
    end component;
    
    component alu is
        port (
            op1 : in STD_LOGIC_VECTOR(31 downto 0);
            op2 : in STD_LOGIC_VECTOR(31 downto 0);
            opcode : in STD_LOGIC_VECTOR(2 downto 0);
            res : out STD_LOGIC_VECTOR(31 downto 0);
            zero_flag : out STD_LOGIC
        );
    end component;
    
    component data_memory is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR(31 downto 0);
            write_data : in STD_LOGIC_VECTOR(31 downto 0);
            mem_write : in STD_LOGIC;
            mem_read : in STD_LOGIC;
            read_data : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component seven_seg_mux is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            print : in STD_LOGIC;
            val : in STD_LOGIC_VECTOR(31 downto 0);  
            seg : out STD_LOGIC_VECTOR(6 downto 0);  
            ade : out STD_LOGIC_VECTOR(3 downto 0)   
        );
    end component;
    signal pc_enable : STD_LOGIC := '0';
    signal pc_i : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_next : STD_LOGIC_VECTOR(31 downto 0);
    signal branch_target : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_src_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    signal curr_inst : STD_LOGIC_VECTOR(31 downto 0);
    signal immediate_i : STD_LOGIC_VECTOR(31 downto 0);
    signal write_data_i, read_data1_i, read_data2_i : STD_LOGIC_VECTOR(31 downto 0);
    
    signal cu_regwrite, memread_i, memwrite_i, brancheq_i, memtoreg_i, alusrc_i, jmp_i, print_i : STD_LOGIC;
    signal alucont_i : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_op2 : STD_LOGIC_VECTOR(31 downto 0);
    signal res_i : STD_LOGIC_VECTOR(31 downto 0);
    signal zero_flag_i : STD_LOGIC;  
    
    signal dm_read_data : STD_LOGIC_VECTOR(31 downto 0);

begin
    clk_enable_gen : process(clk, rst) 
        variable clk_cnt : integer range 0 to 50_000_000 := 0;
    begin
        if rst = '1' then
            clk_cnt := 0;
            pc_enable <= '0';
        elsif rising_edge(clk) then
            if clk_cnt = 50_000_000 then  
                clk_cnt := 0;
                pc_enable <= '1';
            else
                pc_enable <= '0';
                clk_cnt := clk_cnt + 1;
            end if;
        end if;
    end process clk_enable_gen;
    
    branch_decision : process(clk, rst)
    begin
        if rst = '1' then
            pc_src_reg <= (others => '0');
        elsif rising_edge(clk) then
            if (brancheq_i and zero_flag_i) = '1' then
                pc_src_reg <= branch_target;  
            else
                pc_src_reg <= pc_next;        
            end if;
        end if;
    end process branch_decision;

PC : program_counter 
    port map (
        clk => clk,         
        rst => rst,
        enable => pc_enable,
        pc_src => pc_src_reg,
        pc => pc_i
    );
    
    PC_ADDER : adder
        port map (
            op1 => pc_i,
            op2 => X"00000001",  
            sum => pc_next
        );
    
    BRANCH_ADDER : adder
        port map (
            op1 => pc_i,
            op2 => immediate_i,
            sum => branch_target
        );
        
    IM : instruction_memory
        port map (
            pc => pc_i(11 downto 0),
            instruction => curr_inst
        );
        
    RF : register_file
        port map (
            clk => clk,
            rst => rst,
            read_addr1 => curr_inst(19 downto 15), -- rs1
            read_addr2 => curr_inst(24 downto 20), -- rs2
            write_addr => curr_inst(11 downto 7),  -- rd
            write_data => write_data_i,
            reg_write => cu_regwrite,  
            read_data1 => read_data1_i,
            read_data2 => read_data2_i
        );
    
    IG : immediate_generator 
        port map (
            instruction => curr_inst,
            immediate => immediate_i
        );
        
    CU : control_unit
        port map (
            opcode => curr_inst(6 downto 0),
            funct3 => curr_inst(14 downto 12),
            funct7 => curr_inst(31 downto 25),
            RegWrite => cu_regwrite,
            MemRead => memread_i,
            MemWrite => memwrite_i,
            BranchEq => brancheq_i,
            memToReg => memtoreg_i,
            ALUSrc => alusrc_i,
            ALUCont => alucont_i,
            jmp => jmp_i,
            print => print_i
        );

    ALU_MUX : mux
        port map (
            input1 => read_data2_i,
            input2 => immediate_i,   
            sel => alusrc_i,
            mux_output => alu_op2
        );
        
    ALU_INST : alu 
        port map (
            op1 => read_data1_i,
            op2 => alu_op2,
            opcode => alucont_i,
            res => res_i,
            zero_flag => zero_flag_i
        );
        
    DM : data_memory 
        port map (
            clk => clk,
            rst => rst,
            address => res_i,
            write_data => read_data2_i,
            mem_write => memwrite_i,
            mem_read => memread_i,
            read_data => dm_read_data
        );
    
    WB_MUX : mux
        port map (
            input1 => res_i,        
            input2 => dm_read_data, 
            sel => memtoreg_i,
            mux_output => write_data_i
        );
    
    DISPLAY : seven_seg_mux
        port map (
            clk => clk,
            rst => rst,
            print => print_i,
            val => read_data1_i,
            seg => seg,
            ade => ade
        );
    
    -- LED output shows lower 12 bits of PC
    led <= pc_i(11 downto 0);

end Behavioral;
```

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
