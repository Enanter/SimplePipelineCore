# SimplePipelineCore


## 1. Goal

### Aim: 

* creating a power efficicent processor for future projects, which is going to be sensor signal processing, NPU, and communicating other devices via BLE.

### Objectives: 

* following RISC-V 32 integer Instruction Set Architecture.
* implementing out-of-order pipeline microarchitecture.
* receiving and processing data directly without load/store data to a memory/reg.
* optimizing the microarchitecture for looping and receiving data.

### Methods:

* Simulating the design with SystemVerilog ( with UVM - need to learn UVM at this moment Nov 9,2023)
* Emulating the RTL  on PYNQ-Z2 or Genesys 2

## 2. Architecture


### Microarchitecture version 0.1.2~0.1.4

![image](https://github.com/Enanter/SimplePipelineCore/blob/main/Architecture_Diagram/Oct_11_2023_MicroArch0_1_2.png)

* implemented more details and created connections for load,store, jump and branch operations.
  * RV32I ISA checker: checks the instruction is for Risc-V 32 bit integer ISA; inst[4:0]=bbb11 (bbb != 111).
  * Queue: holds and distributes operations to execution units from the decoder
  * Register checker (proposal for 0.2.0): Checks the current operation using previous registers on the other stages. Later, this can be used for out-of-order. Placed between the decoder and the scheduler)

### Microarchitecture version 0.1(MicroArch 0.1) 

![image](https://github.com/Enanter/SimplePipelineCore/blob/main/Architecture_Diagram/Oct_3_2023_FDEWDiagram.png)
The goal of version 0.1 is implementing pipeline. Arch 0.1 is not targeting to implement out-of-order, thus it is in-order.

## 3. Directory & Progression

'''bash
├── Architecture_Diagram          0.1.4           # **design**; MicroArchitecture diagrams
├── backup                        -               # backups
│   └── (...dates)                -               # backup/replaced files on the date.
├── logisimEvo_modules            0.1.4           # **design**; The CPU microarchitecture in logisim-evolution (intended design in register level)
│   └── CPU.circ                  x
│       ├── Fetch                 x               # Fetch
│       ├── Decode                x               # Decode
│       ├── RF                    v               # Register File
│       ├── ALU                   x               # Execution
│       └── WriteBack             x               # Load/Store
├── main_modules                  0.1.4           # **design**; the SystemVerilog  files with the testbenches
│      ├── Fetch                  x               # Fetch
│      ├── Decode                 x               # Decode
│      ├── Execution              x               # Execution
│      └── WriteBack              x               # Load/Store
├── Testbenches                   -               # Testbench results of the SystemVerilog files in the main_modules
│   └── (...dates)                -               # tested modules on the date.
├── Resources                     -               # Resources such as reference, RV32I ISA, and etc,.
└── Documents                     -               # informational documents of the project.
'''

### implementation: MicroArch 0.1.4

* in-order pipeline            x
* RV32I ISA                    x
* direct port signal access    x
* looping optimization         x

## References
https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html

https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf

https://passlab.github.io/CSE564/notes/lecture09_RISCV_Impl_pipeline.pdf

Slide 3: https://learning.edx.org/course/course-v1:LinuxFoundationX+LFD119x+2T2023/block-v1:LinuxFoundationX+LFD119x+2T2023+type@sequential+block@e72ee6a62f7e453e969eb07d6ccac335/block-v1:LinuxFoundationX+LFD119x+2T2023+type@vertical+block@5db7d94ced80405d9030d79c1b780165

