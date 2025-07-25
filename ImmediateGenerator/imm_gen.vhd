library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imm_gen is
  port (
    instruction : in STD_LOGIC_VECTOR(31 downto 0);
    immediate : out STD_LOGIC_VECTOR(31 downto 0)
  );
end imm_gen;

architecture Behavioral of immediate_generator is
begin
    decode : process(instruction) is
    begin
        case instruction(6 downto 0) is
            when "0010011" => -- I-type
                immediate <= STD_LOGIC_VECTOR(signed(instruction(31 downto 20)));
            when "0100011" => -- S-type
                immediate <= STD_LOGIC_VECTOR(signed(instruction(31 downto 25) & instruction(11 downto 7)));
            when "1100011" => -- B-type
                immediate <= STD_LOGIC_VECTOR(signed(instruction(31) & instruction(7) 
                                                     & instruction(30 downto 25) & instruction(11 downto 8)));
            when "1101111" => -- J-type
                immediate <= STD_LOGIC_VECTOR(signed(instruction(31) & instruction(19 downto 12) 
                                                     & instruction(20) & instruction(30 downto 21)));
            when others =>
                immediate <= (others => '0');
        end case;
    end process;
end Behavioral;
