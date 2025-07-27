library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator_tb is
end immediate_generator_tb;

architecture Behavioral of immediate_generator_tb is

  -- component declaration
  component immediate_generator
    port (
      instruction : in STD_LOGIC_VECTOR(31 downto 0);
      immediate   : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  -- internal signals
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);
  signal immediate   : STD_LOGIC_VECTOR(31 downto 0);

begin
  -- instantiate component here
  uut: immediate_generator
    port map (
      instruction => instruction,
      immediate   => immediate
    );

  stimulus: process
  begin
    -- I-type: addi x1, x2, 5 (imm = 5)
    instruction <= x"00510113";
    wait for 10 ns;
    assert (immediate = x"00000005")
      report "I-type immediate extraction failed" severity error;

    -- S-type: sw x1, 8(x2) (imm = 8)
    instruction <= x"00112023";
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "S-type immediate extraction failed" severity error;

    -- B-type: beq x1, x2, 8 (imm = 8)
    instruction <= x"00208263";
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "B-type immediate extraction failed" severity error;

    -- J-type: jal x1, 16 (imm = 16)
    instruction <= x"010000EF";
    wait for 10 ns;
    assert (immediate = x"00000010")
      report "J-type immediate extraction failed" severity error;

    report "All immediate extraction tests passed!";
    wait;
  end process;

end Behavioral;
