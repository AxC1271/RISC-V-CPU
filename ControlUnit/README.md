# Control Unit

Welcome to the Control Unit module of this RISC-V processor project. This component is responsible for generating control signals based on the instruction being executed, enabling the CPU to perform operations such as arithmetic, memory access, and branching. Below, you'll find an overview of the control unit's functionality, development process, and theoretical background.

## Overview
The control unit is a vital element in the CPU architecture, interpreting instruction fields to produce control signals that guide the operation of other components like the ALU, register file, and memory. It supports a range of instructions, including arithmetic, load/store, and branch operations.

## Functionality
- **Instruction Decoding:** Interprets opcode, funct3, and funct7 fields to determine the instruction type.
- **Control Signal Generation:** Produces signals such as RegWrite, MemRead, MemWrite, BranchEq, ALUSrc, and ALUCont to control CPU operations.
- **Jump Handling:** Manages jump instructions, updating the program counter as needed.

## Development Process

### Block Diagram

### Design
<div style="max-width: 800px; overflow-x: auto;">
    
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V Control Unit 
-- Supports ADD, SUB, AND, OR, XOR, ADDI, LW, SW, BEQ, JAL, JALR
entity control_unit is
    port (
        opcode : in STD_LOGIC_VECTOR(6 downto 0);  -- bits [6:0] - RISC-V uses 7 bits
        funct3 : in STD_LOGIC_VECTOR(2 downto 0);  -- bits [14:12]
        funct7 : in STD_LOGIC_VECTOR(6 downto 0);  -- bits [31:25]
        
        RegWrite     : out STD_LOGIC;               -- write to register file
        MemRead      : out STD_LOGIC;               -- read from memory
        MemWrite     : out STD_LOGIC;               -- write to memory
        BranchEq     : out STD_LOGIC;               -- branch equal (BEQ)
        memToReg     : out STD_LOGIC;               -- select memory data for writeback
        ALUSrc       : out STD_LOGIC;               -- select immediate for ALU
        ALUCont      : out STD_LOGIC_VECTOR(2 downto 0); -- ALU operation
        jmp          : out STD_LOGIC                -- jump signal 
    );
end control_unit;

architecture Behavioral of control_unit is
    constant OP_R_TYPE : STD_LOGIC_VECTOR(6 downto 0) := "0110011"; -- R-type
    constant OP_I_ARITH: STD_LOGIC_VECTOR(6 downto 0) := "0010011"; -- I-type arithmetic 
    constant OP_LOAD   : STD_LOGIC_VECTOR(6 downto 0) := "0000011"; -- load
    constant OP_STORE  : STD_LOGIC_VECTOR(6 downto 0) := "0100011"; -- store
    constant OP_BRANCH : STD_LOGIC_VECTOR(6 downto 0) := "1100011"; -- branch
    constant OP_JAL    : STD_LOGIC_VECTOR(6 downto 0) := "1101111"; -- JAL
    constant OP_JALR   : STD_LOGIC_VECTOR(6 downto 0) := "1100111"; -- JALR
    
    constant F3_ADD_SUB: STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant F3_AND    : STD_LOGIC_VECTOR(2 downto 0) := "111";
    constant F3_OR     : STD_LOGIC_VECTOR(2 downto 0) := "110";
    constant F3_XOR    : STD_LOGIC_VECTOR(2 downto 0) := "100";
    constant F3_BEQ    : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
    constant F7_ADD    : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    constant F7_SUB    : STD_LOGIC_VECTOR(6 downto 0) := "0100000";
    
begin
    process(opcode, funct3, funct7)
    begin
        RegWrite <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        BranchEq <= '0';
        memToReg <= '0';
        ALUSrc <= '0';
        ALUCont <= "000";
        jmp <= '0';
        
        case opcode is
            when OP_R_TYPE =>
                RegWrite <= '1';
                ALUSrc <= '0'; 
                
                case funct3 is
                    when F3_ADD_SUB =>
                        if funct7 = F7_ADD then
                            ALUCont <= "000"; -- ADD
                        elsif funct7 = F7_SUB then
                            ALUCont <= "001"; -- SUB
                        end if;
                    when F3_AND =>
                        ALUCont <= "010"; -- AND
                    when F3_OR =>
                        ALUCont <= "011"; -- OR  
                    when F3_XOR =>
                        ALUCont <= "100"; -- XOR
                    when others =>
                        ALUCont <= "000"; -- Default to ADD
                end case;
                
            when OP_I_ARITH =>
                RegWrite <= '1';
                ALUSrc <= '1'; 
                
                case funct3 is
                    when F3_ADD_SUB => -- ADDI
                        ALUCont <= "000"; -- ADD
                    when others =>
                        ALUCont <= "000";
                end case;
                
            when OP_LOAD =>
                RegWrite <= '1';
                MemRead <= '1';
                memToReg <= '1'; 
                ALUSrc <= '1';   
                ALUCont <= "000";  
                
            when OP_STORE =>
                MemWrite <= '1';
                ALUSrc <= '1';   
                ALUCont <= "000"; 
                
            when OP_BRANCH =>
                BranchEq <= '1'; 
                ALUSrc <= '0';   
                ALUCont <= "001"; 
                
            when OP_JAL =>
                RegWrite <= '1'; -- Write return address to register
                jmp <= '1';      -- Indicate jump
                ALUSrc <= '1';   -- Use immediate for jump address
                
            when OP_JALR =>
                RegWrite <= '1'; -- Write return address to register
                jmp <= '1';      -- Indicate jump
                ALUSrc <= '1';   -- Use register for jump address
                
            when others =>
                null;
        end case;
    end process;
    
end Behavioral;
```

### Testing
Here is the test bench for our control unit to see if it works correctly.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit_tb is
end control_unit_tb;

architecture Behavioral of control_unit_tb is
  -- define the component under test
  component control_unit
    port (
      opcode : in STD_LOGIC_VECTOR(6 downto 0);
      funct3 : in STD_LOGIC_VECTOR(2 downto 0);
      funct7 : in STD_LOGIC_VECTOR(6 downto 0);
      
      RegWrite     : out STD_LOGIC;
      MemRead      : out STD_LOGIC;
      MemWrite     : out STD_LOGIC;
      BranchEq     : out STD_LOGIC;
      memToReg     : out STD_LOGIC;
      ALUSrc       : out STD_LOGIC;
      ALUCont      : out STD_LOGIC_VECTOR(2 downto 0);
      jmp          : out STD_LOGIC
    );
  end component;

  -- define all intermediary signals here
  signal opcode, funct3, funct7 : STD_LOGIC_VECTOR(6 downto 0);
  signal RegWrite, MemRead, MemWrite, BranchEq, memToReg, ALUSrc, jmp : STD_LOGIC;
  signal ALUCont : STD_LOGIC_VECTOR(2 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : control_unit
    port map (
      opcode => opcode,
      funct3 => funct3,
      funct7 => funct7,
      
      RegWrite => RegWrite,
      MemRead => MemRead,
      MemWrite => MemWrite,
      BranchEq => BranchEq,
      memToReg => memToReg,
      ALUSrc => ALUSrc,
      ALUCont => ALUCont,
      jmp => jmp
    );

  -- simulate process
  stimulus: process
  begin
    -- Test R-type ADD instruction
    opcode <= "0110011";
    funct3 <= "000";
    funct7 <= "0000000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUCont = "000") report "R-type ADD failed" severity error;

    -- Test R-type SUB instruction
    funct7 <= "0100000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUCont = "001") report "R-type SUB failed" severity error;

    -- Test I-type ADDI instruction
    opcode <= "0010011";
    funct3 <= "000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUSrc = '1' and ALUCont = "000") report "I-type ADDI failed" severity error;

    -- Test Load instruction (LW)
    opcode <= "0000011";
    wait for 10 ns;
    assert (RegWrite = '1' and MemRead = '1' and memToReg = '1') report "Load LW failed" severity error;

    -- Test Store instruction (SW)
    opcode <= "0100011";
    wait for 10 ns;
    assert (MemWrite = '1' and ALUSrc = '1') report "Store SW failed" severity error;

    -- Test Branch instruction (BEQ)
    opcode <= "1100011";
    funct3 <= "000";
    wait for 10 ns;
    assert (BranchEq = '1' and ALUCont = "001") report "Branch BEQ failed" severity error;

    -- Test Jump instruction (JAL)
    opcode <= "1101111";
    wait for 10 ns;
    assert (RegWrite = '1' and jmp = '1') report "Jump JAL failed" severity error;

    -- Test Jump instruction (JALR)
    opcode <= "1100111";
    wait for 10 ns;
    assert (RegWrite = '1' and jmp = '1') report "Jump JALR failed" severity error;

    -- End simulation
    wait;
  end process stimulus;

end Behavioral;
```

## Theoretical Background

### Purpose
The control unit is essential for interpreting instructions and generating the necessary control signals to guide CPU operations. It ensures that each instruction is executed correctly by coordinating the actions of various CPU components.

###  Operations
- Instruction Decoding: Analyzes instruction fields to determine the operation type.
- Signal Generation: Produces control signals that dictate the behavior of the ALU, memory, and other components.

## Importance
An efficient control unit design is crucial for optimizing CPU performance, as it directly impacts the execution speed and accuracy of instructions. <br>
This README provides a structured overview of the control unit component, highlighting its role and functionality within the CPU architecture. Adjust the details as needed to fit your specific implementation and design choices.
