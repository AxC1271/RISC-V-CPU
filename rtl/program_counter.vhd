library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- the purpose of this entity is to correctly increment the address of the instruction
-- pointer so that the CPU fetches the correct instruction to decode and execute
entity program_counter is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pc_write : in STD_LOGIC; -- signal to overwrite curr address
        pc_src : in STD_LOGIC_VECTOR(31 downto 0); -- address from jmp or branch instr
        pc : out STD_LOGIC_VECTOR(31 downto 0) -- address of curr instruction
    );
end program_counter;

architecture Behavioral of program_counter is
    signal curr_pc : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- internal signal
begin
    process(clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                curr_pc <= (others => '0');
            elsif pc_write = '1' then
                curr_pc <= pc_src;
            else
                curr_pc <= STD_LOGIC_VECTOR(TO_INTEGER(unsigned(curr_pc) + 4));
            end if;
        end if;
    end process;
    
    pc <= curr_pc;
end Behavioral;
