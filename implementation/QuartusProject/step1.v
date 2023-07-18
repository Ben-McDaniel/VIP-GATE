module step1(
	input signed [15:0] A,
	input [2:0] ALUOp,
	input [11:0] din,
	input [1:0] immShift,
	input [1:0] numBits,
	input CLK,
	input signed [15:0] B,
	input ALUSrcB,
	output reg signed [15:0] ALUOut,
	output reg signed [15:0] immGen
);

wire signed [15:0] doutWire;
wire signed [15:0] ALUOutWire;
reg [15:0] ALUB;
reg [15:0] ALUA;
wire signed [15:0] AWire;
wire signed [15:0] BWire;

immediateGenerator UTT1(
	.din(din),
	.numBits(numBits),
	.immShift(immShift),
	.CLK(CLK),
	.dout(doutWire)
	);


alu UTT2(
	.A(ALUA),
	.B(ALUB),
	.ALUOp(ALUOp),
	.CLK(CLK),
	.ALUOut(ALUOutWire)
	);
reg regWriteReg = 1;
reg resetReg = 0;	
register AReg(
	.din(A),
	.dout(AWire),
	.reset(resetReg),
	.regWrite(regWriteReg),
	.CLK(CLK)
);

register BReg(
	.din(B),
	.dout(BWire),
	.reset(resetReg),
	.regWrite(regWriteReg),
	.CLK(CLK)
);
reg [15:0] ALUOutReg;
wire signed [15:0] ALUOutRegWire;
register ALUOutRegister(
	.din(ALUOutReg),
	.dout(ALUOutRegWire),
	.reset(resetReg),
	.regWrite(regWriteReg),
	.CLK(CLK)
	);
initial begin
	ALUOut = 0;
end

always @ (posedge(CLK))
begin
	if(ALUSrcB == 0) begin
		ALUB = BWire;
	end
	if(ALUSrcB == 1) begin
		ALUB = doutWire;
	end
	ALUA = AWire;
	immGen = doutWire;
	ALUOutReg = ALUOutWire;
	ALUOut = ALUOutRegWire;
end

endmodule

