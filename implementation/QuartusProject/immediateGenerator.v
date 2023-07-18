module immediateGenerator(
	input [15:0] din,
	input [1:0] numBits,
	input [1:0] immShift,
	output reg signed [15:0] dout
);
	
initial begin
	dout = 0;
end

always @ (*)
begin
	case(numBits)
		0: dout = 0;
		1: dout = {{12{din[3]}}, din[3:0]};
		2: dout = {{8{din[7]}}, din[7:0]};
		3: dout = {{4{din[11]}}, din[11:0]};
	endcase
	if(immShift == 1) begin
		dout = dout << 1;
	end
	if(immShift == 2) begin
		dout = dout << 8;
	end
//	$display("immgen %b",dout);
end
endmodule