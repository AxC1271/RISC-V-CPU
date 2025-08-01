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
        0      => x"00000093", -- addi x1, x0, 0; x1 is our first Fibonacci pair
        1      => x"00100113", -- addi x2, x0, 1; x2 is our second Fibonacci pair
        2      => x"00000213", -- addi x4, x0, 0
        3      => x"00000313", -- addi x6, x0, 0
        4      => x"00B00293", -- addi x5, x0, 10
        5      => x"00520863", -- beq x4, x5, 8
        6      => x"002081B3", -- add x3, x1, x2
        7      => x"00010093", -- addi x1, x2, 0
        8      => x"00018113", -- addi x2, x3, 0
        9      => x"0001807F", -- prnt x3
        10     => x"00020313", -- addi x6, x4, 0 ; set x6 = x4 
        11     => x"00130213", -- addi x4, x6, 1 
        12     => x"FE0009E3", -- beq x0, x0, -7
        13     => x"0001807F", -- prnt x3
        14     => x"FE000FE3", -- beq x0, x0, -1
        others => x"00000000"
    );

begin
    instruction <= instruction_memory(to_integer(unsigned(pc)));
end Behavioral;
