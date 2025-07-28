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
    begin
        case instruction(6 downto 0) is
            when "0010011" => -- I-type
                immediate <= std_logic_vector(signed(instruction(31 downto 20)));
            when "0100011" => -- S-type
                immediate <= std_logic_vector(signed(instruction(31 downto 25) & instruction(11 downto 7)));
            when "1100011" => -- B-type
                immediate <= std_logic_vector(signed(instruction(31 downto 25) & instruction(11 downto 7)));
            when "1101111" => -- J-type
                immediate <= std_logic_vector(signed(instruction(31 downto 12)));
            when others =>
                immediate <= (others => '0');
        end case;
    end process;
end Behavioral;
