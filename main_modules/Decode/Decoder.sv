/*
Oct 5,2023
Archtecture_Diagram0.1.1
	-no Reorder buffer, no out-of-order.




*/

/*
logical shift - add 0 to do shift
arithmetic shift- move the original sign bit into the vacated bits to do shift
zero-extend-
sign-extend-
*/
module Decoder(clk,inst,oper,rd,rs1,rs2,imm,DONE_Decoder);
	input clk;
	input [31:0]inst;	//instruction from I1d

	output [6:0]oper;	//internal operation designation
	output [4:0]rd;		//register destination
	output [4:0]rs1,rs2;	//register sources
	output [11:0]imm;	//immediate value
	output DONE_Decoder;

	parameter ALU= 7'b011_0011, ALUImm = 7'b001_0011, Load = 7'b000_0011, Store = 7'b010_0011, Jalr = 7'b110_0111,Jal = 7'b110_1111,AUIPC=7'b001_0111,LUI = 7'b011_0111,FENCE= 7'b000_1111,CSRECB=7'b111_0011,Branch=7'b110_0011;	//opcode-inst[6:0] opcode types
	//parameter f3addsub = 3'b000, f3sll = 3'b001, f3slt = 3'b010, f3sltu = 3'b011, f3xor = 3'b100, f3sr = 3'b101, f3and = 3'b111 funct3-inst[14:12] operations
	//parameter f7first = 7'b000_0000, f7second = 7'b010_0000; //funct7-inst[31:25] slections of the operation detail

	always @* begin
		DONE_Decoder= 0; //&& DONE_StageCheck; to hold decoder for the other 
		//RV32I instruction
		case(inst[6:0])		//types of operations

			ALU: begin	//R-type ALU operations
				//same type shares the same instruction structure. set registers as soon as possible, so the register file unit does not need to wait.
				rd = inst[11:7];		
				rs1 = inst[19:15];
				rs2 = inst[24:20];
				imm = 12'x;	//not used. do not care

				case({inst[14:13],inst[31:25]})	//operations
					{3'b000,7'b000_0000}:	oper = 7'd1;	//{add|sub, first selection}=add
					{3'b000,7'b010_0000}:	oper = 7'd2;	//{add|sub, second selection}=sub
					{3'b001,7'b000_0000}:	oper = 7'd3;	//{SLL, 0}= Shift Left Logical (multiply)
					{3'b010,7'b000_0000}:	oper = 7'd;	//{SLT, 0}= signed number comparison
					{3'b011,7'b000_0000}:	oper = 7'd;	//{SLTU, 0}= unsigned number comparison
					{3'b100,7'b000_0000}:	oper = 7'd;	//{XOR, 0}= XOR
					{3'b101,7'b000_0000}:	oper = 7'd;	//{SRL, first selection}= Shift Right Logical(divide)
					{3'b101,7'b010_0000}:	oper = 7'd;	//{SRL, second selection}= Shift Right Arithmetic(divide)
					{3'b110,7'b000_0000}:	oper = 7'd;	//{OR, 0}= OR
					{3'b111,7'b000_0000}:	oper = 7'd;	//{AND, 0}= AND
					default: oper = 7'd0;
				endcase
			end

			ALUImm:	begin	//I-type ALU operations
				rd = inst[11:7];
				rs1 = inst[19:15];
				rs2 = 5'bx;	//not used. do not care
				imm = inst[31:20];
				
				case(inst[14:12])
					3'b000:	oper = 7'd	//add immediate,, MV rd rs1 = ADDI rd rs1 0,, NOP = ADDI x0,x0,0
					3'b010: oper = 7'd	//set less than immediate signed
					3'b011: oper = 7'd	//set less than immediate unsigned,,SLTIU rd, rs1, 1 sets rd to 1 if rs1 equals zero, otherwise sets rd to 0 (assembler pseudo-op SEQZ rd, rs).
					3'b100: oper = 7'd	//XOR immediate,, xori rd, rs1, -1 = NOT rd, rs = logical inversion of register rs1
					3'b110: oper = 7'd	//OR immediate
					3'b111: oper = 7'd	//AND immediate
				//imm[4:0] = shamt, imm[11:5] = funct 7
					3'b001:	oper = 7'd	//shift left logical immediate
					3'b101: oper = 7'd	//shift right logical immediate
					3'b101: oper = 7'd	//shift right arithmetic immediate
					default: oper = 7'd0;
				endcase
			end

			Load:	begin	//I-type Load operations
				rd = inst[11:7];	//destination
				rs1 = inst[19:15];	//base
				rs2 = 5'bx;		//does not use
				imm = inst[31:20];	//offset
				case(inst[14:12])
					3'b000:	begin	//LB-load 8bit from memory
					end
					3'b001:	begin	//LH-load 16bit from memory and sign-extends to 32 bits before storing in register destination
					end
					3'b010:	begin	//LW-load 32bit from memory into register destination
					end
					3'b100:	begin	//LBU-load 8bit unsigned
					end
					3'b101:	begin	//LHU-load 16bit from memory and zero-extends to 32 bits before storing in register destination
					end
					default: oper=7'd0;
				endcase
			end

			Store:	begin	//I-type Store operations
				rd <= 5'bx;			//does not use
				rs1 <= inst[19:15];		//base
				rs2 <= inst[24:20];		//source
				imm <= {inst[31:25],inst[11:7]};	//offset
				
				case(inst[14:12])
					3'b000: 	//SB= store LSB 8bits from rs2 to mem[rs1]
					3'b001:		//SH= store LSB 16bits from rs2 to mem[rs1]
					3'b010:		//SW= store LSB 32bits from rs2 to mem[rs1]
				endcase
			end

			Jal:	begin	//Jump and link
			//push and return address onto a Return-Address Stack only when rd = x1/x5
				rd = inst[11:7];	
				rs1 = 5'bx;
				rs2 = 5'bx;
		*		imm		//extend immediate
				
			end

			Jalr: begin	//Jump and link
			/*link is true when the register is either x1 or x5->>
			rd=!link,rs1=!link =>RAS action: none
			rd=!link,rs1=link =>RAS action: pop
			rd=link,rs1=!link =>RAS action: push
			rd=link,rs1=link,rs1!=rd =>RAS action: push and pop
			rd=link,rs=link,rs1=rd =>RAS action: push
			*/
				rd = inst[11:7];	
				rs1 = inst[19:15];
				imm= inst[31:20];			
			end
			Branch:	begin	//B-type: branch operations
				rd = 5'bx;
				rs1 = inst[19:15];
				rs2 = inst[24:20];
				imm={inst[31],inst[7],inst[30:25],inst[11:8]}
				case(inst[14:12])
					3'b000:		//BEQ
					3'b001:		//BNE
					3'b100:		//BLT
					3'b101:		//BGE
					3'b110:		//BLTU
					3'b111:		//BGEU
					default: oper = 7'd0;
				endcase
			LUI:	begin	//load upper immediate
		*	// needs extended imm-inst[31:12]
			end
			AUIPC:	begin	//add upper immiate to pc
		*	// needs extended imm-inst[31:12]
			end
			FENCE:	begin	//memory model
				
				case(inst[14:12]) begin
					3'b000: begin	//FENCE
						rd = inst[11:7];
						rs1= inst[19:15];
						rs2=5'bx;
					end
					3'b001:		//FENCE.I
						rd = 5'b0;
						rs1 = 5'b0;
						rs2 = 5'b0;
						imm=12'b0;
						
					default: oper = 7'b0;
				endcase				
			end
			CSRECB:	begin	//Control and Status Register Instructions & Environment Call and Breakpoints
			default: begin	//illegal instructions or unimplemented instructions
			//call for error handler
			end

		endcase
	end
endmodule