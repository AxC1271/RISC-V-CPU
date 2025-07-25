library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is
  -- define the component under test
  component instruction_memory
    port (
      pc : in STD_LOGIC_VECTOR(31 downto 0);
      instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- define all intermediary signals here
  signal pc : STD_LOGIC_VECTOR(31 downto 0);
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
    pc <= x"00000000";
    wait for 10 ns;
    assert (instruction = x"00400093") report "Instruction fetch failed at address 0" severity error;

    pc <= x"00000004";
    wait for 10 ns;
    assert (instruction = x"00800113") report "Instruction fetch failed at address 4" severity error;

    pc <= x"00000008";
    wait for 10 ns;
    assert (instruction = x"00A00193") report "Instruction fetch failed at address 8" severity error;

    -- End simulation
    wait;
  end process stimulus;

end Behavioral;
