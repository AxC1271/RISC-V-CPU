library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is
  -- define the component under test
  component alu
    port (
      op1 : in STD_LOGIC_VECTOR(31 downto 0);
      op2 : in STD_LOGIC_VECTOR(31 downto 0);
      opcode : in STD_LOGIC_VECTOR(2 downto 0);
      res : out STD_LOGIC_VECTOR(31 downto 0);
      zero_flag : out STD_LOGIC
    );
  end component;

  -- define all intermediary signals here
  signal op1, op2 : STD_LOGIC_VECTOR(31 downto 0);
  signal opcode : STD_LOGIC_VECTOR(2 downto 0);
  signal res : STD_LOGIC_VECTOR(31 downto 0);
  signal zero_flag : STD_LOGIC;

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : alu
    port map (
      op1 => op1,
      op2 => op2,
      opcode => opcode,
      res => res,
      zero_flag => zero_flag
    );

  -- simulate process
  stimulus: process
  begin
    -- add operation
    op1 <= x"00000001";
    op2 <= x"00000001";
    opcode <= "000";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "ADD failed" severity error;

    -- sub operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "001";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SUB failed" severity error;

    -- and operation
    op1 <= x"00000003";
    op2 <= x"00000001";
    opcode <= "010";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "AND failed" severity error;

    -- op operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "011";
    wait for 10 ns;
    assert (res = x"00000003" and zero_flag = '0') report "OR failed" severity error;

    -- xor operation
    op1 <= x"00000003";
    op2 <= x"00000001";
    opcode <= "100";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "XOR failed" severity error;

    -- slt operation
    op1 <= x"00000001";
    op2 <= x"00000002";
    opcode <= "101";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SLT failed" severity error;

    -- sll operation
    op1 <= x"00000001";
    op2 <= x"00000001";
    opcode <= "110";
    wait for 10 ns;
    assert (res = x"00000002" and zero_flag = '0') report "SLL failed" severity error;

    -- srl operation
    op1 <= x"00000002";
    op2 <= x"00000001";
    opcode <= "111";
    wait for 10 ns;
    assert (res = x"00000001" and zero_flag = '0') report "SRL failed" severity error;

    wait;
  end process stimulus;

end Behavioral;
