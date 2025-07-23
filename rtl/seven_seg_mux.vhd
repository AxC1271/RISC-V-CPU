library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- seven seg display driver for the basys3 fpga board

entity seven_seg_mux is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    value : in STD_LOGIC_VECTOR(31 downto 0);
    segment : out STD_LOGIC_VECTOR(6 downto 0);
    anode : out STD_LOGIC_VECTOR(3 downto 0)
  );
end seven_seg_mux;

architecture Behavioral of seven_seg_mux is
begin
end Behavioral;
