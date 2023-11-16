/*
Oct 5,2023
Archtecture_Diagram0.1.1
	-no Reorder buffer, no out-of-order.




*/

/*


*/
module Decoder(clk,inst,oper,rd,funct3,rs1,rs2,funct7,imm,DONE_Decoder);
	input clk;
	input [31:0]inst;

	output [6:0]oper;	//ALU operation
	output [4:0]rd;		//register destination

	parameter ALU= 7'b011_0011, ALUImm = 7'b001_0011, Load = 7'b000_0011, Store = 7'b010_0011, JB = 7'b110_0011;	//opcode-inst[6:0] opcode types
	//parameter f3addsub = 3'b000, f3sll = 3'b001, f3slt = 3'b010, f3sltu = 3'b011, f3xor = 3'b100, f3sr = 3'b101, f3and = 3'b111 funct3-inst[14:12] operations
	//parameter f7first = 7'b000_0000, f7second = 7'b010_0000; //funct7-inst[31:25] slections of the operation detail

	always @* begin
		DONE_Decoder= 0; //&& DONE_StageCheck; to hold decoder for the other 
		//RV32I instruction
		if(inst[6:0] = ALU) 		begin	//R-type ALU operations

			//same type shares the same instruction structure. set registers as soon as possible, so the register file unit does not need to wait.
			rd = inst[11:7];		
			rs1 = inst[19:15];
			rs2 = inst[24:20];

			if(inst[14:12] = 3'b000)	begin	//add, sub
				if(inst[31:25] = 7'b0)		begin	//add
					oper = 7'b1;
				else if(inst[31:25
		end
		else if(inst[6:0] = ALUImm) 	begin	//I-type ALU operations

		end
		else if(inst[6:0] = Load)	begin	//I-type Load operations

		end
		else if(inst[6:0] = Store)	begin	//I-type Store operations

		end
		else if(inst[6:0] = JB)		begin	//J-type and B-type
		
		else				begin	//illegal instructions
			//call for error handler
		end