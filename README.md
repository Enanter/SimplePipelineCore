# SimplePipelineCore
# goal
The goal of this project is to understand and develop a modern RISC architecture with instruction pipeline. This project will support RV32I ISA. 

Instruction pipeline means each CPU stage(Fetch, Decode, Execution, and Write-back) works on a instruction in order, instead waiting for the previous stage finishes the instruction.


# Stages

[Front-end] Fetch and Decode. (Check instructions)
[Back-end] Execution and Write-back. (Control data)
Fetch: Find the instruction on the current program counter. Control program counter.
Decode: decode the instruction and send signals to back-end to do operations.
Execution: do operations.
Write-back: save the data to the Level 1 data cache.

# Units

L1i:
L1d:
Fetch:
Decode:
Register Files:
Execution:
Stage Checker: check each stage is done. essencial for pipeline.
Program Counter:
