library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    port (
        opcode : in STD_LOGIC_VECTOR(5 downto 0);
        funct : in STD_LOGIC_VECTOR(5 downto 0);
        
        jmp : out STD_LOGIC;
        memToReg : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        BranchEq : out STD_LOGIC;
        BranchLess : out STD_LOGIC;
        BranchMore : out STD_LOGIC;
        ALUCont : out STD_LOGIC_VECTOR(2 downto 0);
        ALUSrc : out STD_LOGIC;
        RegDst : out STD_LOGIC;
        RegWrite : out STD_LOGIC
    );
end control_unit;

architecture Behavioral of control_unit is

begin
-- handing ALUOp code
    with opcode select
        ALUCont <= "000" when "000111", -- branch if greater than
                   "000" when "001000", -- add immediate
                   "001" when "001010", 
                   "001"  when "001011",
                   "101" when "000101",
                   "110" when "00110",
                   funct(2 downto 0) when "000000",-- R type instructions
                   opcode(2 downto 0)-"001" when others;

-- handling memToReg for load instr
    with opcode select
        memToReg <= '1' when "000111",
                    '0' when others;

-- handling memWrite for store instr
    with opcode select
        MemWrite <= '1' when "001000",
                    '0' when others;
                    
-- branch equals instr
    with opcode select
        BranchEq <= '1' when "001010",
                    '0' when others;

-- branch less than
    with opcode select
        BranchLess <= '1' when "001001",
                      '0' when others;
                      
-- branch greater than
    with opcode select
        BranchMore <= '1' when "001011",
                      '0' when others;
 
-- jmp instr
    with opcode select
        jmp <= '1' when "001100",
               '0' when others;
               
-- reg dst
    with opcode select
        RegDst <= '1' when "000000",
                  '1' when "001100",
                  '0' when others;
                  
-- alu src
    with opcode select
        ALUSrc <= '0' when "000000",
                  '0' when "001001",
                  '0' when "001010",
                  '0' when "001011",
                  '1' when others;

-- reg write
    with opcode select
        RegWrite <= '1' when "000000",
                    '1' when "000010",
                    '1' when "000011",
                    '1' when "000100",
                    '1' when "000101",
                    '1' when "000110",
                    '1' when "000111",
                    '1' when "111111",
                    '0' when others;
end Behavioral;
