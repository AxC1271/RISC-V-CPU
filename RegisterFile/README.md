# Register File

Welcome to the RegisterFile module of this RISC-V processor project. This component allows for the storage and access of data during CPU operations. Below, you'll find an overview of the register file's functionality, development process, and theoretical background.

## Overview
The register file is a key element in the CPU architecture, consisting of 32 registers, each 32 bits wide. It serves as a fast-access storage area for the CPU, allowing efficient data manipulation and retrieval during instruction execution.

## Functionality
- Registers: 32 registers, each 32 bits wide, for storing data
- Addressing: Utilizes a 5-bit standard logic vector to index the registers
- Two read addresses for accessing register values
- A write enable input to control data writing
- A write address to specify the target register for data storage
- A 32-bit wide read value for data retrieval

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V Register File
-- 32 registers, each 32 bits wide
-- Register x0 always reads as zero and ignores writes
entity register_file is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        read_addr1 : in STD_LOGIC_VECTOR(4 downto 0); -- 5 bit address for rs1
        read_addr2 : in STD_LOGIC_VECTOR(4 downto 0); -- 5 bit address for rs2
        
        write_addr : in STD_LOGIC_VECTOR(4 downto 0);  -- 5 bit address for rd
        write_data : in STD_LOGIC_VECTOR(31 downto 0); -- 32 bit data to write
        reg_write : in STD_LOGIC;                      -- write enable
        
        read_data1: out STD_LOGIC_VECTOR(31 downto 0); -- output for rs1
        read_data2 : out STD_LOGIC_VECTOR(31 downto 0) -- output for rs2
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
    
    -- useful constants
    constant ZERO_REG : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    
begin
    -- read logic with x0 handling and write forwarding
    read_data1 <= write_data when (reg_write = '1' and read_addr1 = write_addr and read_addr1 /= ZERO_REG) else
                  (others => '0') when read_addr1 = ZERO_REG else
                  registers(to_integer(unsigned(read_addr1)));
                  
    read_data2 <= write_data when (reg_write = '1' and read_addr2 = write_addr and read_addr2 /= ZERO_REG) else
                  (others => '0') when read_addr2 = ZERO_REG else
                  registers(to_integer(unsigned(read_addr2)));
    
    -- write process
    process(clk, rst)
    begin
        if rst = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            -- only write if reg_write is enabled and not writing to x0
            if reg_write = '1' and write_addr /= ZERO_REG then
                registers(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;
    
end Behavioral;
```
</div>


### Testing
Here's the testbench that we are using to validate the behavior of the register file module.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_tb is
end register_file_tb;

architecture Behavioral of register_file_tb is
  -- define the component under test
  component register_file 
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

  -- define all intermediary signals here
  signal clk, rst : STD_LOGIC := '0';
  signal read_addr1, read_addr2, write_addr : STD_LOGIC_VECTOR(4 downto 0);
  signal reg_write : STD_LOGIC := '0';
  signal write_data : STD_LOGIC_VECTOR(31 downto 0);
  signal read_data1, read_data2 : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : register_file
    port map (
      clk => clk,
      rst => rst,
      read_addr1 => read_addr1,
      read_addr2 => read_addr2,

      write_addr => write_addr,
      write_data => write_data,
      reg_write => reg_write,

      read_data1 => read_data1,
      read_data2 => read_data2
    );

  -- simulate process
  stimulus: process
  begin
    -- apply reset
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10 ns;

    -- test case #1: Write to reg 1
    write_addr <= "00001";
    write_data <= x"00000001";
    reg_write <= '1';
    wait for 10 ns;

    -- test case #2: Write to reg 2
    reg_write <= '0';
    write_addr <= "00010";
    write_data <= x"00FF89D5";
    reg_write <= '1';
    wait for 10 ns;

    -- test case #3: Write to reg 0 (should remain zero)
    reg_write <= '0';
    write_addr <= "00000";
    write_data <= x"01010101";
    reg_write <= '1';
    wait for 10 ns;

    -- read from reg 1
    read_addr1 <= "00001";
    wait for 10 ns;
    assert read_data1 = x"00000001" report "Read from reg 1 failed" severity error;

    -- read from reg 2
    read_addr2 <= "00010";
    wait for 10 ns;
    assert read_data2 = x"00FF89D5" report "Read from reg 2 failed" severity error;

    -- read from reg 0 (should be zero)
    read_addr1 <= "00000";
    wait for 10 ns;
    assert read_data1 = x"00000000" report "Read from reg 0 failed" severity error;

    -- end simulation
    wait;
  end process stimulus;

  -- clock generation process
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end loop;
  end process clk_process;

end Behavioral;
```

Here are the waveforms on Vivado to show proof of correctness.

## Theoretical Background

### Purpose
The register file acts as a temporary storage area for the CPU, allowing quick access to frequently used data. It plays a vital role in executing instructions efficiently by minimizing memory access delays.
### Operations
- Read: retrieve data from specified registers using read addresses
- Write: store data into a specified register when write enable is active

## Importance
Efficient register file design is crucial for optimizing CPU performance, as it directly impacts the speed and efficiency of instruction execution.
