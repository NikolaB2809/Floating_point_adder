`include "Adder_module.v"
`include "Output_clock_selector.v"
`include "Output_reg.v"
`include "Setup_reg.v"
`include "Shift_reg.v"
`include "Delay_module.v"

module FP_Adder(
    input serial1_in,
    input serial2_in,
    input serial3_in,
    input serial4_in,
    input wr_in,
    input setup_serial_in,
    input clk_in,
    input rst_in,
    input output_clk_in,
    input output_read_in,
    output input_rdy,
    output output_rdy,
    output serial_out
);

localparam WIDTH = 16;

wire en_shift_reg1, en_shift_reg2, en_shift_reg3, en_shift_reg4;
wire input_rdy_shift_reg_1, input_rdy_shift_reg_2, input_rdy_shift_reg_3, input_rdy_shift_reg_4;
wire [WIDTH-1:0] parallel1_out, parallel2_out, parallel3_out, parallel4_out;
wire [7:0] setup_reg_out;
wire [2:0] sub_internal;
wire [WIDTH-1:0] adder_out_internal;
wire output_reg_clk;
wire delay_in;
wire delay_out;

Shift_reg Shift_reg1(
    .serial_in(serial1_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(setup_reg_out[1]),
    .wr_in(wr_in),
    .input_rdy(input_rdy_shift_reg_1),
    .parallel_out(parallel1_out)
);

Shift_reg Shift_reg2(
    .serial_in(serial2_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(setup_reg_out[2]),
    .wr_in(wr_in),
    .input_rdy(input_rdy_shift_reg_2),
    .parallel_out(parallel2_out)
);

Shift_reg Shift_reg3(
    .serial_in(serial3_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(setup_reg_out[3]),
    .wr_in(wr_in),
    .input_rdy(input_rdy_shift_reg_3),
    .parallel_out(parallel3_out)
);

Shift_reg Shift_reg4(
    .serial_in(serial4_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(setup_reg_out[4]),
    .wr_in(wr_in),
    .input_rdy(input_rdy_shift_reg_4),
    .parallel_out(parallel4_out)
);

Setup_reg setup(
    .serial_in(setup_serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(wr_in),
    .parallel_out(setup_reg_out)
);

Adder_module adder(
    .control(1'b1),
    .subOp(setup_reg_out[7:5]),
    .a(parallel4_out),
    .b(parallel3_out),
    .c(parallel2_out),
    .d(parallel1_out),
    .roundingMode(3'b000),
    .out(adder_out_internal)
);

Output_clock_selector clk_selector(
    .sel_in(setup_reg_out[0]),
    .clk_internal_in(clk_in),
    .clk_external_in(output_clk_in),
    .clk_out(output_reg_clk)
);

Delay_module delay(
    .in(wr_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .out(delay_out)
);

Output_reg output_reg(
    .parallel_in(adder_out_internal),
    .clk_in(output_reg_clk),
    .rst_in(rst_in),
    .wr_in(delay_out),
    .output_read_in(output_read_in),
    .output_rdy(output_rdy),
    .serial_out(serial_out)
);

assign input_rdy = input_rdy_shift_reg_1 | input_rdy_shift_reg_2 | input_rdy_shift_reg_3 | input_rdy_shift_reg_4;
assign delay_in = wr_in & (setup_reg_out[1] | setup_reg_out[2] |
                            setup_reg_out[3] | setup_reg_out[4]);


endmodule
