module comparator(
    input signed [15:0] A,
	 input signed [15:0] B,
    output reg [1:0] dout
    );

initial begin
	dout = 0;
end

always @ (*)
begin
	if (A > B) begin 
		dout = 1;
	end
	if (A == B) begin
		dout = 0;
	end
	if(A < B) begin
		dout = 'b10;
	end
end
endmodule