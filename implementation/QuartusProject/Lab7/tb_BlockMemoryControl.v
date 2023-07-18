module BlockMemoryControl_tb;
	wire ALUSrc;
	wire MemtoReg;
	wire RegDst;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	reg [6:0] Opcode;
	reg CLK;
	reg Reset;

	
	BlockMemoryControl UUT (.ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Opcode(Opcode), .CLK(CLK), .Reset(Reset));
	
	parameter HALF_PERIOD = 50;
	parameter PERIOD = HALF_PERIOD * 2;
	
	initial begin
		CLK = 0;
		forever begin
			#(HALF_PERIOD);
			CLK = ~CLK;
		end
	end
	
	initial begin
	
	CLK = 0;
	Reset = 1;
	
	#PERIOD;
	
	Reset = 0;
	
	#PERIOD;
	
	Opcode = 'h33;
	
	#PERIOD;
	
	Opcode = 'h03;
	
	#PERIOD;
	
	Opcode = 'h23;
		  
	#PERIOD;
	
	Opcode = 'h63;
	
	#PERIOD;
	
	Opcode = 'hff;
	
	#PERIOD;
	
	Reset = 1;
	
	#PERIOD;
	
	Reset = 0;
	
	#PERIOD;
	
	end
endmodule