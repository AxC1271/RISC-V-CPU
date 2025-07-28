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
  constant clk_max : integer := (100_000_000 / 500) / 2; -- setting a clk frequency of 1kHz
  
  -- define intermediary signals here
  signal seg_clk : STD_LOGIC := '0';
  signal seg_i : STD_LOGIC_VECTOR(6 downto 0) := "1111110";
  signal ade_i : STD_LOGIC_VECTOR(3 downto 0) :=  "1110";
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

  anode_mux: process(seg_clk) is -- changes when seg clock changes
  begin
    case ade_i is
        when "1110" =>
          ade_i <= "1101";
        when "1101" =>
          ade_i <= "1011";
        when "1011" =>
          ade_i <= "0111";
        when others =>
          ade_i <= "1110";
      end case;
  end process anode_mux;

  seg_display: process(seg_clk, rst, print, ade_i) is
    variable val_int : integer range 0 to 9999 := 0;
  begin
    if rst = '1' or print = '0' then -- either rst or there is nothing to be printed
      seg_i <= "1111110"; -- just shows -
    elsif rising_edge(seg_clk) then
      case ade_i is
            when "1110" => -- LSB
                val_int := integer(unsigned(val)) mod 10;
            when "1101" => -- tens digit
                val_int := (integer(unsigned(val)) / 10) mod 10;
            when "1011" => -- hundreds digit
                val_int := (integer(unsigned(val)) / 100) mod 10;
            when others => -- MSB (Thousands digit)
                val_int := (integer(unsigned(val)) / 1000) mod 10;
        end case;

      case val_int is
        when 0 =>
          seg_i <= "0000001";
        when 1 =>
          seg_i <= "1001111";
        when 2 =>
          seg_i <= "0010010";
        when 3 =>
          seg_i <= "0000110";
        when 4 =>
          seg_i <= "1001100";
        when 5 =>
          seg_i <= "0100100";
        when 6 =>
          seg_i <= "0100000";
        when 7 =>
          seg_i <= "0001111";
        when 8 =>
          seg_i <= "0000000";
        when others => -- including 9
          seg_i <= "0000100";
      end case;
    end if;
  end process seg_display;

  -- do final assignments here
  ade <= ade_i;
  seg <= seg_i;
end Behavioral;
