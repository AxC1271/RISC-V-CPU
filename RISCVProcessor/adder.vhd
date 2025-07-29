library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    port ( 
        op1 : in STD_LOGIC_VECTOR (31 downto 0);
        op2 : in STD_LOGIC_VECTOR (31 downto 0);
        sum : out STD_LOGIC_VECTOR (31 downto 0)
        );
end adder;

architecture Behavioral of adder is
begin
    sum <= STD_LOGIC_VECTOR(unsigned(op1) + unsigned(op2));
end Behavioral;
