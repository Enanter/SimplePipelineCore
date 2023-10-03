# SimplePipelineCore
## 1. goal
The goal of this project is to understand and develop a modern RISC architecture with instruction pipeline. This project will support RV32I ISA. 

Instruction pipeline means each CPU stage(Fetch, Decode, Execution, and Write-back) works on a instruction in order, instead waiting for the previous stage finishes the instruction.


## 2. Stages

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


## 3. List of Supported RV32I Instruction Set
### instruction types
*R-type

|operation|31-25|24-20|19-15|14-12|11-7|6-0|
|-------|----|---|---|---|----|-|
||Funct7|rs2|rs1|funct3|rd|opcode|



## 4. Register Files
## References
https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html
