# Register File

Welcome to the Program Counter module of this RISC-V processor project. This component is responsible for tracking the current instruction address during CPU operations. Below, you'll find an overview of the program counter's functionality, development process, and theoretical background.

## Overview
The program counter is a crucial element in the CPU architecture, responsible for maintaining the address of the current instruction being executed. It ensures the sequential flow of instruction execution by incrementing the address after each instruction cycle.

## Functionality
- **Address Storage:** Holds the address of the current instruction in bytes.
- **Increment:** Automatically increments by 4 after each instruction, pointing to the next instruction.
- **Reset:** Can be reset to a specific address, typically the start of the program.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V Program Counter
-- Handles sequential instruction fetch and branch/jump operations
-- PC increments by 4 bytes (32-bit instructions) each cycle unless overridden
entity program_counter is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pc_write : in STD_LOGIC;                    -- enable PC update (for pipeline stalls)
        pc_src : in STD_LOGIC_VECTOR(31 downto 0);  -- new PC value from branch/jump
        branch_taken : in STD_LOGIC;                -- signal indicating branch/jump taken
        pc : out STD_LOGIC_VECTOR(31 downto 0)      -- current PC value
    );
end program_counter;

architecture Behavioral of program_counter is
    signal curr_pc : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    constant RESET_PC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
begin
    -- PC update process
    process(clk, rst)
    begin
        if rst = '1' then
            curr_pc <= RESET_PC;
        elsif rising_edge(clk) then
            if pc_write = '1' then
                if branch_taken = '1' then
                    -- branch or jump taken - overwrite existing PC
                    curr_pc <= pc_src;
                else
                    -- next sequential instruction
                    curr_pc <= STD_LOGIC_VECTOR(unsigned(curr_pc) + 1);
                end if;
            end if;
            -- if pc_write = '0', PC stays the same
        end if;
    end process;
    
    -- output current PC
    pc <= curr_pc;
    
end Behavioral;
```
</div>
Generally speaking, the increment for a program counter is always 4 bytes since every instruction is 32 bits long. However, since the instruction memory module uses an array with each entry being a STD_LOGIC_VECTOR with a width of 32 bits, this is not necessary but useful to keep in mind.

### Testing
Here's the test bench for our program ocunter to ensure correctness and ideal behavior.

## Theoretical Background

### Purpose
The program counter is essential for controlling the flow of instruction execution in the CPU. By maintaining and updating the instruction address, it ensures that the CPU processes instructions in the correct sequence.

### Operations
- Increment: Automatically advances to the next instruction address after each cycle.
- Reset: Can be set to a specific address to start execution from a new point, useful for program initialization or branching.

## Importance
An efficient program counter design is crucial for optimizing CPU performance, as it directly impacts the control flow and execution speed of instructions.

