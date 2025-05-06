# risc-v processor implementation  

## overview  

this repository contains a risc-v processor implementation developed as part of the introduction to processor architecture final course project. the project includes two implementations:  

1. **sequential risc-v processor**: a basic implementation executing one instruction at a time.  
2. **pipelined risc-v processor**: a 5-stage pipeline architecture for improved performance.  

both implementations are written in verilog, tested using icarus verilog (iverilog), and waveform analysis is performed using gtkwave.  

---  

## repository structure  

```  
riscvortex/  
│── sequential/      # contains the sequential processor implementation  
│── pipelining/      # contains the pipelined processor implementation  
│── readme.md        # this file (repository overview)  
```  

each implementation folder contains the necessary verilog source files, testbenches, assembly test cases, and output files.  

---  

## implementations  

### 1 sequential risc-v processor  
- executes one instruction per cycle (no parallelism)  
- simpler design, easier to debug  
- basic modules include alu, register file, instruction memory, and control unit  

### 2 pipelined risc-v processor  
- implements a 5-stage pipeline: if, id, ex, mem, wb  
- hazard handling:  
  - data forwarding for efficiency  
  - hazard detection for stall control  

---  

## design specifications  
the processor follows the risc-v instruction set architecture (isa), implementing a subset of its instructions. the design consists of the following key modules:  
- **alu (arithmetic logic unit)** – performs arithmetic and logical operations.  
- **register file** – stores temporary values and operands for computation.  
- **control unit** – decodes instructions and generates control signals.  
- **program counter (pc)** – tracks the next instruction to be executed.  
- **data memory** – stores and retrieves data during execution.  
- **instruction memory** – stores program instructions.  

the sequential implementation executes one instruction per cycle, while the pipelined version uses a 5-stage pipeline for improved performance.  

---  

## instruction formats  
the processor supports risc-v base integer instructions. the instruction set includes:  
- **r-type (register)** – used for alu operations (e.g., `add`, `sub`).  
- **i-type (immediate)** – used for immediate operations and loads (e.g., `addi`, `lw`).  
- **s-type (store)** – used for store instructions (`sw`).  
- **b-type (branch)** – used for conditional branching (`beq`, `bne`).  

reference material: for a detailed risc-v instruction set reference, check out the [risc-v green card](https://www.cl.cam.ac.uk/teaching/1617/ecad+arch/files/docs/riscvgreencardv8-20151013.pdf).  

---  

## hazard handling techniques  
in the pipelined implementation, hazards occur due to overlapping instruction execution. the following techniques are used for handling hazards:  
- **data hazards**:  
  - forwarding – data is directly passed from later pipeline stages to earlier ones.  
  - stalling – introduces a bubble (nop instruction) when forwarding isn't possible.  
- **control hazards**:  
  - stalling on branches – pauses execution until the branch outcome is determined.  

by implementing these techniques, the processor minimizes pipeline stalls and ensures correct instruction execution.  

---  

## contributors  
priyanshi jain  
ritama sanyal  
gandlur valli  

---  

*for any queries or suggestions, feel free to open an issue in this repository.*
