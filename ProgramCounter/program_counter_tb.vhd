library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter_tb is
end program_counter_tb;

architecture Behavioral of program_counter_tb is
  -- define the component under test
  component program_counter
    port (
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      pc_write : in STD_LOGIC;                    -- enable PC update (for pipeline stalls)
      pc_src : in STD_LOGIC_VECTOR(31 downto 0);  -- new PC value from branch/jump
      branch_taken : in STD_LOGIC;                -- signal indicating branch/jump taken
      pc : out STD_LOGIC_VECTOR(31 downto 0)      -- current PC value
    );
  end component;

  -- define all intermediary signals here
  signal clk, rst, pc_write, branch_taken : STD_LOGIC;
  signal pc_src, pc : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : program_counter
    port map (
      clk => clk,
      rst => rst,
      pc_write => pc_write,
      pc_src => pc_src,
      branch_taken => branch_taken,
      pc => pc
    );

  -- simulate process
  stimulus: process
  begin

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
