module CPU(
  input [15:0] inputWire,
  output wire [15:0] outputWire,
  input reset,
  input CLK
);

  reg [1:0] immShiftReg;
  wire [3:0] opReg;
  wire [1:0] cmpRstReg;
  reg [2:0] ALUOpReg;
  reg writeEnableReg;
  reg [1:0] numBitsReg;
  reg memAddrSelReg;
  reg ALUSrcAReg;
  reg ALUSrcBReg;
  reg memEnableReadReg;
  reg memEnableWriteReg;
  reg PCWriteEnableReg;
  reg PCSourceReg;
  //reg loadInstReg;
  reg [2:0] regDataWriteReg;
  reg DOrSReg;
  reg IRWriteReg; 
//
//  wire [1:0] immShift;
//  wire [3:0] op;
//  wire [1:0] cmpRst;
//  wire [2:0] ALUOp;
//  wire writeEnable;
//  wire [1:0] numBits;
//  wire memAddrSel;
//  wire ALUSrcA;
//  wire ALUSrcB;
//  wire memEnableRead;
//  wire memEnableWrite;
//  wire PCWriteEnable;
//  wire PCSource;
//  wire [2:0] regDataWrite;
//  wire IRWrite;
//	wire DOrS;
//	wire memToReg;

  newStep4 UUT(
    .immShift(immShiftReg),
    .op(opReg),
    .cmpRst(cmpRstReg),
    .ALUOp(ALUOpReg),
    .writeEnable(writeEnableReg),
    .numBits(numBitsReg),
    .memAddrSel(memAddrSelReg),
    .ALUSrcA(ALUSrcAReg),
    .ALUSrcB(ALUSrcBReg),
    .memEnableRead(memEnableReadReg),
    .memEnableWrite(memEnableWriteReg),
    .PCWriteEnable(PCWriteEnableReg),
    .regDataWrite(regDataWriteReg),
    .DOrS(DOrSReg),
    .IRWrite(IRWriteReg),
    .CLK(CLK),
    .reset(reset),
    .inputWire(inputWire),
    .outputWire(outputWire),
    .PCSource(PCSourceReg)
  );

  reg [3:0] input_opcode;
  reg [1:0] input_cmpRst;

  wire [1:0] out_immShift;
  wire [2:0] out_ALUOp;
  wire out_writeEnable;
  wire [1:0] out_numBits;
  wire out_memAddrSel;
  wire out_ALUSrcA;
  wire out_ALUSrcB;
  wire out_memEnableRead;
  wire out_memEnableWrite;
  wire out_PCWriteEnable;
  wire out_PCSource;
  wire out_memToReg;
  wire out_DOrS;
  wire out_IRWrite;
  wire [2:0] out_regDataWrite;
  wire out_memAddrSet;

  controlUnit UTT(
    .immShift(out_immShift),
    .op(input_opcode),
    .cmpRst(input_cmpRst),
    .ALUOp(out_ALUOp),
    .writeEnable(out_writeEnable),
    .numBits(out_numBits),
    .memAddrSel(out_memAddrSel),
    .ALUSrcA(out_ALUSrcA),
    .ALUSrcB(out_ALUSrcB),
    .memEnableRead(out_memEnableRead),
    .memEnableWrite(out_memEnableWrite),
    .PCWriteEnable(out_PCWriteEnable),
    .PCSource(out_PCSource),
    .memToReg(out_memToReg),
    .DOrS(out_DOrS),
    .IRWrite(out_IRWrite),
    .regDataWrite(out_regDataWrite),
    .memAddrSet(out_memAddrSet),
    .CLK(CLK),
    .Reset(reset)
  );

  always @ (negedge CLK) begin
//	$display("op out %h", op);
//    $display("%b", opReg);
    input_opcode <= opReg;
    input_cmpRst <= cmpRstReg;

    immShiftReg <= out_immShift;
    ALUOpReg <= out_ALUOp;
    writeEnableReg <= out_writeEnable;
    numBitsReg <= out_numBits;
    memAddrSelReg <= out_memAddrSel;
    ALUSrcAReg <= out_ALUSrcA;
    ALUSrcBReg <= out_ALUSrcB;
    memEnableReadReg <= out_memEnableRead;
    memEnableWriteReg <= out_memEnableWrite;
    PCWriteEnableReg <= out_PCWriteEnable;
    PCSourceReg <= out_PCSource;
    regDataWriteReg <= out_regDataWrite;
    DOrSReg <= out_DOrS;
    IRWriteReg <= out_IRWrite;
  end

endmodule
