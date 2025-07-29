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
