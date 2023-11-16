module ALU (clk,rs1,rs2,sig_es1,sig_es2,sig_M1,sig_M2,oper,flag_Br,res_ALU,DONE_ALU);

	input clk;			//input clock
	input [31:0] rs1,rs2;		//data from registers
	input sig_es1, sig_es2;		//if the result of calculation would be used in the next Mth instruction.
	input sig_M1,sig_M2;		//When the executed sources are gonna be used.
	input [6:0] oper;		//operation selection	1=add, 2=sub, 4= mult, 8=div
	input flag_Br;			//flag
	output [31:0]res_ALU;			//result of ALU
	output DONE_ALU;		//finished ALU

	logic [31:0] s1,s2;		//sources for calculation modules
	logic [31:0] es1,es2;		//temperal reg for the next Mth operation
	logic [31:0] res_add,res_sub;	//result of addtion or subtraction
	logic [31:0] res_mul,res_div;
	logic res_calc;			//result after calculation modules

	//result setting
	assign res_ALU = res_calc;	//always set result of calculation as the output of this module

	always @(posedge clk) begin
		//set es as result of calculation
		if(sig_es1) es1 = res_calc;
		if(sig_es2) es2 = res_calc;

		//if the next instruction need the current calc output. it may need delay to match the required 
		if(sig_M1) s1 = es1;
		else s1 = rs1;

		if(sig_M2) s2 = es2;
		else s2 = rs2;

		//
		case(oper)
			7'h01	: res_calc <=res_add;
			7'h02	: res_calc <=res_sub;
			7'h03	: res_calc <=res_mul;
			7'h04	: res_calc <=res_div;
		default:	res_calc <=0;
	end
	
	Addr(oper[0],s1,s2,res_add);

	Subt(oper[1],s1,s2,res_sub);

	Mult(oper[2],s1,s2,res_mul);

	Divd(oper[3],s1,s2,res_div);

endmodule

module ALU_tb();
	
	logic clk;			//input clock
	logic [31:0] rs1,rs2;		//data from registers
	logic sig_es1, sig_es2;		//if the result of calculation would be used in the next Mth instruction.
	logic sig_M1,sig_M2;		//When the executed sources are gonna be used.
	logic [6:0] oper;		//operation selection
	logic flag_Br;			//flag
	logic res_ALU;			//result of ALU

	ALU DUT(clk,rs1,rs2,sig_es1,sig_es2,sig_M1,sig_M2,oper,flag_Br,res_ALU);

	always begin
		clk =1; #10;
		clk =0; #10;
	end

	inital begin
		rs1 = 32'h0003; rs2 =32'h0001;sig_es1=0; sig_es2=0; sig_M1 =0; sig_M2 =0; oper = 7'h1; flag =0; #101;
		rs1 = 32'h0001; rs2 =32'h0002;sig_es1=1; sig_es2=0; sig_M1 =0; sig_M2 =0; oper = 7'h1; flag =0; #101;		
		rs1 = 32'h0001; rs2 =32'h0001;sig_es1=0; sig_es2=1; sig_M1 =0; sig_M2 =0; oper = 7'h1; flag =0; #101;
		rs1 = 32'h0001; rs2 =32'h0001;sig_es1=0; sig_es2=0; sig_M1 =1; sig_M2 =0; oper = 7'h1; flag =0; #101;
		$stop
	end
endmodule