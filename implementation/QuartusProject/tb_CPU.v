module tb_CPU();

reg CLK, reset;
reg signed [15:0] inputWire;
wire signed [15:0] outputWire;

CPU UUT(
	.CLK(CLK),
	.inputWire(inputWire),
	.outputWire(outputWire),
	.reset(reset)
);

parameter HALF_PERIOD = 50;
parameter PERIOD = 2 * HALF_PERIOD;

initial begin
	CLK = 0;
	reset = 1;
	inputWire = 0;
	forever begin
		#HALF_PERIOD;
		CLK = ~CLK;
	end
end

initial begin
	reset = 0;
	#(2*HALF_PERIOD);
	reset = 1;
	#(2*HALF_PERIOD);

	
	
	
	#PERIOD;
	reset = 0;
	inputWire = 5;
	#(1000000*PERIOD);
	
	$display("Test should be complete");

end

endmodule