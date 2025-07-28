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
  - 7-segment output for printf values (`0xFFFF0000` address).

When deployed on hardware, the 1 Hz slow clock allows visual step-by-step execution of instructions using visible LEDs and 7-segment display output.

### Block Diagram
<img src="../riscv-architecture.png" />


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
    -- component declarations
    
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
            mux : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    component program_counter is
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pc_src : in STD_LOGIC_VECTOR(11 downto 0);
            pc : out STD_LOGIC_VECTOR(11 downto 0)
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
            immediate : out STD_LOGIC_VECTOR(11 downto 0)
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
            jmp : out STD_LOGIC
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
            val : in STD_LOGIC_VECTOR(31 downto 0);  
            seg : out STD_LOGIC_VECTOR(6 downto 0);  
            ade : out STD_LOGIC_VECTOR(3 downto 0)   
        );
    end component;
    
    -- internal signals
    signal pc_clk : STD_LOGIC := '0';
    signal pc_src_i : STD_LOGIC_VECTOR(11 downto 0);
    signal pc_i : STD_LOGIC_VECTOR(11 downto 0);
    signal pc_next : STD_LOGIC_VECTOR(11 downto 0);
    signal branch_target : STD_LOGIC_VECTOR(11 downto 0);
    
    signal curr_inst : STD_LOGIC_VECTOR(31 downto 0);
    signal immediate_i : STD_LOGIC_VECTOR(11 downto 0);
    signal write_data_i, read_data1_i, read_data2_i : STD_LOGIC_VECTOR(31 downto 0);
    
    signal cu_regwrite, memread_i, memwrite_i, brancheq_i, memtoreg_i, alusrc_i, jmp_i : STD_LOGIC;
    signal alucont_i : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_op2 : STD_LOGIC_VECTOR(31 downto 0);
    signal res_i : STD_LOGIC_VECTOR(31 downto 0);
    signal zero_flag_i : STD_LOGIC;  
    signal branch_taken : STD_LOGIC;
    
    signal dm_read_data : STD_LOGIC_VECTOR(31 downto 0);

begin
    -- clock divider for slower PC operation (2 Hz for debugging)
    clk_divider : process(clk, rst) 
        variable clk_cnt : integer range 0 to 25_000_000 := 0;
    begin
        if rst = '1' then
            clk_cnt := 0;
            pc_clk <= '0';
        elsif rising_edge(clk) then
            if clk_cnt = 25_000_000 then  
                clk_cnt := 0;
                pc_clk <= not pc_clk;
            else
                clk_cnt := clk_cnt + 1;
            end if;
        end if;
    end process clk_divider;
    
    -- component instantiations
    
    PC_ADDER : adder
        port map (
            op1 => (others => '0') & pc_i,
            op2 => X"00000001",  
            sum => (others => '0') & pc_next
        );
    
    BRANCH_ADDER : adder
        port map (
            op1 => (others => '0') & pc_i,
            op2 => (others => '0') & immediate_i,
            sum => branch_target
        );
    
    PC_MUX : mux
        port map (
            input1 => (others => '0') & pc_next,
            input2 => (others => '0') & branch_target,
            sel => branch_taken,
            mux_output => pc_src_i
        );
    
    PC : program_counter 
        port map (
            clk => pc_clk,
            rst => rst,
            pc_src => pc_src_i,
            pc => pc_i
        );
        
    IM : instruction_memory
        port map (
            pc => pc_i,
            instruction => curr_inst
        );
        
    RF : register_file
        port map (
            clk => clk,
            rst => rst,
            read_addr1 => curr_inst(19 downto 15),
            read_addr2 => curr_inst(24 downto 20),
            write_addr => curr_inst(11 downto 7),
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
            jmp => jmp_i
        );
    
    ALU_MUX : mux
        port map (
            input1 => read_data2_i,
            input2 => (others => '0') & immediate_i,
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
            val => read_data1_i,
            seg => seg,
            ade => ade
        );
    
    -- combinational logic
    branch_taken <= brancheq_i and zero_flag_i;
    
    -- LED output shows instruction counter
    led <= pc_i;

end Behavioral;
```

### Memory-Mapped I/O and Assembly
Writing to the address 0xFFFF0000 triggers a display update on the 7-segment, which will then mimic a simplified printf() behavior. Here's the C code for our Fibonacci sequence.

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

Here's the RISC-V assembly equivalent:
```asm
.text
.globl main

main:
    addi x5, x0, 0      # a = 0 (x5)
    addi x6, x0, 1      # b = 1 (x6) 
    addi x8, x0, 0      # i = 0 (x8)
    addi x9, x0, 10     # loop limit = 10 (x9)

loop:
    # branch greater than (i < 10)
    bge x8, x9, end     # if i >= 10, exit loop
    
    # sum = a + b
    add x7, x5, x6      # sum = a + b (x7)
    
    # a = b
    add x5, x6, x0      # a = b
    
    # b = sum  
    add x6, x7, x0      # b = sum
    
    # printf("%d\n", sum) - simplified as just storing sum
    # in real implementation, this would be a system call
    # i++
    addi x8, x8, 1      # i = i + 1
    
    # jump back to loop
    jal x0, loop        # goto loop
    
end:
    # return 0
    addi x10, x0, 0     # return value = 0
    # exit (would be system call in real implementation)            
```

If you translate that into the 32-bit binary instructions, you'll get:

```
# addi x5, x0, 0
000000000000_00000_000_00101_0010011

= 00000000000000000000001010010011

# addi x6, x0, 1  
000000000001_00000_000_00110_0010011

= 00000000000100000000001100010011

# addi x8, x0, 0
000000000000_00000_000_01000_0010011

= 00000000000000000000010000010011

# addi x9, x0, 10
000000001010_00000_000_01001_0010011

= 00000000101000000000010010010011

# bge x8, x9, end (assuming end is 20 bytes ahead)
0000000_01001_01000_101_10100_1100011

= 00000000100101000101101001100011

# add x7, x5, x6
0000000_00110_00101_000_00111_0110011

= 00000000011000101000001110110011

# add x5, x6, x0
0000000_00000_00110_000_00101_0110011

= 00000000000000110000001010110011

# add x6, x7, x0
0000000_00000_00111_000_00110_0110011

= 00000000000000111000001100110011

# addi x8, x8, 1
000000000001_01000_000_01000_0010011

= 00000000000101000000010000010011

# jal x0, loop (jumping back -36 bytes)
11111111111111011100_00000_1101111

= 11111111111111011100000001101111

# addi x10, x0, 0
000000000000_00000_000_01010_0010011

= 00000000000000000000010100010011
```

Finalized 32-bit instructions:
```
x00000285  # addi x5, x0, 0
x00100313  # addi x6, x0, 1
x00000413  # addi x8, x0, 0
x00A00493  # addi x9, x0, 10
x00945463  # bge x8, x9, end
x006283B3  # add x7, x5, x6
x000302B3  # add x5, x6, x0
x00038333  # add x6, x7, x0
x00140413  # addi x8, x8, 1
xFDDFF06F  # jal x0, loop
x00000513  # addi x10, x0, 0
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

## Video Demo

Here, I've provided a working demo of the RISC-V processor handling the following assembly file. I want the FPGA board to "print" the first ten Fibonacci numbers.

