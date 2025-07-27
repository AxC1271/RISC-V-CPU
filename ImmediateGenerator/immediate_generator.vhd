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
        variable imm_i  : signed(31 downto 0);
        variable imm_s  : signed(31 downto 0);
        variable imm_b  : signed(31 downto 0);
        variable imm_j  : signed(31 downto 0);
    begin
        case instruction(6 downto 0) is
            when "0010011" => -- I-type
                imm_i := resize(signed(instruction(31 downto 20)), 32);
                immediate <= std_logic_vector(imm_i);

            when "0100011" => -- S-type
                imm_s := resize(signed(instruction(31 downto 25) & instruction(11 downto 7)), 32);
                immediate <= std_logic_vector(imm_s);

            when "1100011" => -- B-type
                imm_b := resize(signed(instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0'), 32);
                immediate <= std_logic_vector(imm_b);

            when "1101111" => -- J-type
                imm_j := resize(signed(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & "00"), 32);
                immediate <= std_logic_vector(imm_j);

            when others =>
                immediate <= (others => '0');
        end case;
    end process;
end Behavioral;
