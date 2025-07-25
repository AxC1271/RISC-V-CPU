library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter_tb is
end program_counter_tb;

architecture Behavioral of program_counter_tb is
    -- declare components here
    component program_counter
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pc_src : in STD_LOGIC_VECTOR(31 downto 0);
            pc : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- internal signals for testing program counter functionality
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal pc_src : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal pc : STD_LOGIC_VECTOR(31 downto 0);

    -- defined clock period
    constant clk_period : time := 10 ns;

begin
    -- instantiate unit under test
    uut: program_counter
        port map (
            clk => clk,
            rst => rst,
            pc_src => pc_src,
            pc => pc
        );

    -- clock generation process
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- test simulation here
    stimulus: process
    begin
        -- apply reset
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- try updating PC with new values
        pc_src <= x"00000004";
        wait for clk_period;
        assert (pc = x"00000004") report "PC update failed at 4" severity error;

        pc_src <= x"00000008";
        wait for clk_period;
        assert (pc = x"00000008") report "PC update failed at 8" severity error;

        pc_src <= x"0000000C";
        wait for clk_period;
        assert (pc = x"0000000C") report "PC update failed at C" severity error;

        -- test reset functionality again
        rst <= '1';
        wait for clk_period;
        assert (pc = x"00000000") report "PC reset failed" severity error;
        rst <= '0';
        wait for clk_period;

        wait;
    end process stimulus;

end Behavioral;
