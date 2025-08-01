# Immediate Generator

Welcome to the Immediate Generator module of this RISC-V processor project. This component is responsible for extracting and sign-extending immediate values from instructions, which are used in various operations such as arithmetic calculations, memory addressing, and control flow changes. Below, you'll find an overview of the immediate generator's functionality, development process, and theoretical background.

## 🧠 Overview
The immediate generator is a crucial element in the CPU architecture, enabling the processor to handle instructions that require immediate values. It extracts these values from specific bits in the instruction and prepares them for use in subsequent operations.

## ⚙️ Functionality
- **Instruction Input:** Accepts a 32-bit instruction from which the immediate value is extracted.
- **Immediate Output:** Produces a sign-extended immediate value, typically 32 bits wide, for use in ALU operations, address calculations, and control flow changes.
  
<br/>

This immediate value will be added and selected by the control unit if for example, the opcode of the instruction is an I-type instruction, then this output will be passed into a mux that regulates whether or not the immediate value passes through. For R-type instructions for example where the second operand is the value derived from the address of the second register, this value is ignored as the control unit tells the mux to not propagate this value forward to the second input of the ALU module.

## ✍ Development Process

### Instruction Format
The immediate value is extracted based on the instruction format, which varies for different types of instructions:

- **I-type Instructions:** Immediate is extracted from bits [31:20].
- **S-type Instructions:** Immediate is formed by combining bits [31:25] and [11:7].
- **B-type Instructions:** Immediate is formed by combining bits [31], [30:25], [11:8], and [7].
- **U-type Instructions:** Immediate is extracted from bits [31:12].
- **J-type Instructions:** Immediate is formed by combining bits [31], [19:12], [20], and [30:21].
</br>
You'll notice that in this project, I've chosen to omit U-type instructions as I felt using R-type, I-type, J-type, and B-type instructions are enough for my purposes.

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator is
    port (
        instruction : in  STD_LOGIC_VECTOR(31 downto 0);
        immediate   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end immediate_generator;

architecture Behavioral of immediate_generator is
    signal imm_i : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(instruction)
        variable imm_temp : signed(31 downto 0);
    begin
        case instruction(6 downto 0) is
            when "0010011" => -- I-type
                imm_temp := resize(signed(instruction(31 downto 20)), 32);

            when "0100011" => -- S-type: imm[11:5]=31:25, imm[4:0]=11:7
                imm_temp := resize(signed(instruction(31 downto 25) & instruction(11 downto 7)), 32);

            when "1100011" => -- B-type: imm[12|10:5|4:1|11] = [31|30:25|11:8|7]
                imm_temp := resize(
                    signed(
                        instruction(31) & 
                        instruction(7) & 
                        instruction(30 downto 25) & 
                        instruction(11 downto 8)  
                    ),
                    32
                );

            when "1101111" => -- J-type: imm[20|10:1|11|19:12] = [31|30:21|20|19:12]
                imm_temp := resize(
                    signed(
                        instruction(31) & 
                        instruction(19 downto 12) & 
                        instruction(20) & 
                        instruction(30 downto 21)  
                    ),
                    32
                );
            when others =>
                imm_temp := (others => '0');
        end case;

        imm_i <= std_logic_vector(imm_temp);
    end process;

    immediate <= imm_i;
end Behavioral;

```

### Testing

Here's the testbench sript that I wrote for the immediate generator. Since we already have the instruction memory available, let's validate if the immediate values are what they should be from the binary instructions.

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
    instruction <= x"00000093"; -- 0. addi x1, x0, 0
    wait for 10 ns;
    assert (immediate = x"00000000")
      report "I-type immediate extraction failed" severity error;

    instruction <= x"00B00293"; -- 3. addi x5, x0, 11";
    wait for 10 ns;
    assert (immediate = x"0000000B")
      report "I-type immediate extraction failed" severity error;

    instruction <= x"00428763"; -- 4. beq x4, x5, 7
    wait for 10 ns;
    assert (immediate = x"00000007")
      report "B-type immediate extraction failed" severity error;

    instruction <= x"00120213"; -- 9. addi x4, x4, 1
    wait for 10 ns;
    assert (immediate = x"00000001")
      report "I-type immediate extraction failed" severity error;

    -- beyond this point, we'll test other types of instructions to
    -- make sure J-type and S-type instructions work as well

    instruction <= x"020000EF"; -- J-type: jal x1, 16 (imm = 16) 
    wait for 10 ns;
    assert (immediate = x"00000010")
      report "J-type immediate extraction failed" severity error;

    instruction <= x"00112423"; -- S-type: sw x1, 8(x2) (imm = 8)
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "S-type immediate extraction failed" severity error;

    report "All immediate extraction tests passed!";
    wait;
  end process;

end Behavioral;
```

Notice I am using both instructions from my instruction memory and instructions not included: that way I can validate the immediates of each instruction are true to help debug my script and as proof of concept. Here's the subsequent waveform of that test bench for the immediate generator.
<p align="center">
  <img src="./IGWaveform.png" />
</p>
<p align="center">
  <em>The waveform output matches the expected output in the comments of the testbench.</em>
</p>

## 💡 Theoretical Background

### Purpose
The immediate generator is essential for extracting and preparing immediate values from instructions, enabling the CPU to perform operations that require immediate operands. By handling different instruction formats, it ensures that the processor can execute a wide range of instructions efficiently.

### Operations
- Extraction: Retrieves immediate values from specific bits in the instruction.
- Sign Extension: Ensures immediate values are correctly sign-extended for use in calculations.

## 🔑 Importance
An efficient immediate generator design is crucial for optimizing CPU performance, as it directly impacts the execution of instructions that rely on immediate values. Understanding the instruction format and how to extract these values is key to implementing a RISC-V processor.
