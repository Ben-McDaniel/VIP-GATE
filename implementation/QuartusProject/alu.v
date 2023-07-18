module alu(
	input signed [15:0] A,
	input signed [15:0] B,
	input [2:0] ALUOp,
	output reg signed [15:0] ALUOut
);
	
initial begin
	ALUOut = 0;
end

always @ (*) // @ (posedge(CLK))
begin
//	$display("A %b", A);
//	$display("B %b", B);
	case(ALUOp)
		0: ALUOut = A + B;
		1: ALUOut = A - B;
		2: ALUOut = A & B;
		3: ALUOut = A | B;
		4: ALUOut = A ^ B;
		5: ALUOut = A << B;
		6: ALUOut = A >> B;
	endcase
//	$display("ALUOUT: %b", ALUOut);
end
endmodule