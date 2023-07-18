module board_relPrime (
  input [15:0] SW,
  input KEY,
  output [6:0] HEX0,
  output [6:0] HEX1,
  output [6:0] HEX2,
  output [6:0] HEX3
);

reg [15:0] inputWire;
wire [15:0] outputWire;
reg CLK;
reg reset;
reg buttonPressed;
wire [3:0] hex;

CPU UUT(
	.inputWire(inputWire),
	.outputWire(outputWire),
	.CLK(CLK),
	.reset(reset)
);

parameter HALF_PERIOD = 50;
parameter PERIOD = 2 * HALF_PERIOD;

assign {HEX3, HEX2, HEX1, HEX0} = outputWire;

initial begin
	reset = 0;
	CLK = 1;
	inputWire = SW;
	buttonPressed = 0;
	forever begin
		#HALF_PERIOD;
		CLK = ~CLK;
	end
end

always @(posedge KEY) begin
	reset = 1;
	#PERIOD;
	reset = 0;
	
	while (!buttonPressed) begin
		buttonPressed = KEY;
		@(posedge CLK);
	end
	
	#HALF_PERIOD;
	$display("INPUT %d produced OUTPUT %d", inputWire, outputWire);
	
	$finish;
end

endmodule
