library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
  port (
    addr     : in STD_LOGIC_VECTOR(4 downto 0);
    wr_data  : in STD_LOGIC_VECTOR(31 downto 0);
    mem_write : in STD_LOGIC;
    mem_read  : in STD_LOGIC;
    rd_data  : out STD_LOGIC_VECTOR(31 downto 0)
  );
end data_memory;

architecture Behavioral of data_memory is
begin
  
  
end Behavioral;
