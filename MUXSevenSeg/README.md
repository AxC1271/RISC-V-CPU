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
