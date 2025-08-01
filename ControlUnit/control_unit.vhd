library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V Control Unit 
-- Supports ADD, SUB, AND, OR, XOR, ADDI, LW, SW, BEQ, JAL, JALR
entity control_unit is
    port (
        opcode : in STD_LOGIC_VECTOR(6 downto 0);        -- bits [6:0] - RISC-V uses 7 bits
        funct3 : in STD_LOGIC_VECTOR(2 downto 0);        -- bits [14:12]
        funct7 : in STD_LOGIC_VECTOR(6 downto 0);        -- bits [31:25]
        
        RegWrite     : out STD_LOGIC;                    -- write to register file
        MemRead      : out STD_LOGIC;                    -- read from memory
        MemWrite     : out STD_LOGIC;                    -- write to memory
        BranchEq     : out STD_LOGIC;                    -- branch equal (BEQ)
        memToReg     : out STD_LOGIC;                    -- select memory data for writeback
        ALUSrc       : out STD_LOGIC;                    -- select immediate for ALU
        ALUCont      : out STD_LOGIC_VECTOR(2 downto 0); -- ALU operation
        jmp          : out STD_LOGIC;                    -- jump signal 
        print        : out STD_LOGIC                     -- print signal
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
    constant OP_PRINT  : STD_LOGIC_VECTOR(6 downto 0) := "1111111"; -- custom print instruction
    
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
        print <= '0';
        
        case opcode is
            when OP_R_TYPE =>
                RegWrite <= '1';
                ALUSrc <= '0'; -- two registers, I'll use 0 to denote there's a second register operand
                
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
                -- for immediate instructions the second operand is a value, not a register
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
                RegWrite <= '1'; 
                jmp <= '1';     
                ALUSrc <= '1';  
                
            when OP_JALR =>
                RegWrite <= '1'; 
                jmp <= '1';   
                ALUSrc <= '1';

            when OP_PRINT =>
                print <= '1';
            when others =>
                null;
        end case;
    end process;
    
end Behavioral;
