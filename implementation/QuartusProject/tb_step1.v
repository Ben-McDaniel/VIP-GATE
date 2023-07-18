module tb_step1();

wire signed [15:0] ALUOutWire;
wire signed [15:0] immGenWire;
reg [11:0] dinReg;
reg [1:0] numBitsReg;
reg immShiftReg;
reg [15:0] BReg;
reg ALUSrcBReg;
reg clockReg;
reg [15:0] AReg;
reg [2:0] ALUOpReg;

step1 UTT(
	.A(AReg),
	.B(BReg),
	.ALUSrcB(ALUSrcBReg),
	.ALUOp(ALUOpReg),
	.din(dinReg),
	.numBits(numBitsReg),
	.immShift(immShiftReg),
	.CLK(clockReg),
	.ALUOut(ALUOutWire),
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
	BReg = 0;
	ALUSrcBReg = 1;
	//Test 1
	//Testing connection between ALU and ImmGen
	$display("Testing connection.");
	dinReg = 534;
	numBitsReg = 1;
	immShiftReg = 0;
	ALUOpReg = 0;
	AReg = 2;
	#(7*HALF_PERIOD);
	if(ALUOutWire != 8) begin
		failures = failures + 1;
		$display("ERROR: Expected 8, got %d", ALUOutWire);
	end
	#(HALF_PERIOD);
	ALUOpReg = 0;
	BReg = 3;
	ALUSrcBReg = 0;
	#(11*HALF_PERIOD);
	if(ALUOutWire != 5) begin
		failures = failures + 1;
		$display("ERROR: Expected 5, got %d", ALUOutWire);
	end
	
	$display("Done testing.\nError total: %d", failures);
end
endmodule