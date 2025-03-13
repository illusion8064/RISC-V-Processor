# RISC-V Processor Implementation

## Overview

This repository contains a **RISC-V processor implementation** developed as part of the **Introduction to Processor Architecture** final course project. The project includes two implementations:

1. **Sequential RISC-V Processor**: A basic implementation executing one instruction at a time.
2. **Pipelined RISC-V Processor**: A 5-stage pipeline architecture for improved performance.

Both implementations are written in **Verilog**, tested using **Icarus Verilog (iverilog)**, and waveform analysis is performed using **GTKWave**.

---

## Repository Structure

```
RISCVortex/
│── sequential/      # Contains the sequential processor implementation
│── pipelining/      # Contains the pipelined processor implementation
│── project_docs/    # Project requirements and documentation
│── README.md        # This file (repository overview)
```

Each implementation folder contains the necessary Verilog source files, testbenches, assembly test cases, and output files.

---

## Implementations

### 1️⃣ Sequential RISC-V Processor

- **Executes one instruction per cycle** (no parallelism)
- Simpler design, easier to debug
- Basic modules include ALU, register file, instruction memory, and control unit

---

### 2️⃣ Pipelined RISC-V Processor

- **Implements a 5-stage pipeline**: IF, ID, EX, MEM, WB
- **Hazard handling**:
  - Data forwarding for efficiency
  - Hazard detection for stall control
- **Improves instruction throughput** compared to sequential execution

---

## Project Documentation

 **Project requirements and documentation** are included in the `project_docs/` folder, detailing:
- Design specifications
- Instruction formats
- Hazard handling techniques
- Performance comparison between sequential and pipelined architectures

---

## Summary

| Feature               | Sequential Processor | Pipelined Processor |
|----------------------|--------------------|--------------------|
| Execution Speed      | One instruction per cycle | Multiple instructions in parallel |
| Complexity          | Simple | More complex |
| Performance        | Slower | Faster |
| Hazard Handling | Not required | Uses forwarding & stalls |
| Modules          | ALU, Control, Registers | ALU, Control, Registers, Pipeline Registers, Hazard Detection |

---

## Contributors
 Final project for the **Introduction to Processor Architecture** course.

 **GitHub Repository**: [Insert Repo Link]

---

## Future Improvements

- Implement **branch prediction** for further performance enhancement.
- Support additional **RISC-V instructions** beyond the current subset.
- Optimize memory handling for better efficiency.

---

## Acknowledgments

Special thanks to our **professor and TAs** for guidance throughout the project!

📌 *For any queries or suggestions, feel free to open an issue in this repository.*

