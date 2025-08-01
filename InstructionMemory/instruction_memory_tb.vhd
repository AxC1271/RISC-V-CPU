library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is
  -- define the component under test
  component instruction_memory
    port (
      pc : in STD_LOGIC_VECTOR(11 downto 0);
      instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- define all intermediary signals here
  signal pc : STD_LOGIC_VECTOR(11 downto 0);
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : instruction_memory
    port map (
      pc => pc,
      instruction => instruction
    );

  -- simulate process
  stimulus: process
  begin

    -- Test instruction fetch
    pc <= x"000";
    wait for 10 ns;
    assert (instruction = x"00000093") report "Instruction fetch failed at address 0" severity error;

    pc <= x"004";
    wait for 10 ns;
    assert (instruction = x"00428763") report "Instruction fetch failed at address 4" severity error;

    pc <= x"008";
    wait for 10 ns;
    assert (instruction = x"0001807F") report "Instruction fetch failed at address 8" severity error;

    -- End simulation
    wait;
  end process stimulus;

end Behavioral;
