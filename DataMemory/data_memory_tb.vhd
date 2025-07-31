library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_tb is
end data_memory_tb;

architecture Behavioral of data_memory_tb is
    -- component to be tested 
    component data_memory
        port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            address : in STD_LOGIC_VECTOR(31 downto 0);
            write_data : in STD_LOGIC_VECTOR(31 downto 0);
            mem_write : in STD_LOGIC;
            mem_read : in STD_LOGIC;
            read_data : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- intermediate signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal address : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write : STD_LOGIC := '0';
    signal mem_read : STD_LOGIC := '0';
    signal read_data : STD_LOGIC_VECTOR(31 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- instantiate unit under test
    uut: data_memory
        port map (
            clk => clk,
            rst => rst,
            address => address,
            write_data => write_data,
            mem_write => mem_write,
            mem_read => mem_read,
            read_data => read_data
        );

    -- clk generation process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        -- write data to address 0
        address <= x"00000000";
        write_data <= x"FFFFFFFF";
        mem_write <= '1';
        wait for clk_period;
        mem_write <= '0';
        wait for clk_period;

        -- read data from address 0
        mem_read <= '1';
        wait for clk_period;
        assert read_data = x"FFFFFFFF" report "Read data mismatch at address 0" severity error;
        mem_read <= '0';
        wait for clk_period;

        -- write data to address 1
        address <= x"00000001";
        write_data <= x"FE00A663";
        mem_write <= '1';
        wait for clk_period;
        mem_write <= '0';
        wait for clk_period;

        -- read data from address 1
        mem_read <= '1';
        wait for clk_period;
        assert read_data = x"FE00A663" report "Read data mismatch at address 1" severity error;
        mem_read <= '0';
        wait for clk_period;

        -- End simulation
        wait;
    end process;
end Behavioral;
