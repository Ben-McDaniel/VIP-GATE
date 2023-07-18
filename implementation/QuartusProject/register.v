module register(
    input signed [15:0] din,
    input reset,
    output reg signed [15:0] dout,
	 input regWrite,
    input CLK
    );
	 
initial begin
	dout = 0;
end

always @ (negedge(CLK))
begin
	if(regWrite == 1) begin
		dout = din;
	end 
	if(reset == 1) begin
		dout = 0;
	end
end
endmodule