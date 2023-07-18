module tb_comparator();

wire signed [2:0] doutWire;
reg [15:0] AReg;
reg [15:0] BReg;
reg clockReg;

comparator UTT(
	.A(AReg),
	.B(BReg),
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
	//Testing A > B
	$display("Testing A > B.");
	AReg = 5;
	BReg = 4;
	if(doutWire != 1) begin
		failures = failures + 1;
		$display("(>) Error: output %d, expected 1.", doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = 5;
	BReg = -2;
	if(doutWire != 1) begin
		failures = failures + 1;
		$display("(>) Error: output %d, expected 1.", doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = -4;
	BReg = -8;
	if(doutWire != 1) begin
		failures = failures + 1;
		$display("(>) Error: output %d, expected 1.", doutWire);
	end
	#(2*HALF_PERIOD);
	//Test 2
	//Testing A = B
	$display("Testing A = B");
	AReg = 4;
	BReg = 4;
	#(2*HALF_PERIOD);
	if(doutWire != 0) begin
		failures = failures + 1;
		$display("(=) Error: output %d, expected 0.", doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = -2;
	BReg = -2;
	if(doutWire != 0) begin
		failures = failures + 1;
		$display("(=) Error: output %d, expected 0.", doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = 0;
	BReg = 0;
	if(doutWire != 0) begin
		failures = failures + 1;
		$display("(=) Error: output %d, expected 0.", doutWire);
	end
	#(2*HALF_PERIOD);
	//Test 3
	//Testing A < B
	$display("Testing A < B");
	AReg = 4;
	BReg = 5;
	#(2*HALF_PERIOD);
	if(doutWire != -2) begin
		failures = failures + 1;
		$display("(<) Error: output %d, expected -2.",doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = -2;
	BReg = 5;
	if(doutWire != -2) begin
		failures = failures + 1;
		$display("(<) Error: output %d, expected -2.",doutWire);
	end
	#(2*HALF_PERIOD);
	AReg = -8;
	BReg = -4;
	if(doutWire != -2) begin
		failures = failures + 1;
		$display("(<) Error: output %d, expected -2.",doutWire);
	end
	#(2*HALF_PERIOD);
	$display("Done testing.\nError total: %d", failures);
end

endmodule