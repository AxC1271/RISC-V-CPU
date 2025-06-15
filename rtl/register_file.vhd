library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        read_addr1 : in STD_LOGIC_VECTOR(4 downto 0); -- 5 bit address from opcode
        read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);
        
        write_addr : in STD_LOGIC_VECTOR(4 downto 0); 
        write_data : in STD_LOGIC_VECTOR(31 downto 0); -- 32 bit registers
        reg_write : in STD_LOGIC;
        
        read_data1: out STD_LOGIC_VECTOR(31 downto 0);
        read_data2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin

    read_data1 <= registers(to_integer(unsigned(read_addr1)));
    read_data2 <= registers(to_integer(unsigned(read_addr2)));

    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                registers <= (others => (others => '0'));
            elsif reg_write = '1' then
                registers(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

end Behavioral;
