# SimplePipelineCore
## goal
The goal of this project is to understand and develop a modern RISC architecture with instruction pipeline. This project will support RV32I ISA. 

Instruction pipeline means each CPU stage(Fetch, Decode, Execution, and Write-back) works on a instruction in order, instead waiting for the previous stage finishes the instruction.


## Stages

[Front-end] Fetch and Decode. (Check instructions)

[Back-end] Execution and Write-back. (Control data)

 ### 1.  Fetch 
 Find the instruction on the current program counter. Control program counter.
  * L1i:
  * Program Counter: Tells the current instruction line number.
    * Stage Checker: check each stage is done. essencial for pipelining.
      
 ### 2.  Decode
 Decode the instruction and send signals to back-end to do operations.
  * L1d read:
  * Register Files:
    
 ### 3.  Execution
 Execute operations.

 ### 4.  Write-back
 Save the data to the Level 1 data cache.
  * L1d write:
  * Register Files:

## Register Files
## RV32I Instruction Set


| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

