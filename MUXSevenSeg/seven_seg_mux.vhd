library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_mux is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    print : in STD_LOGIC; -- control unit will send the appropriate flag
    val : in STD_LOGIC_VECTOR(31 downto 0); -- passed directly from alu result
    seg : out STD_LOGIC_VECTOR(6 downto 0);
    ade : out STD_LOGIC_VECTOR(3 downto 0)
  );
end seven_seg_mux;

architecture Behavioral of seven_seg_mux is

  -- define constants here
  constant clk_max : integer := (100_000_000 / 1_000) / 2; -- setting a clk frequency of 1kHz
  
  -- define intermediary signals here
  signal seg_clk : STD_LOGIC := '0';
  signal seg_i : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');
  signal ade_i : STD_LGOIC_VECTOR(3 downto 0) := (others => '1');
  signal clk_cnt : integer range 0 to clk_max := 0;

  -- this is the intermediary value that we will display
  signal val_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
  -- define all inner processes here

  -- first process: generate a slower clock signal for the multiplexer
  clk_div : process(clk, rst) is
  begin
    if rst = '1' then
      seg_clk <= '0';
      clk_cnt <= 0;
    elsif rising_edge(clk) then -- running on 100 MHz clock
      if clk_cnt = clk_max then
        seg_clk <= not seg_clk; -- invert clk signal on every half interval
        clk_cnt <= 0;
      else
        clk_cnt <= clk_cnt + 1; -- increment
      end if;
    end if;
  end process clk_div;

  seg_display: process(seg_clk, rst) is
  begin
    if rst = '1' or print = '0' then
      seg_i <= "1111110"; -- just shows -
    elsif rising_edge(clk) then
      
    end if;
  end process seg_display;

  anode_mux: process is
  begin
  end process anode_mux;

  -- do final assignments here
end Behavioral;
