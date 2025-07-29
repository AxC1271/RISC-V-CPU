library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux is
    port ( 
        input1 : in STD_LOGIC_VECTOR (31 downto 0);
        input2 : in STD_LOGIC_VECTOR (31 downto 0);
        sel : in STD_LOGIC;
        mux_output : out STD_LOGIC_VECTOR (31 downto 0)
        );
end mux;

architecture Behavioral of mux is
begin
    mux_output <= input2 when sel = '1' else input1;
end Behavioral;
