# Sequential RISC-V Processor

## Overview

This folder contains the sequential implementation of a RISC-V processor. Unlike the pipelined version, this design processes instructions one at a time, making it simpler but less efficient in terms of execution speed.

## Features

- **Single-Cycle Execution**: Each instruction completes in one cycle.
- **Basic RISC-V Instruction Set**: Supports arithmetic, logical, load/store, and branch instructions.
- **No Hazard Handling**: Instructions execute sequentially without forwarding or stalling mechanisms.
- **Implemented in Verilog with testbenches**

## File Structure

```
sequential/
│── alu.v, alu_control.v        # ALU and ALU control unit
│── control_unit.v              # Control signals for instruction execution
│── data_mem.v                  # Memory unit for storing data
│── instruction.v               # Instruction decoding module
│── mux_2x1.v                   # Multiplexers used in the design
│── pc.v                        # Program counter
│── register.v                  # Register file
│── main.v                      # Top-level processor design
│── main_test.v                 # Testbench for simulation
│── Assembly & Test Files:
│   ├── assem0.txt, assem1.txt  # Assembly code with dry runs in comments
│   ├── data0.txt, data1.txt    # Memory data contents
│   ├── ins0.txt, ins1.txt      # 32-bit binary instructions
│── Output Files:
│   ├── output/                 # Simulation results
│   ├── output.vcd              # Waveform data for GTKWave
│   ├── output_waveform.gtkw    # Preconfigured GTKWave settings
│── README.md                   # This documentation
```

## Running the Simulation

1. **Compile the Verilog Code**
   ```sh
   iverilog -o output main_test.v
   ```
2. **Dump the vcd File**
   ```sh
   vvp output
   ```
3. **View Waveforms in GTKWave**
   ```sh
   gtkwave output_waveform.vcd
   ```

## Processor Architecture

## Sequential Diagram

![Sequential Diagram](sequential_diagram.png)

## Testing

- Assembly programs (`assem0.txt`, `assem1.txt`) include dry-run comments.
- Memory contents are stored in `data0.txt` and `data1.txt`.
- Instruction binaries are stored in `ins0.txt` and `ins1.txt`.
- Modify these files to test different instructions and execution scenarios.

## Notes

This sequential processor serves as a baseline for understanding RISC-V architecture before moving to more advanced pipelined implementations.
