module tb_immediateGenerator();

wire signed [15:0] doutWire;
reg [11:0] dinReg;
reg [1:0] numBitsReg;
reg immShiftReg;
reg clockReg;

immediateGenerator UTT(
	.din(dinReg),
	.numBits(numBitsReg),
	.immShift(immShiftReg),
	.CLK(clockReg),
	.dout(doutWire)
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
	//Test 1
	//Test sign extended 4 bits
	dinReg = 534;
	numBitsReg = 1;
	immShiftReg = 0;
	#(2*HALF_PERIOD);
	if(doutWire != 6) begin
		failures = failures + 1;
		$display("(4 BIT) Error: expected 6, got %d", doutWire);
	end
	dinReg = 538;
	#(2*HALF_PERIOD);
	if(doutWire != -6) begin
		failures = failures + 1;
		$display("(4 BIT) Error: expected -6, got %d", doutWire);
	end
	//Test 2
	//Test sign extended 8 bits
	dinReg = 640;
	numBitsReg = 2;
	immShiftReg = 0;
	#(2*HALF_PERIOD);
	if(doutWire != -128) begin
		failures = failures + 1;
		$display("(8 BIT) Error: expected -128, got %d", doutWire);
	end
	dinReg = 538;
	#(2*HALF_PERIOD);
	if(doutWire != 26) begin
		failures = failures + 1;
		$display("(8 BIT) Error: expected 26, got %d", doutWire);
	end	
	//Test 3
	//Test 12 bits
	dinReg = 534;
	numBitsReg = 3;
	immShiftReg = 0;
	#(2*HALF_PERIOD);
	if(doutWire != 534) begin
		failures = failures + 1;
		$display("(12 BIT) Error: expected 534, got %d", doutWire);
	end
	dinReg = -2048;
	#(2*HALF_PERIOD);
	if(doutWire != -2048) begin
		failures = failures + 1;
		$display("(12 BIT) Error: expected -2048, got %d", doutWire);
	end	
	//Test 4 
	//Test 0 bits
	dinReg = 534;
	numBitsReg = 0;
	immShiftReg = 0;
	#(2*HALF_PERIOD);
	if(doutWire != 0) begin
		failures = failures + 1;
		$display("(0 BIT) Error: expected 0, got %d", doutWire);
	end
	dinReg = 538;
	#(2*HALF_PERIOD);
	if(doutWire != 0) begin
		failures = failures + 1;
		$display("(4 BIT) Error: expected 0, got %d", doutWire);
	end	
	//Test 5
	//Test shift
	dinReg = 534;
	numBitsReg = 1;
	immShiftReg = 1;
	#(2*HALF_PERIOD);
	if(doutWire != 12) begin
		failures = failures + 1;
		$display("(SHIFT) Error: expected 12, got %d", doutWire);
	end
	dinReg = 538;
	#(2*HALF_PERIOD);
	if(doutWire != -12) begin
		failures = failures + 1;
		$display("(SHIFT) Error: expected -12, got %d", doutWire);
	end	
	$display("Done testing.\nError total: %d", failures);
end 
endmodule