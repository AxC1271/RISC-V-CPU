library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V ALU supporting basic arithmetic and logical operations
entity alu is 
   port (
      op1 : in STD_LOGIC_VECTOR(31 downto 0);  -- first operand
      op2 : in STD_LOGIC_VECTOR(31 downto 0);  -- second operand
      opcode : in STD_LOGIC_VECTOR(2 downto 0); -- 3-bit operation selector
      res : out STD_LOGIC_VECTOR(31 downto 0);  -- result output
      zero_flag : out STD_LOGIC                 -- zero flag for branches     
   );
end alu;

architecture Behavioral of alu is
   signal res_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); 
begin
   evaluation: process(op1, op2, opcode)
   begin
      case opcode is
         when "000" => -- ADD
            res_i <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
         when "001" => -- SUB
            res_i <= STD_LOGIC_VECTOR(unsigned(op1) - unsigned(op2));
         when "010" => -- AND
            res_i <= op1 and op2;
         when "011" => -- OR
            res_i <= op1 or op2;
         when "100" => -- XOR
            res_i <= op1 xor op2;
         when "101" => -- SLT
            if unsigned(op1) < unsigned(op2) then
               res_i <= (0 => '1', others => '0');
            else
               res_i <= (others => '0');
            end if;
         when "110" => -- SLL 
            res_i <= STD_LOGIC_VECTOR(shift_left(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
         when "111" => -- SRL 
            res_i <= STD_LOGIC_VECTOR(shift_right(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));
         when others =>
            res_i <= (others => '0');
      end case;
   end process evaluation;
   
   zero_flag_gen: process(res_i)
   begin
      if res_i = x"00000000" then
         zero_flag <= '1';
      else
         zero_flag <= '0';
      end if;
   end process zero_flag_gen;
   
   res <= res_i;
end Behavioral;
