module connected_control_memory (CLK,
											PC,
											datain,
											ALUSrc,
											MemtoReg,
											RegDst,
											RegWrite, 
											MemRead,
											MemWrite,
											Branch);

   output   ALUSrc;
   output   MemtoReg;
   output   RegDst;
   output   RegWrite;
   output   MemRead;
   output   MemWrite;
   output   Branch;
   
	input [15:0] PC;
   input       CLK;
   input [15:0] datain;
	
	wire ALUSrc;
	wire MemtoReg;
	wire RegDst;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;
	wire [15:0] dout;
	
	reg we;
	reg Reset;
	
	memory UUT (.addr(PC), .data(datain), .we(we), .clk(CLK), .q(dout));
	BlockMemoryControl UUT2 (.ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Opcode(dout), .CLK(CLK), .Reset(Reset));

endmodule