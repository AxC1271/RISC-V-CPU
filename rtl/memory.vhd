library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- where the uart receiver writes to and where the instruction register reads instructions
entity memory is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        packet : in STD_LOGIC_VECTOR (7 downto 0);
        wr_en : in STD_LOGIC;
        pc : in STD_LOGIC_VECTOR(15 downto 0);
        instruction : out STD_LOGIC_VECTOR (31 downto 0)
           );
end memory;

architecture Behavioral of memory is
    type instr_array is array(0 to (2 ** 16 - 1)) of STD_LOGIC_VECTOR(7 downto 0);
    signal instruction_packets : instr_array := (others => (others => '0'));
    signal instr : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal pc_i : STD_LOGIC_VECRTOR(15 downto 0) := (others => '0');
begin
    -- handling changes to memory for instructions from uart_rx
    writetoMem : process(clk) is
        variable index : integer range 0 to (2**16 - 1) := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                instruction_packets <= (others => (others => '0'));
                index := 0;
            else -- normal behavior when rst is not held high
                -- check for when wr_en is high then
                if wr_en = '1' then
                    instruction_packets(index) <= packet;
                    index := (index + 1) mod (2**16 - 1);  
                end if;        
            end if;
        end if;
    end process writetoMem;
    
    -- the process of formatting the 8 bit packets into a valid instruction for the instruction register to read
    readfromMem : process(clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                instr <= (others => '0');
                pc_i <= 0;
            else
                pc_i <= pc;
                
                -- focusing on big Endian notation
                instr(31 downto 24) <= instruction_packets(to_integer(unsigned(pc_i)) + 0);
                instr(23 downto 16) <= instruction_packets(to_integer(unsigned(pc_i)) + 1);
                instr(15 downto 8) <= instruction_packets(to_integer(unsigned(pc_i)) + 2);
                instr(7 downto 0) <= instruction_packets(to_integer(unsigned(pc_i)) + 3);
            end if;
        end if;
    end process readfromMem;
    
    instruction <= instr;
end Behavioral;
