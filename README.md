# RISC-V Processor Implementation

## Overview

This repository contains a RISC-V processor implementation developed as part of the Introduction to Processor Architecture final course project. The project includes two implementations:

1. Sequential RISC-V Processor: A basic implementation executing one instruction at a time.
2. Pipelined RISC-V Processor: A 5-stage pipeline architecture for improved performance.

Both implementations are written in Verilog, tested using Icarus Verilog (iverilog), and waveform analysis is performed using GTKWave.

---

## Repository Structure

```
RISCVortex/
│── sequential/      # Contains the sequential processor implementation
│── pipelining/      # Contains the pipelined processor implementation
│── README.md        # This file (repository overview)
```

Each implementation folder contains the necessary Verilog source files, testbenches, assembly test cases, and output files.

---

## Implementations

### 1 Sequential RISC-V Processor

- Executes one instruction per cycle (no parallelism)
- Simpler design, easier to debug
- Basic modules include ALU, register file, instruction memory, and control unit


### 2 Pipelined RISC-V Processor

- Implements a 5-stage pipeline: IF, ID, EX, MEM, WB
- Hazard handling:
  - Data forwarding for efficiency
  - Hazard detection for stall control
---

## Design Specifications
The processor follows the RISC-V instruction set architecture (ISA), implementing a subset of its instructions. The design consists of the following key modules:
- ALU (Arithmetic Logic Unit) – Performs arithmetic and logical operations.
- Register File – Stores temporary values and operands for computation.
- Control Unit – Decodes instructions and generates control signals.
- Program Counter (PC) – Tracks the next instruction to be executed.
- Data Memory – Stores and retrieves data during execution.
- Instruction Memory – Stores program instructions.

The sequential implementation executes one instruction per cycle, while the pipelined version uses a 5-stage pipeline for improved performance.

---

## Instruction Formats
The processor supports RISC-V base integer instructions. The instruction set includes:
- R-type (Register) – Used for ALU operations (e.g., `ADD`, `SUB`).
- I-type (Immediate) – Used for immediate operations and loads (e.g., `ADDI`, `LW`).
- S-type (Store) – Used for store instructions (`SW`).
- B-type (Branch) – Used for conditional branching (`BEQ`, `BNE`).

Reference Material: For a detailed RISC-V instruction set reference, check out the [RISC-V Green Card](https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf).


---

## Hazard Handling Techniques
In the pipelined implementation, hazards occur due to overlapping instruction execution. The following techniques are used for handling hazards:
- Data Hazards:
  - Forwarding – Data is directly passed from later pipeline stages to earlier ones.
  - Stalling – Introduces a bubble (NOP instruction) when forwarding isn't possible.
- Control Hazards:
  - Stalling on Branches – Pauses execution until the branch outcome is determined.

By implementing these techniques, the processor minimizes pipeline stalls and ensures correct instruction execution.

---

## Contributors
 Priyanshi Jain  
 Ritama Sanyal  
 Gandlur Valli

---

*For any queries or suggestions, feel free to open an issue in this repository.*
