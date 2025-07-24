library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- here we define our test bench to ensure proper behavior of the register file
entity register_file_tb is
end register_file_tb;

architecture Behavioral of register_file_tb is
  -- define component under test here
  component register_file 
    port (
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      read_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
      read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);

      write_addr : in STD_LOGIC_VECTOR(4 downto 0);
      write_data : in STD_LOGIC_VECTOR(31 downto 0);
      reg_write : in STD_LOGIC;

      read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
      read_data2 : out STD_LOGIC_VECTOR(31 donwto 0)
    );
  end component;
  
  -- define intermediary signals here
  signal read_addr1, read_addr2, write_addr : STD_LOGIC_VECTO(4 downto 0);
  signal reg-write : STD_LOGIC;
  signal write_data : STD_LOGIC_VECTO(31 downto 0);
  signal read_data1, read_data2 : STD_LOGIC_VECTO(31 downto 0);

  -- simulate unit under test here
begin
  uut : register_file
    port map (
      read_addr1 => read_addr1,
      read_addr2 => read_addr2,

      write_addr => write_addr,
      write_data => write_data,
      reg_write => reg_write,

      read_data1 => read_data1,
      read_data2 => read_data2
    );

  stimulus: process
  begin
  end process stimulus;
end Behavioral;
  
