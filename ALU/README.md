# Arithmetic Logic Unit (ALU)

Welcome to the ALU module of this RISC-V processor project. This component is responsible for performing arithmetic and logical operations as specified by the instruction set. Below, you'll find an overview of the ALU's functionality, development process, and theoretical background.

## Overview
The ALU is a fundamental component of the CPU architecture, executing operations on data as directed by the control unit. It supports a variety of operations, including addition, subtraction, logical operations, and shifts, which are essential for instruction execution.

## Functionality
- **Operands:** Accepts two 32-bit operands (`op1` and `op2`) for processing.
- **Operation Selector:** Uses a 3-bit `opcode` to determine the operation to perform.
- **Result Output:** Produces a 32-bit result (`res`) based on the selected operation.
- **Zero Flag:** Outputs a `zero_flag` signal, indicating if the result is zero, useful for branch decisions.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V ALU supporting basic arithmetic and logical operations
entity alu is
    port (
        op1 : in STD_LOGIC_VECTOR(31 downto 0); -- first operand
        op2 : in STD_LOGIC_VECTOR(31 downto 0); -- second operand
        opcode : in STD_LOGIC_VECTOR(2 downto 0); -- 3-bit operation selector
        res : out STD_LOGIC_VECTOR(31 downto 0); -- result output
        zero_flag : out STD_LOGIC -- zero flag for branches
    );
end alu;

architecture Behavioral of alu is
    signal res_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    evaluation: process(op1, op2, opcode)
    begin
        case opcode is
            when "000" => -- ADD
                res_i <= std_logic_vector(unsigned(op1) + unsigned(op2));
            when "001" => -- SUB
                res_i <= std_logic_vector(unsigned(op1) - unsigned(op2));
            when "010" => -- AND
                res_i <= op1 and op2;
            when "011" => -- OR
                res_i <= op1 or op2;
            when "100" => -- XOR
                res_i <= op1 xor op2;
            when "101" => -- SLT
                if unsigned(op1) < unsigned(op2) then
                    res_i <= (0 => '1', others => '0'); -- Result = 1
                else
                    res_i <= (others => '0'); -- Result = 0
                end if;
            when "110" => -- SLL
                res_i <= std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
            when "111" => -- SRL
                res_i <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
            when others =>
                res_i <= (others => '0');
        end case;
    end process evaluation;

    res <= res_i;
    zero_flag <= '1' when res_i = (others => '0') else '0';
end Behavioral;
```

### Testing
Here's the test bench for my ALU to ensure that everything's working the way I expect.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is
  -- define the component under test
  component alu
    port (
      op1 : in STD_LOGIC_VECTOR(31 downto 0);
      op2 : in STD_LOGIC_VECTOR(31 downto 0);
      opcode : in STD_LOGIC_VECTOR(2 downto 0);
      res : out STD_LOGIC_VECTOR(31 downto 0);
      zero_flag : out STD_LOGIC
    );
  end component;

  -- define all intermediary signals here
  signal op1, op2 : STD_LOGIC_VECTOR(31 downto 0);
  signal opcode : STD_LOGIC_VECTOR(2 downto 0);
  signal res : STD_LOGIC_VECTOR(31 downto 0);
  signal zero_flag : STD_LOGIC;

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : alu
    port map (
      op1 => op1,
      op2 => op2,
      opcode => opcode,
      res => res,
      zero_flag => zero_flag
    );

  -- simulate process
  stimulus: process
  begin
    -- Test ADD operation
    op1 <= x"00000001";
    op2 <= x"00000001";
    opcode <= "000";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "ADD failed" severity error;

    -- Test SUB operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "001";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SUB failed" severity error;

    -- Test AND operation
    op1 <= x"00000003";
    op2 <= x"00000001";
    opcode <= "010";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "AND failed" severity error;

    -- Test OR operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "011";
    wait for 10 ns;
    assert (res = x"00000003" and zero_flag = '0') report "OR failed" severity error;

    -- Test XOR operation
    op1 <= x"00000003";
    op2 <= x"00000001";
    opcode <= "100";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "XOR failed" severity error;

    -- Test SLT operation
    op1 <= x"00000001";
    op2 <= x"00000002";
    opcode <= "101";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SLT failed" severity error;

    -- Test SLL operation
    op1 <= x"00000001";
    op2 <= x"00000001";
    opcode <= "110";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "SLL failed" severity error;

    -- Test SRL operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "111";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SRL failed" severity error;

    -- End simulation
    wait;
  end process stimulus;

end Behavioral;
```

## Theoretical Background

### Purpose
The ALU is essential for executing arithmetic and logical operations within the CPU. By processing operands based on the control unit's instructions, it enables the CPU to perform calculations and make decisions.

### Operations
- Arithmetic: Performs addition and subtraction.
- Logical: Executes AND, OR, XOR operations.
- Comparison: Evaluates less-than conditions.
- Shifts: Performs left and right shifts.

## Importance
An efficient ALU design is crucial for optimizing CPU performance, as it directly impacts the speed and accuracy of instruction execution. This README provides a structured overview of the ALU component, highlighting its role and functionality within the CPU architecture. 
