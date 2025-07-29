library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    port ( 
        pc : in STD_LOGIC_VECTOR(11 downto 0);  -- input from program counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(31 downto 0);
    constant instruction_memory : memory_array := (
        0      => x"00000093", -- addi x1, x0, 0
        1      => x"00100113", -- addi x2, x0, 1
        2      => x"00000213", -- addi x4, x0, 0
        3      => x"00B00293", -- addi x5, x0, 11
        4      => x"00428763", -- beq x4, x5, 7
        5      => x"002081B3", -- add x3, x1, x2
        6      => x"00010093", -- addi x1, x2, 0
        7      => x"00018113", -- addi x2, x3, 0
        8      => x"0001807F", -- prnt x3
        9      => x"00120213", -- addi x4, x4, 1
        10     => x"FE000AE3", -- beq x0, x0, -6, wrap around
        11     => x"0001807F", -- prnt x3
        12     => x"FE000FE3", -- beq x0, x0, -1
        others => x"00000000"
    );

begin
    instruction <= instruction_memory(to_integer(unsigned(pc)));
end Behavioral;
