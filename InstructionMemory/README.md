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
        pc : in STD_LOGIC_VECTOR(11 downto 0);  -- input from program counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(31 downto 0);
    constant instruction_memory : memory_array := (
        0 => x"00400093",  -- example instructions
        1 => x"00800113",
        2 => x"00A00193",
        others => (others => '0')
    );

begin
    instruction <= instruction_memory(to_integer(unsigned(pc(31 downto 0))));
end Behavioral;
```

### Testing
Here, I've provided the test bench to test the module.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is
  -- define the component under test
  component instruction_memory
    port (
      pc : in STD_LOGIC_VECTOR(11 downto 0);
      instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- define all intermediary signals here
  signal pc : STD_LOGIC_VECTOR(11 downto 0);
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : instruction_memory
    port map (
      pc => pc,
      instruction => instruction
    );

  -- simulate process
  stimulus: process
  begin

    -- Test instruction fetch
    pc <= x"00000000";
    wait for 10 ns;
    assert (instruction = x"00400093") report "Instruction fetch failed at address 0" severity error;

    pc <= x"00000004";
    wait for 10 ns;
    assert (instruction = x"00800113") report "Instruction fetch failed at address 4" severity error;

    pc <= x"00000008";
    wait for 10 ns;
    assert (instruction = x"00A00193") report "Instruction fetch failed at address 8" severity error;

    -- End simulation
    wait;
  end process stimulus;

end Behavioral;
```

In this demo, we would load the following C program to print out a Fibonacci sequence:

```C
# Simple C program to print out the Fibonacci sequence
int main() {
    int a = 0;
    int b = 1;
    int fib = 0;
    for (int i = 0; i < 11; i++) {
        fib = a + b;
        a = b;
        b = fib;
        print(fib);
    }
}
```

Referring to my custom made ISA for this CPU implementation, I have the following instructions:
```asm
-- define x0 as the zero register
-- define x1 as the first Fibonacci number
-- define x2 as the second Fibonacci number
-- define x3 as the temp printed value
-- define x4 as i
-- define x5 as limit of loop

0. addi x1, x0, 0   -- load register 1 as 0
1. addi x2, x0, 1   -- load register 2 as 1
2. addi x4, x0, 0   -- load register 4 as i
3. addi x5, x0, 11  -- define end of loop as 11
4. beq x4, x5, 11   -- compares x4 and x5 if equal
5. add x3, x1, x2   -- x3 = x1 + x2
6. addi x1, x2, 0   -- x1 = x2
7. addi x2, x3, 0   -- x3 = x2
8. prnt x3          -- print out x3 on hex display
9. addi x4, x4, 1   -- increment i
10. beq x0, x0, 4   -- unskippable unless initial branch condition skips it
11  beq x0, x0, 0   -- loop around
```

Now, if we convert them to the 32-bit binary instructions referring to the instruction format of RISC-V (and nmy custom print function), we'll get:

```
0.  000000000000_00000_000_00001_0010011  -- addi x1, x0, 0
1.  000000000001_00000_000_00010_0010011  -- addi x2, x0, 1
2.  000000000000_00000_000_00100_0010011  -- addi x4, x0, 0
3.  000000001011_00000_000_00101_0010011  -- addi x5, x0, 11
4.  XXXXXXX_00101_00100_000_XXXXX_1100011 -- beq x4, x5, 11
5.  0000000_00010_00001_000_00011_0110011 -- add x3, x1, x2
6.  000000000000_00010_000_00001_0010011  -- addi x1, x2, 0
7.  000000000000_00011_000_00010_0010011  -- addi x2, x3, 0
8.  000000000000_00011_000_00000_1111111  -- prnt x3
9.  000000000001_00100_000_00100_0010011  -- addi x4, x4, 0
10. XXXXXXX_00000_00000_000_XXXXX_1100011 -- beq x0, x0, 4
11. 0000000_00000_00000_000_00000_1100011 -- beq x0, x0, 0
```

Let's quickly figure out our immediate values for the branch instructions on lines 4 and 10.

On memory 4, we need to branch to memory 7 if the beq is satisfied. That means our immediate value is 3, or 000000000011 in binary. The way our immediate generator derives the immediate value from a branch type instruction is as follows:

```VHDL
    when "1100011" => -- B-type
        imm_b := resize(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32);
        immediate <= std_logic_vector(imm_b);
```

This gives the instruction `0000000_00101_00100_000_00110_1100011`.

For memory 10, we need to branch to memory 4, giving us -6. We will get the two's complement of 6 in binary then add it to the current program counter to get back to 6. Unfortunately, the issue I faced was that the program counter is a `32-bit standard logic vector` whereas the `immediate shift` was only 12 bits.

Therefore the design choice for the final CPU was to make the PC only 12 bits wide, which isn't much of a limitation due to the fact that `2**12` instructions is not much of a limitation given the scope of this project.

With this issue resolved, we can determine that the two's complement of 6 in binary is `111111111010`. We can add this back on memory 10 for it overflow back to memory 4, so our final instruction is `1111111_00000_00000_000_10101_1100011`.

Finalized Instructions for Our Fibonacci Sequence:
```
0.  000000000000_00000_000_00001_0010011   -- addi x1, x0, 0
1.  000000000001_00000_000_00010_0010011   -- addi x2, x0, 1
2.  000000000000_00000_000_00100_0010011   -- addi x4, x0, 0
3.  000000001011_00000_000_00101_0010011   -- addi x5, x0, 11
4.  0000000_00101_00100_000_00110_1100011  -- beq x4, x5, 11
5.  0000000_00010_00001_000_00011_0110011  -- add x3, x1, x2
6.  000000000000_00010_000_00001_0010011   -- addi x1, x2, 0
7.  000000000000_00011_000_00010_0010011   -- addi x2, x3, 0
8.  000000000000_00011_000_00000_1111111   -- prnt x3
9.  000000000001_00100_000_00100_0010011   -- addi x4, x4, 0
10. 1111111_00000_00000_000_10101_1100011 -- beq x0, x0, 4
11. 0000000_00000_00000_000_00000_1100011  -- beq x0, x0, 0
```

Finalized Hexadecimal Instructions for Compactness:
```
0.  x0000_0000_0000_0000_0000_0000_1001_0011 = x00000093
1.  x0000_0000_0001_0000_0000_0001_0001_0011 = x00100113
2.  x0000_0000_0000_0000_0000_0010_0001_0011 = x00000213
3.  x0000_0000_1011_0000_0000_0010_1001_0011 = x00B00293
4.  x0000_0000_0101_0010_0000_0011_0110_0011 = x00520363
5.  x0000_0000_0010_0000_1000_0001_1011_0011 = x002081B3
6.  x0000_0000_0000_0001_0000_0000_1001_0011 = x00010093
7.  x0000_0000_0000_0001_1000_0001_0001_0011 = x00018113
8.  x0000_0000_0000_0001_1000_0000_0111_1111 = x0001807F
9.  x0000_0000_0001_0010_0000_0010_0001_0011 = x00120213
10. x1111_1110_0000_0000_0000_1010_1110_0011 = xFE000AE3
11. x0000_0000_0000_0000_0000_0000_0110_0011 = x00000063
```

## Theoretical Background
### Purpose
The instruction memory is essential for storing the program's instructions and supplying them to the CPU for execution. By maintaining a set of instructions, it ensures that the CPU can perform operations as intended.

### Operations
- Fetch: Retrieves the current instruction based on the program counter's address.
- Reset: Ensures a known state by resetting the output instruction.

## Importance
An efficient instruction memory design is crucial for optimizing CPU performance, as it directly impacts the speed and accuracy of instruction execution. This README provides a structured overview of the instruction memory component, highlighting its role and functionality within the CPU architecture
