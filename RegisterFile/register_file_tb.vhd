library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_tb is
end register_file_tb;

architecture Behavioral of register_file_tb is
  -- define the component under test
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
      read_data2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- define all intermediary signals here
  signal clk, rst : STD_LOGIC := '0';
  signal read_addr1, read_addr2, write_addr : STD_LOGIC_VECTOR(4 downto 0);
  signal reg_write : STD_LOGIC := '0';
  signal write_data : STD_LOGIC_VECTOR(31 downto 0);
  signal read_data1, read_data2 : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : register_file
    port map (
      clk => clk,
      rst => rst,
      read_addr1 => read_addr1,
      read_addr2 => read_addr2,

      write_addr => write_addr,
      write_data => write_data,
      reg_write => reg_write,

      read_data1 => read_data1,
      read_data2 => read_data2
    );

  -- simulate process
  stimulus: process
  begin
    -- apply reset
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10 ns;

    -- test case #1: Write to reg 1
    clk <= '0';
    write_addr <= "00001";
    write_data <= x"00000001";
    reg_write <= '1';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;

    -- test case #2: Write to reg 2
    clk <= '0';
    reg_write <= '0';
    write_addr <= "00010";
    write_data <= x"00FF89D5";
    reg_write <= '1';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;

    -- test case #3: Write to reg 0 (should remain zero)
    clk <= '0';
    reg_write <= '0';
    write_addr <= "00000";
    write_data <= x"01010101";
    reg_write <= '1';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;

    -- read from reg 1
    read_addr1 <= "00001";
    wait for 10 ns;
    assert read_data1 = x"00000001" report "Read from reg 1 failed" severity error;

    -- read from reg 2
    read_addr2 <= "00010";
    wait for 10 ns;
    assert read_data2 = x"00FF89D5" report "Read from reg 2 failed" severity error;

    -- read from reg 0 (should be zero)
    read_addr1 <= "00000";
    wait for 10 ns;
    assert read_data1 = x"00000000" report "Read from reg 0 failed" severity error;

    -- end simulation
    wait;
  end process stimulus;

  -- clock generation process
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end loop;
  end process clk_process;

end Behavioral;
