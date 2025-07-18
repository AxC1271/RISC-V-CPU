library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- RISC-V Register File
-- 32 registers, each 32 bits wide
-- Register x0 always reads as zero and ignores writes
entity register_file is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        read_addr1 : in STD_LOGIC_VECTOR(4 downto 0); -- 5 bit address for rs1
        read_addr2 : in STD_LOGIC_VECTOR(4 downto 0); -- 5 bit address for rs2
        
        write_addr : in STD_LOGIC_VECTOR(4 downto 0);  -- 5 bit address for rd
        write_data : in STD_LOGIC_VECTOR(31 downto 0); -- 32 bit data to write
        reg_write : in STD_LOGIC;                      -- write enable
        
        read_data1: out STD_LOGIC_VECTOR(31 downto 0); -- output for rs1
        read_data2 : out STD_LOGIC_VECTOR(31 downto 0) -- output for rs2
    );
end register_file;

architecture Behavioral of register_file is
    type reg_array is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
    
    -- useful constants
    constant ZERO_REG : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    
begin
    -- read logic with x0 handling and write forwarding
    read_data1 <= write_data when (reg_write = '1' and read_addr1 = write_addr and read_addr1 /= ZERO_REG) else
                  (others => '0') when read_addr1 = ZERO_REG else
                  registers(to_integer(unsigned(read_addr1)));
                  
    read_data2 <= write_data when (reg_write = '1' and read_addr2 = write_addr and read_addr2 /= ZERO_REG) else
                  (others => '0') when read_addr2 = ZERO_REG else
                  registers(to_integer(unsigned(read_addr2)));
    
    -- write process
    process(clk, rst)
    begin
        if rst = '1' then
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            -- only write if reg_write is enabled and not writing to x0
            if reg_write = '1' and write_addr /= ZERO_REG then
                registers(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;
    
end Behavioral;
