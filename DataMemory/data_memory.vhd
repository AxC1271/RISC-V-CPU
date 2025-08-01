library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR(31 downto 0); -- memory address
        write_data : in STD_LOGIC_VECTOR(31 downto 0); -- data to write
        mem_write : in STD_LOGIC; -- write enable
        mem_read : in STD_LOGIC; -- read enable
        read_data : out STD_LOGIC_VECTOR(31 downto 0) -- data read from memory
    );
end data_memory;

architecture Behavioral of data_memory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal memory : memory_array := (others => (others => '0'));
begin
    process(clk, rst)
    begin
        if rst = '1' then
            memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if mem_write = '1' then
                memory(to_integer(unsigned(address(31 downto 2)))) <= write_data;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if mem_read = '1' then
                read_data <= memory(to_integer(unsigned(address(31 downto 2))));
            else
                read_data <= (others => '0');
            end if;
        end if;
    end process;
end Behavioral;
