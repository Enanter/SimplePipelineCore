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

|31-25|24-20|19-15|14-12|11-7|6-0|
|------|---|---|---|----|----------- |
|31-28|27-24|23-20|19-|14-12|11---7|6-----0|
|Funct7|:::|rs2      |rs1|funct3|rd|opcode|

^31-25^24-20^19-15^14-12^11-7^6-0^
|Funct7|rs2|rs1|funct3|rd|opcode|

| Column 1                | Col 2 | Big row span   |
|:-----------------------:|-------| -------------- |
| r1_c1 spans two cols           || One large cell |
| r2_c1 spans two rows    | r2_c2 |                |
|_^                      _| r3_c2 |                |
|    ______ &#20;         | r4_c2 |_              _|

| Column 1 | Column 2 | Column 3 | Column 4 |
| -------- | -------- | -------- | -------- |
| r1,c1    | r1,c2    | r1,c3    | r1,c4    |
| r2,c1              || r2,c3    | r2,c4    |

| Column 1 | Column 2 | Column 3 | Column 4 |
| -------- | -------- | -------- | -------- |
| r1,c1    | r1,c2    | r1,c3    | r1,c4    |
| r2,c1            |~~| r2,c3    | r2,c4    |

## 4. Register Files
## References
https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
