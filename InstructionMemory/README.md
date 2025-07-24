# Instruction Memory

Welcome to the Instruction Memory module of this RISC-V processor project. This component is responsible for storing and providing instructions to the CPU during execution. Below, you'll find an overview of the instruction memory's functionality, development process, and theoretical background.

## Overview
The instruction memory is a crucial element in the CPU architecture, holding the program's instructions and supplying them to the CPU as directed by the program counter. It ensures that the CPU has access to the correct instructions for execution.

## Functionality
- **Instruction Storage:** Contains a predefined set of instructions stored in memory.
- **Instruction Fetch:** Provides the current instruction based on the program counter's address.
- **Reset:** Can reset the output instruction to zero, ensuring a known state.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pc : in STD_LOGIC_VECTOR(31 downto 0);  -- input from program counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    constant instruction_memory : memory_array := (
        0 => x"00400093",  -- example instructions
        1 => x"00800113",
        2 => x"00A00193",
        others => (others => '0')
    );

begin
    process(clk, rst)
    begin
        if rst = '1' then
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            -- use the program counter to fetch the instruction
            -- since the pc is incrementing by 4, exclude the last 2 bits
            -- so that we're effectively adding by 1 as indices
            instruction <= instruction_memory(to_integer(unsigned(pc(31 downto 2))));
        end if;
    end process;
end Behavioral;
```

### Testing
Here, I've provided the test bench to test the module.

```VHDL
# Instruction Memory

Welcome to the Instruction Memory module of this RISC-V processor project. This component is responsible for storing and providing instructions to the CPU during execution. Below, you'll find an overview of the instruction memory's functionality, development process, and theoretical background.

## Overview
The instruction memory is a crucial element in the CPU architecture, holding the program's instructions and supplying them to the CPU as directed by the program counter. It ensures that the CPU has access to the correct instructions for execution.

## Functionality
- **Instruction Storage:** Contains a predefined set of instructions stored in memory.
- **Instruction Fetch:** Provides the current instruction based on the program counter's address.
- **Reset:** Can reset the output instruction to zero, ensuring a known state.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pc : in STD_LOGIC_VECTOR(31 downto 0);  -- input from program counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    constant instruction_memory : memory_array := (
        0 => x"00400093",  -- example instructions
        1 => x"00800113",
        2 => x"00A00193",
        others => (others => '0')
    );

begin
    process(clk, rst)
    begin
        if rst = '1' then
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            -- use the program counter to fetch the instruction
            -- since the pc is incrementing by 4, exclude the last 2 bits
            -- so that we're effectively adding by 1 as indices
            instruction <= instruction_memory(to_integer(unsigned(pc(31 downto 2))));
        end if;
    end process;
end Behavioral;
```

## Theoretical Background
### Purpose
The instruction memory is essential for storing the program's instructions and supplying them to the CPU for execution. By maintaining a set of instructions, it ensures that the CPU can perform operations as intended.

### Operations
- Fetch: Retrieves the current instruction based on the program counter's address.
- Reset: Ensures a known state by resetting the output instruction.

## Importance
An efficient instruction memory design is crucial for optimizing CPU performance, as it directly impacts the speed and accuracy of instruction execution. This README provides a structured overview of the instruction memory component, highlighting its role and functionality within the CPU architecture
