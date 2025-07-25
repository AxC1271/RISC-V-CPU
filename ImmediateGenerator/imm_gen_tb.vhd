library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator_tb is
end immediate_generator_tb;

architecture Behavioral of immediate_generator_tb is
  -- define the component under test
  component immediate_generator
    port (
      instruction : in STD_LOGIC_VECTOR(31 downto 0);
      immediate : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- define all intermediary signals here
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);
  signal immediate : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : immediate_generator
    port map (
      instruction => instruction,
      immediate => immediate
    );

  -- simulate process
  stimulus: process
  begin
    -- test I-type instruction
    instruction <= x"00000013"; -- addi instruction
    wait for 10 ns;
    assert (immediate = x"00000000") report "I-type immediate extraction failed" severity error;

    -- test S-type instruction
    instruction <= x"00000023"; -- sw instruction
    wait for 10 ns;
    assert (immediate = x"00000000") report "S-type immediate extraction failed" severity error;

    -- test B-type instruction
    instruction <= x"00000063"; -- beq instruction
    wait for 10 ns;
    assert (immediate = x"00000000") report "B-type immediate extraction failed" severity error;

    -- test J-type instruction
    instruction <= x"0000006F"; -- jal instruction
    wait for 10 ns;
    assert (immediate = x"00000000") report "J-type immediate extraction failed" severity error;

    wait;
  end process stimulus;

end Behavioral;
