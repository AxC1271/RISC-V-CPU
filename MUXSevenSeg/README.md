# Seven-Segment Multiplexer Display for RISC-V CPU 

Welcome to the Seven-Segment Multiplexer Display project! This component was developed as part of the RISC-V CPU implementation to facilitate visual debugging and provide real-time feedback during development.

## Overview
The seven-segment multiplexer display is designed to interface with the RISC-V CPU, allowing developers to visualize key data outputs directly on the FPGA. This is particularly useful for debugging purposes, as it provides an immediate and intuitive way to monitor CPU operations and verify correct functionality.

## Purpose
During the development of the RISC-V CPU, it became essential to have a straightforward method to observe the internal state and outputs of the processor. The seven-segment display serves this purpose by:
- Displaying register values, memory addresses, or other critical data.
- Providing real-time feedback on CPU operations.
- Assisting in debugging by visually confirming expected outputs.

## Functionality
The seven-segment multiplexer display works by:

- **Multiplexing Data**: It cycles through different data outputs from the CPU, displaying them sequentially on the seven-segment  display. This allows multiple values to be monitored using a single display.

- **Visual Representation**: Each segment of the display lights up to represent numerical values, making it easy to interpret binary or hexadecimal data.

- **Control Interface**: The display is controlled via signals from the CPU, which determine what data is shown and how it is updated.

## Integration with RISC-V CPU
The display is integrated into the RISC-V CPU project as follows:
- `Data Source`: Connects to various data outputs from the CPU, such as register values or ALU results.
- `Control Signals`: Receives control signals to manage the multiplexing and update rate of the display.
- `Debugging Aid`: Provides a visual check for developers to ensure the CPU is functioning correctly and to identify any discrepancies in data processing.

## Usage
To use the seven-segment multiplexer display in your RISC-V CPU project:
1. Connect the Display: Ensure the display is properly connected to the relevant data outputs and control signals from the CPU.
2. Configure Multiplexing: Set up the multiplexing logic to cycle through the desired data outputs.
3. Monitor Outputs: Use the display to observe and verify CPU operations during development and testing.


## VHDL Code
```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_seg_mux is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    print : in STD_LOGIC;
    val : in STD_LOGIC_VECTOR(31 downto 0);
    seg : out STD_LOGIC_VECTOR(6 downto 0);
    ade : out STD_LOGIC_VECTOR(3 downto 0)
  );
end seven_seg_mux;

architecture Behavioral of seven_seg_mux is
  constant clk_max : integer := (100_000_000 / 500) / 2;
  
  signal seg_clk : STD_LOGIC := '0';
  signal seg_i : STD_LOGIC_VECTOR(6 downto 0) := "1111110";
  signal ade_i : STD_LOGIC_VECTOR(3 downto 0) := "1110";
  signal clk_cnt : integer range 0 to clk_max := 0;
  signal val_i : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
  clk_div : process(clk, rst) is
  begin
    if rst = '1' then
      seg_clk <= '0';
      clk_cnt <= 0;
    elsif rising_edge(clk) then
      if clk_cnt = clk_max then
        seg_clk <= not seg_clk;
        clk_cnt <= 0;
      else
        clk_cnt <= clk_cnt + 1;
      end if;
    end if;
  end process clk_div;

  -- FIXED: Use clocked process instead of combinational
  -- Remove ade_i from sensitivity list to break the loop
  anode_mux: process(seg_clk, rst) is
  begin
    if rst = '1' then
      ade_i <= "1110"; 
    elsif rising_edge(seg_clk) then  
      case ade_i is
        when "1110" =>
          ade_i <= "1101";
        when "1101" =>
          ade_i <= "1011";
        when "1011" =>
          ade_i <= "0111";
        when others =>
          ade_i <= "1110";
      end case;
    end if;
  end process anode_mux;

  seg_display: process(seg_clk, rst, print, ade_i) is
    variable val_int : integer range 0 to 9999 := 0;
  begin
    if rst = '1' or print = '0' then
      seg_i <= "1111110";
    elsif rising_edge(seg_clk) then
      case ade_i is
        when "1110" => 
          val_int := to_integer(unsigned(val)) mod 10;
        when "1101" => 
          val_int := (to_integer(unsigned(val)) / 10) mod 10;
        when "1011" => 
          val_int := (to_integer(unsigned(val)) / 100) mod 10;
        when others => 
          val_int := (to_integer(unsigned(val)) / 1000) mod 10;
      end case;
      
      case val_int is
        when 0 => seg_i <= "0000001";
        when 1 => seg_i <= "1001111";
        when 2 => seg_i <= "0010010";
        when 3 => seg_i <= "0000110";
        when 4 => seg_i <= "1001100";
        when 5 => seg_i <= "0100100";
        when 6 => seg_i <= "0100000";
        when 7 => seg_i <= "0001111";
        when 8 => seg_i <= "0000000";
        when others => seg_i <= "0000100"; 
      end case;
    end if;
  end process seg_display;

  ade <= ade_i;
  seg <= seg_i;
end Behavioral;
```

---

Feel free to explore the project files for more detailed information on implementation and integration. This display is a valuable tool for enhancing the development and debugging process of the RISC-V CPU.
