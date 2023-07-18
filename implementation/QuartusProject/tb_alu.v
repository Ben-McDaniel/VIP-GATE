module tb_alu();

wire signed [15:0] ALUOutWire;
reg [15:0] AReg;
reg [15:0] BReg;
reg [2:0] ALUOpReg;
reg clockReg;

alu UTT(
	.A(AReg),
	.B(BReg),
	.ALUOp(ALUOpReg),
	.CLK(clockReg),
	.ALUOut(ALUOutWire)
	);

parameter HALF_PERIOD = 50;

integer failures = 0;

initial begin
    clockReg = 0;
    forever begin
        #(HALF_PERIOD);
        clockReg = ~clockReg;
    end
end

initial begin
	AReg = 2;
	BReg = 1;
	//Test 1
	//Test add
	$display("Testing ALU add.");
	ALUOpReg = 0;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 3) begin
		failures = failures + 1;
		$display("(ADD) Error: expected 3, got %d", ALUOutWire);
	end
	//Test 2
	//Test sub
	$display("Testing ALU sub.");
	ALUOpReg = 1;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 1) begin
		failures = failures + 1;
		$display("(SUB) Error: expected 1, got %d", ALUOutWire);
	end
	//Test 3
	//Test and 
	$display("Testing ALU and.");
	ALUOpReg = 2;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 0) begin
		failures = failures + 1;
		$display("(AND) Error: expected 0, got %d", ALUOutWire);
	end
	//Test 4
	//Test or
	$display("Testing ALU or.");
	ALUOpReg = 3;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 3) begin
		failures = failures + 1;
		$display("(OR) Error: expected 3, got %d", ALUOutWire);
	end
	//Test 5
	//Test xor
	$display("Testing ALU xor.");
	ALUOpReg = 4;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 3) begin
		failures = failures + 1;
		$display("(XOR) Error: expected 3, got %d", ALUOutWire);
	end
	//Test 6
	//Test slli
	$display("Testing ALU slli.");
	ALUOpReg = 5;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 4) begin
		failures = failures + 1;
		$display("(SLLI) Error: expected 4, got %d", ALUOutWire);
	end
	//Test 7
	//Test srli
	$display("Testing ALU srli.");
	ALUOpReg = 6;
	#(2*HALF_PERIOD)
	if(ALUOutWire != 1) begin
		failures = failures + 1;
		$display("(SRLI) Error: expected 1, got %d", ALUOutWire);
	end
	
	$display("Done testing.\nError total: %d", failures);
end 
endmodule