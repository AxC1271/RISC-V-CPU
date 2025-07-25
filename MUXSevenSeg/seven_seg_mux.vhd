entity seven_seg_mux is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    seg : out STD_LOGIC_VECTOR(6 downto 0);
    ade : out STD_LOGIC_VECTOR(3 downto 0)
  );
end seven_seg_mux;

architecture Behavioral of seven_seg_mux is

  -- define constants here
  constant clk_max : integer := 1000; -- setting a clk frequency of 1kHz
  
  -- define intermediary signals here
  signal seg_clk : STD_LOGIC := '0';
  signal seg_i : STD_LOGIC_VECTOR(6 downto 0) := (others => '1');
  signal ade_i : STD_LGOIC_VECTOR(3 downto 0) := (others => '1');
  signal clk_cnt : integer range 0 to clk_max := 0;
begin
  -- define all inner processes here
  clk_div : process(clk) is
  begin
  end process clk_div;

  seg_display: process is
  begin
  end process seg_display;

  anode_mux: process is
  begin
  end process anode_mux;
end Behavioral;
