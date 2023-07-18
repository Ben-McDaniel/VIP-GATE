module newStep4(
	input [1:0] immShift,
	input [2:0] ALUOp,
	input writeEnable,
	input [1:0] numBits,
	input memAddrSel,
	input ALUSrcA,
	input ALUSrcB,
	input memEnableRead,
	input memEnableWrite,
	input PCWriteEnable,
	input PCSource,
	input [2:0] regDataWrite,
	input DOrS,
	input IRWrite,
	input reset,
	input CLK,
	input signed [15:0] inputWire,
	output wire [3:0] op,
	output wire [1:0] cmpRst,
	output wire signed [15:0] outputWire
);

wire signed [15:0] PCOut;
wire signed [15:0] A;
wire signed [15:0] B;
wire signed [15:0] ALUOut;
reg [15:0] PCIn;
wire [15:0] PCALUOut;
reg [15:0] compOutExtended;

newStep3 UUT(
	.CLK(CLK),
	.ALUOp(ALUOp),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.reset(reset),
	.writeEnable(writeEnable),
	.immShift(immShift),
	.numBits(numBits),
	.IRWrite(IRWrite),
	.memEnableRead(memEnableRead),
	.memEnableWrite(memEnableWrite),
	.inputWire(inputWire),
	.memAddrSel(memAddrSel),
	.regDataWrite(regDataWrite),
	.compOut(compOutExtended),
	.PC(PCOut),
	.A(A),
	.B(B),
	.ALUOut(ALUOut),
	.Op(op),
	.outputWire(outputWire)
	
);

register PC(
	.din(PCIn),
	.reset(reset),
	.dout(PCOut),
	.regWrite(PCWriteEnable),
	.CLK(CLK)
);
reg [15:0] AReg = 2;
reg [2:0] ALUOpReg = 0;
alu PCAdder(
	.A(AReg),	// Set to 2 when it increments by 1
	.B(PCOut),
	.ALUOp(ALUOpReg),
	.ALUOut(PCALUOut)
);

comparator comp(
	.A(A),
	.B(B),
	.dout(cmpRst)
);

initial begin
	compOutExtended = 0;
end

always @ (posedge(CLK))
begin
//	$display("pcWriteEnable: %b",PCWriteEnable);
//	$display("pc : %b", PCOut);
	compOutExtended = {{14{PCSource && ~PCSource}}, cmpRst[1:0]};
	if(PCSource == 0) begin
		PCIn = PCALUOut;
	end
	if(PCSource == 1) begin
		PCIn = ALUOut;
	end
end

endmodule