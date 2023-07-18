module newStep3 (
	input CLK,
	input [2:0] ALUOp,
	input ALUSrcA,
	input ALUSrcB,
	input reset,
	input writeEnable,
	input [1:0] immShift,
	input [1:0] numBits,
	input IRWrite,
	input memEnableRead,
	input memEnableWrite,
	input signed [15:0] inputWire,
	input memAddrSel,
	input [2:0] regDataWrite,
	input [15:0] compOut,
	input [15:0] PC,
	output wire signed [15:0] A,
	output wire signed [15:0] B,
	output wire signed [15:0] ALUOut,
	output wire [3:0] Op,
	output wire signed [15:0] outputWire
);

reg signed [15:0] dataWrite;
reg [15:0] instruction;
reg [15:0] memAddr;
reg signed [15:0] MDRIn;
wire signed [15:0] memOutput;
wire signed [15:0] MDROut;
wire signed [15:0] immediateGenerated;

newStep2 UUT(
	.CLK(CLK),
	.ALUOp(ALUOp),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.reset(reset),
	.writeEnable(writeEnable),
	.dataWrite(dataWrite),
	.immShift(immShift),
	.numBits(numBits),
	.IRWrite(IRWrite),
	.instruction(instruction),
	.PC(PC),
	
	.A(A),
	.B(B),
	.ALUOut(ALUOut),
	.Op(Op),
	.immediateGenerated(immediateGenerated)
);

memory memoryModule(
	.data(B),
	.addr(memAddr >> 1),
	.inputWire(inputWire),
	.we(memEnableWrite),
	.clk(CLK),
	.q(memOutput),
	.outputWire(outputWire),
	.reset(reset)
);

register MDR(
	.din(MDRIn),
	.reset(reset),
	.dout(MDROut),
	.CLK(CLK),
	.regWrite(~reset)
);

initial begin
	dataWrite = 0;
	memAddr = 0;
	MDRIn = 0;
end

always @ (posedge(CLK))
begin
//	$display("op shit %h", Op);
//	$display("memory output %h", memOutput);
	if(memEnableRead == 1) begin
		MDRIn = memOutput;
	end
	if(regDataWrite == 0) begin
		dataWrite = ALUOut;
	end
	if(regDataWrite == 1) begin
		dataWrite = MDROut;
	end
	if(regDataWrite == 2) begin
		dataWrite = PC;
	end
	if(regDataWrite == 3) begin
		dataWrite = immediateGenerated;
	end
	if(regDataWrite == 4) begin
		dataWrite = compOut;
	end
	if(memAddrSel == 0) begin
		memAddr = PC;
	end
	if(memAddrSel == 1) begin
		memAddr = ALUOut;
	end
	if(IRWrite == 1) begin
		instruction = memOutput;
	end
	
end
	
endmodule