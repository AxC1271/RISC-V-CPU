library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionFetch is
    Port ( 
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
            instruction <= instruction_memory(to_integer(unsigned(pc(7 downto 0))));
        end if;
    end process;
end Behavioral;
