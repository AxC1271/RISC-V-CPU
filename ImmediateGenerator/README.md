# Immediate Generator

Welcome to the Immediate Generator module of this RISC-V processor project. This component is responsible for extracting and sign-extending immediate values from instructions, which are used in various operations such as arithmetic calculations, memory addressing, and control flow changes. Below, you'll find an overview of the immediate generator's functionality, development process, and theoretical background.

## Overview
The immediate generator is a crucial element in the CPU architecture, enabling the processor to handle instructions that require immediate values. It extracts these values from specific bits in the instruction and prepares them for use in subsequent operations.

## Functionality
- **Instruction Input:** Accepts a 32-bit instruction from which the immediate value is extracted.
- **Immediate Output:** Produces a sign-extended immediate value, typically 32 bits wide, for use in ALU operations, address calculations, and control flow changes.

## Development Process

### Instruction Format
The immediate value is extracted based on the instruction format, which varies for different types of instructions:

- **I-type Instructions:** Immediate is extracted from bits [31:20].
- **S-type Instructions:** Immediate is formed by combining bits [31:25] and [11:7].
- **B-type Instructions:** Immediate is formed by combining bits [31], [30:25], [11:8], and [7].
- **U-type Instructions:** Immediate is extracted from bits [31:12].
- **J-type Instructions:** Immediate is formed by combining bits [31], [19:12], [20], and [30:21].
</br>
You'll notice that in this project, I've omitted U-type instructions as I won't be using those to test my CPU.

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator is
    port (
        instruction : in STD_LOGIC_VECTOR(31 downto 0);
        immediate : out STD_LOGIC_VECTOR(31 downto 0)
    );
end immediate_generator;

architecture Behavioral of immediate_generator is
begin
    process(instruction)
    begin
        case instruction(6 downto 0) is
            when "0010011" => -- I-type
                immediate <= std_logic_vector(signed(instruction(31 downto 20)));
            when "0100011" => -- S-type
                immediate <= std_logic_vector(signed(instruction(31 downto 25) & instruction(11 downto 7)));
            when "1100011" => -- B-type
                immediate <= std_logic_vector(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & "0"));
            when "1101111" => -- J-type
                immediate <= std_logic_vector(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "0"));
            when others =>
                immediate <= (others => '0');
        end case;
    end process;
end Behavioral;
```

### Testing

Here's the testbench sript that I wrote for the immediate generator.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator_tb is
end immediate_generator_tb;

architecture Behavioral of immediate_generator_tb is

  -- component declaration
  component immediate_generator
    port (
      instruction : in STD_LOGIC_VECTOR(31 downto 0);
      immediate   : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- internal signals
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);
  signal immediate   : STD_LOGIC_VECTOR(31 downto 0);

begin
  -- instantiate component here
  uut: immediate_generator
    port map (
      instruction => instruction,
      immediate   => immediate
    );

  stimulus: process
  begin
    -- I-type: addi x1, x2, 5 (imm = 5)
    instruction <= x"00510113";
    wait for 10 ns;
    assert (immediate = x"00000005")
      report "I-type immediate extraction failed" severity error;

    -- S-type: sw x1, 8(x2) (imm = 8)
    instruction <= x"00112023";
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "S-type immediate extraction failed" severity error;

    -- B-type: beq x1, x2, 8 (imm = 8)
    instruction <= x"00208263";
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "B-type immediate extraction failed" severity error;

    -- J-type: jal x1, 16 (imm = 16)
    instruction <= x"010000EF";
    wait for 10 ns;
    assert (immediate = x"00000010")
      report "J-type immediate extraction failed" severity error;

    report "All immediate extraction tests passed!";
    wait;
  end process;

end Behavioral;
```

Here's the subsequent waveform of that test bench for the immediate generator.


## Theoretical Background

### Purpose
The immediate generator is essential for extracting and preparing immediate values from instructions, enabling the CPU to perform operations that require immediate operands. By handling different instruction formats, it ensures that the processor can execute a wide range of instructions efficiently.

### Operations
- Extraction: Retrieves immediate values from specific bits in the instruction.
- Sign Extension: Ensures immediate values are correctly sign-extended for use in calculations.

## Importance
An efficient immediate generator design is crucial for optimizing CPU performance, as it directly impacts the execution of instructions that rely on immediate values. Understanding the instruction format and how to extract these values is key to implementing a RISC-V processor.
