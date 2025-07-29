library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enable : in STD_LOGIC;  
        pc_src : in STD_LOGIC_VECTOR(31 downto 0);
        pc : out STD_LOGIC_VECTOR(31 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then  -- only update when enabled
                pc_reg <= pc_src;
            end if;
        end if;
    end process;
    
    pc <= pc_reg;
end Behavioral;
