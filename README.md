# SimplePipelineCore


## 1. goal
The goal of this project is to understand and develop a modern RISC architecture with out-of-order instruction pipeline. This CPU will support Risc V 32 bit integer Instruction Set version 2.0. 

Instruction pipeline means each CPU stage(Fetch, Decode, Execution, and Write-back) works on a instruction in order, instead waiting for the previous stage finishes the instruction.

## 2. Architecture


### Microarchitecture version 0.1.2(Arch 0.1.2)

![image](https://github.com/Enanter/SimplePipelineCore/blob/main/Architecture_Diagram/Oct_11_2023_MicroArch0_1_2.png)

* implemented more details and created connections for load,store, jump and branch operations.
  * RV32I ISA checker: checks the instruction is for Risc-V 32 bit integer ISA; inst[4:0]=bbb11 (bbb != 111).
  * Queue: holds and distributes operations to execution units from the decoder
  * Register checker (proposal for 0.2.0): Checks the current operation using previous registers on the other stages. Later, this can be used for out-of-order. Placed between the decoder and the scheduler)



### Microarchitecture version 0.1(MicroArch 0.1) 

![image](https://github.com/Enanter/SimplePipelineCore/blob/main/Architecture_Diagram/Oct_3_2023_FDEWDiagram.png)
The goal of version 0.1 is implementing pipeline. Arch 0.1 is not targeting to implement out-of-order, thus it is in-order.


## 3. List of Supporting RV32I Instruction Set

### instruction types

* R-type: -

* I-type: -

* S-type: -

* U-type: -

* J-type: -

* B-type: -

* S-type: -

* L-type: -

* M-type: -

* CSR-type: -

* LUI-type: -

* AUIPC: -


## 4. Stages

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




## References
https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html

https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

https://passlab.github.io/CSE564/notes/lecture09_RISCV_Impl_pipeline.pdf

Slide 3: https://learning.edx.org/course/course-v1:LinuxFoundationX+LFD119x+2T2023/block-v1:LinuxFoundationX+LFD119x+2T2023+type@sequential+block@e72ee6a62f7e453e969eb07d6ccac335/block-v1:LinuxFoundationX+LFD119x+2T2023+type@vertical+block@5db7d94ced80405d9030d79c1b780165

