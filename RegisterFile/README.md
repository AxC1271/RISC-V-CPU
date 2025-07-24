# Register File

Welcometo the RegisterFile module of this RISC-V processor project. This component allows for the storage and access of data during CPU operations. Below, you'll find an overview of the register file's functionality, development process, and theoretical background.

## Overview
The register file is a key element in the CPU architecture, consisting of 32 registers, each 32 bits wide. It serves as a fast-access storage area for the CPU, allowing efficient data manipulation and retrieval during instruction execution.

## Functionality
- Registers: 32 registers, each 32 bits wide, for storing data
- Addressing: Utilizes a 5-bit standard logic vector to index the registers
- Two read addresses for accessing register values
- A write enable input to control data writing
- A write address to specify the target register for data storage
- A 32-bit wide read value for data retrieval

## Development Process

### Design

### Testing

## Theoretical Background

### Purpose
The register file acts as a temporary storage area for the CPU, allowing quick access to frequently used data. It plays a vital role in executing instructions efficiently by minimizing memory access delays.
### Operations
- Read: retrieve data from specified registers using read addresses
- Write: store data into a specified register when write enable is active

## Importance
Efficient register file design is crucial for optimizing CPU performance, as it directly impacts the speed and efficiency of instruction execution.
