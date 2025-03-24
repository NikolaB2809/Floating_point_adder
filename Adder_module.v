`include "addRecFN.v"
`include "fNToRecFN.v"
`include "recFNToFN.v"

module Adder_module(
    input [(`floatControlWidth - 1):0] control,
    input [2:0] subOp,
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [2:0] roundingMode,
    output [15:0] out,
    output [4:0] exceptionFlags
);

localparam WIDTH = 16;
localparam EXP_WIDTH = 5;
localparam MANTISSA_WIDTH = 11;

wire [WIDTH:0] left_out;
wire [WIDTH:0] right_out;
wire [4:0] left_exceptionFlags;
wire [4:0] right_exceptionFlags;
wire [4:0] center_exceptionFlags;
wire [WIDTH:0] a_recFN;
wire [WIDTH:0] b_recFN;
wire [WIDTH:0] c_recFN;
wire [WIDTH:0] d_recFN;
wire [WIDTH:0] out_recFN;

fNToRecFN#(EXP_WIDTH, MANTISSA_WIDTH) a_conversion(
    .in(a),
    .out(a_recFN)
);

fNToRecFN#(EXP_WIDTH, MANTISSA_WIDTH) b_conversion(
    .in(b),
    .out(b_recFN)
);

fNToRecFN#(EXP_WIDTH, MANTISSA_WIDTH) c_conversion(
    .in(c),
    .out(c_recFN)
);

fNToRecFN#(EXP_WIDTH, MANTISSA_WIDTH) d_conversion(
    .in(d),
    .out(d_recFN)
);

addRecFN#(EXP_WIDTH, MANTISSA_WIDTH) Left_adder(
    .control(control),
    .subOp(subOp[2]),
    .a(a_recFN),
    .b(b_recFN),
    .roundingMode(roundingMode),
    .out(left_out),
    .exceptionFlags(left_exceptionFlags)
);

addRecFN#(EXP_WIDTH, MANTISSA_WIDTH) Right_adder(
    .control(control),
    .subOp(subOp[0]),
    .a(c_recFN),
    .b(d_recFN),
    .roundingMode(roundingMode),
    .out(right_out),
    .exceptionFlags(right_exceptionFlags)
);

addRecFN#(EXP_WIDTH, MANTISSA_WIDTH) Center_adder(
    .control(control),
    .subOp(subOp[1]),
    .a(left_out),
    .b(right_out),
    .roundingMode(roundingMode),
    .out(out_recFN),
    .exceptionFlags(center_exceptionFlags)
);

recFNToFN#(EXP_WIDTH, MANTISSA_WIDTH) out_conversion(
    .in(out_recFN),
    .out(out)
);

assign exceptionFlags = {left_exceptionFlags[3] | right_exceptionFlags[3] | center_exceptionFlags[3],
                            left_exceptionFlags[2] | right_exceptionFlags[2] | center_exceptionFlags[2],
                            left_exceptionFlags[1] | right_exceptionFlags[1] | center_exceptionFlags[1],
                            left_exceptionFlags[0] | right_exceptionFlags[0] | center_exceptionFlags[0]};

endmodule