module tb_step2();

wire signed [15:0] ALUOutWire;
wire signed [15:0] AWire;
wire signed [15:0] BWire;
wire signed [15:0] immGenWire;
reg [1:0] numBitsReg;
reg immShiftReg;
reg ALUSrcBReg;
reg clockReg;
reg [2:0] ALUOpReg;
reg [15:0] instructionReg;
reg [15:0] dataWriteReg = 0;
reg DOrSReg;
reg regWriteReg = 0;
reg [15:0] PCReg = 0;
reg ALUSrcAReg;
reg instrWriteReg = 1;
step2 UTT(
	.instruction(instructionReg),
	.dataWrite(dataWriteReg),
	.instrWrite(instrWriteReg),
	.regWrite(regWriteReg),
	.ALUSrcA(ALUSrcAReg),
	.PC(PCReg),
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	.numBits(numBitsReg),
	.immShift(immShiftReg),
	.DOrS(DOrSReg),
	.CLK(clockReg),
	.ALUOut(ALUOutWire),
	.A(AWire),
	.B(BWire),
	.immGen(immGenWire)
	);
	
parameter HALF_PERIOD = 50;

integer failures = 0;
initial begin
    clockReg = 1;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
	DOrSReg = 0;
	ALUSrcBReg = 1;
	ALUSrcAReg = 1;
	//Test 1
	instructionReg = 534;
	numBitsReg = 1;
	immShiftReg = 0;
	ALUOpReg = 0;
	
	#(7*HALF_PERIOD);
	if(ALUOutWire != 6) begin
		failures = failures + 1;
		$display("ERROR: Expected 6, got %d", ALUOutWire);
	end
	
end
endmodule