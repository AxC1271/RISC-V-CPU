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
  signal reg-write : STD_LOGIC := '0'; -- initialize it low
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
    -- first apply reset
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10 ns;

    -- registers are now all set to zeroes so we don't have undefined values

    -- test case #1: write to reg 1
    write_addr <= "00001";     -- write to reg one
    write_data <= x"00000001"; -- hexadecimal for 1
    reg_write <= '1'; -- write enable for register 1
    wait for 20 ns;
    -- test case #2: write to reg 2
    reg_write <= '0'; -- make sure to reset reg_write so we don't make changes to reg
    write_addr <= "00010";     -- write to reg two
    write_data <= x"00FF89D5"; -- arbitrary value
    reg_write <= '1'; -- now we are ready to modify reg 2
    wait for 20 ns;

    -- test case #3: write to reg 0 which should be a default zero register
    reg_write <= '0'; -- reset reg_write again
    write_addr <= "00000";     -- write to reg zero
    write_data <= x"01010101"; -- arbitrary value
    reg_write <= '1'; -- now we are ready to modify reg 0
    wait for 20 ns;
    -- now we can read from both of these registers to see if they hold the values
    
    
  end process stimulus;
end Behavioral;
  
