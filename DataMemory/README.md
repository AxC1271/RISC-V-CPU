# Data Memory

Welcome to the Data Memory module of this RISC-V processor project. This component is responsible for storing and retrieving data during program execution, facilitating load and store operations. Below, you'll find an overview of the data memory's functionality, development process, and theoretical background.

## Overview
The data memory is a crucial element in the CPU architecture, providing a space for data storage and access. It interacts with the CPU to perform load and store operations, enabling the processor to handle variables, arrays, and other data structures efficiently.

## Functionality
- **Address Input:** Specifies the memory location to read from or write to, typically derived from the result of an ALU operation.
- **MemRead:** A control signal indicating whether a read operation should be performed.
- **MemWrite:** A control signal indicating whether a write operation should be performed.
- **Write Data:** The data to be written to memory during a store operation.
- **Read Data:** The data read from memory during a load operation.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(31 downto 0); -- memory address
        write_data : in STD_LOGIC_VECTOR(31 downto 0); -- data to write
        mem_write : in STD_LOGIC; -- write enable
        mem_read : in STD_LOGIC; -- read enable
        read_data : out STD_LOGIC_VECTOR(31 downto 0) -- data read from memory
    );
end data_memory;

architecture Behavioral of data_memory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal memory : memory_array := (others => (others => '0'));
begin
    process(clk, rst)
    begin
        if rst = '1' then
            memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if mem_write = '1' then
                memory(to_integer(unsigned(address))) <= write_data;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if mem_read = '1' then
                read_data <= memory(to_integer(unsigned(address)));
            else
                read_data <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;

```

### Testing

Here's the test bench file for the data memory module.

Here's the waveform to ensure proper behavior for the data memory module.

## Theoretical Background

### Purpose
The data memory is essential for storing and accessing data during program execution. By providing a space for data storage, it enables the CPU to handle variables, arrays, and other data structures efficiently.

### Operations
- Load: Retrieves data from specified memory locations using the address input.
- Store: Writes data to specified memory locations using the address input.

## Importance
An efficient data memory design is crucial for optimizing CPU performance, as it directly impacts the speed and accuracy of data access and manipulation. Understanding the interaction between the CPU and data memory is key to implementing a RISC-V processor.
