module connected_control_memory_tb();

	wire ALUSrc;
	wire MemtoReg;
	wire RegDst;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	
	reg 		  CLK;
	reg [15:0] PC;
	reg [15:0] datain;

connected_control_memory UUT (.CLK(CLK), .PC(PC), .datain(datain), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch));

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
	datain = 'h0000;
	
	#PERIOD;
	
	PC = 'h0000;
	
	#PERIOD;
	
	PC = PC + 1;
	
	#PERIOD;
	
	PC = PC + 1;
	
	#PERIOD;
	
	PC = PC + 1;
	
	end
endmodule