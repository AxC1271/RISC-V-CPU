library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionFetch is
    port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        pc : in STD_LOGIC_VECTOR(31 downto 0);  -- input from program counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    constant instruction_memory : memory_array := (
        0 => x"00400093",  -- example instruction
        1 => x"00800113",
        2 => x"00A00193",
        others => (others => '0')
    );

begin
    process(clk, reset)
    begin
        if reset = '1' then
            instruction <= (others => '0');
        elsif rising_edge(clk) then
            -- Use the program counter to fetch the instruction
            -- since the pc is incrementing by 4, exclude the last 2 bits
            -- so that we're effectively adding by 1 as indices
            instruction <= instruction_memory(to_integer(unsigned(pc(31 downto 2))));
        end if;
    end process;
end Behavioral;
