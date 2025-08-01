library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit_tb is
end control_unit_tb;

architecture Behavioral of control_unit_tb is
  -- define the component under test
  component control_unit
    port (
      opcode : in STD_LOGIC_VECTOR(6 downto 0);
      funct3 : in STD_LOGIC_VECTOR(2 downto 0);
      funct7 : in STD_LOGIC_VECTOR(6 downto 0);
      
      RegWrite     : out STD_LOGIC;
      MemRead      : out STD_LOGIC;
      MemWrite     : out STD_LOGIC;
      BranchEq     : out STD_LOGIC;
      memToReg     : out STD_LOGIC;
      ALUSrc       : out STD_LOGIC;
      ALUCont      : out STD_LOGIC_VECTOR(2 downto 0);
      jmp          : out STD_LOGIC
    );
  end component;

  -- define all intermediary signals here
  signal opcode, funct3, funct7 : STD_LOGIC_VECTOR(6 downto 0);
  signal RegWrite, MemRead, MemWrite, BranchEq, memToReg, ALUSrc, jmp : STD_LOGIC;
  signal ALUCont : STD_LOGIC_VECTOR(2 downto 0);

  -- start simulation here
begin
  -- instantiate the unit under test
  uut : control_unit
    port map (
      opcode => opcode,
      funct3 => funct3,
      funct7 => funct7,
      
      RegWrite => RegWrite,
      MemRead => MemRead,
      MemWrite => MemWrite,
      BranchEq => BranchEq,
      memToReg => memToReg,
      ALUSrc => ALUSrc,
      ALUCont => ALUCont,
      jmp => jmp
    );

  -- simulate process
  stimulus: process
  begin
    -- test add instruction
    opcode <= "0110011"; -- R-type opcode
    funct3 <= "000";
    funct7 <= "0000000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUCont = "000") report "R-type ADD failed" severity error;

    -- test sub instruction
    funct7 <= "0100000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUCont = "001") report "R-type SUB failed" severity error;

    -- test addi instruction
    opcode <= "0010011"; -- I-type opcode
    funct3 <= "000";
    wait for 10 ns;
    assert (RegWrite = '1' and ALUSrc = '1' and ALUCont = "000") report "I-type ADDI failed" severity error;

    -- test store instruction
    opcode <= "0100011"; -- S-type opcode
    wait for 10 ns;
    assert (MemWrite = '1' and ALUSrc = '1') report "Store SW failed" severity error;

    -- test branch instruction (BEQ)
    opcode <= "1100011"; -- B-type opcode
    funct3 <= "000"; -- specifies beq, not blt or bne
    wait for 10 ns;
    assert (BranchEq = '1' and ALUCont = "001") report "Branch BEQ failed" severity error;

    -- test jump instruction (JAL)
    opcode <= "1101111"; -- J-type opcode
    wait for 10 ns;
    assert (RegWrite = '1' and jmp = '1') report "Jump JAL failed" severity error;

    wait;
  end process stimulus;

end Behavioral;
