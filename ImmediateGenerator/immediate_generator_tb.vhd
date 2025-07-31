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
    instruction x"00000093"; -- 0. addi x1, x0, 0
    wait for 10 ns;
    assert (immediate = x"00000000")
      report "I-type immediate extraction failed" severity error;

    instruction <= x"00B00293"; -- 3. addi x5, x0, 11";
    wait for 10 ns;
    assert (immediate = x"0000000B")
      report "I-type immediate extraction failed" severity error;

    instruction <= x"00428763"; -- 4. beq x4, x5, 7
    wait for 10 ns;
    assert (immediate = x"00000007")
      report "B-type immediate extraction failed" severity error;

    instruction <= x"00120213"; -- 9. addi x4, x4, 1
    wait for 10 ns;
    assert (immediate = x"00000001")
      report "I-type immediate extraction failed" severity error;

    -- beyond this point, we'll test other types of instructions to
    -- make sure J-type and S-type instructions work as well

    instruction <= x"010000EF"; -- J-type: jal x1, 16 (imm = 16) 
    wait for 10 ns;
    assert (immediate = x"00000010")
      report "J-type immediate extraction failed" severity error;

    instruction <= x"00112023"; -- S-type: sw x1, 8(x2) (imm = 8)
    wait for 10 ns;
    assert (immediate = x"00000008")
      report "S-type immediate extraction failed" severity error;

    report "All immediate extraction tests passed!";
    wait;
  end process;

end Behavioral;
