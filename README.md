### SimplePipelineCore
## goal
The goal of this project is to understand and develop a modern RISC architecture with instruction pipeline. This project will support RV32I ISA. 

Instruction pipeline means each CPU stage(Fetch, Decode, Execution, and Write-back) works on a instruction in order, instead waiting for the previous stage finishes the instruction.


## Stages

[Front-end] Fetch and Decode. (Check instructions)

[Back-end] Execution and Write-back. (Control data)

# 1.  Fetch: Find the instruction on the current program counter. Control program counter.
  * L1i:
  * Program Counter: Tells the current instruction line number.
    * Stage Checker: check each stage is done. essencial for pipelining.
# 1.  Decode: decode the instruction and send signals to back-end to do operations.
  |* L1d read:
  * Register Files:
# 1.  Execution: do operations.

# 1.  Write-back: save the data to the Level 1 data cache.
  * L1d write:
* Register Files:

# RV32I Instruction Set

add
  +-----+-----+-----+-----+-----+-----+-----+---+
  |31-27|26-25|24-20|19-15|14-12|11-7 |6-2  |1-0|
  +-----+-----+-----+-----+-----+-----+-----+---+
  |00000|00   |rs2  |rs1  |000  |rd   |01100|11 |
  +-----+-----+-----+-----+-----+-----+-----+---+

