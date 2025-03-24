`include "HardFloat_consts.vi"
module Adder_module_tb;

reg [(`floatControlWidth - 1):0] control;
reg [2:0] subOp;
reg [15:0] a;
reg [15:0] b;
reg [15:0] c;
reg [15:0] d;
reg [2:0] roundingMode;
wire [15:0] out;
wire [4:0] exceptionFlags;

integer iterations;
integer passed_tests;

Adder_module dut(
    .control(control),
    .subOp(subOp),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .roundingMode(roundingMode),
    .out(out),
    .exceptionFlags(exceptionFlags)
);

task check;
    input [15:0] a_in;
    input [15:0] b_in;
    input [15:0] c_in;
    input [15:0] d_in;
    input [2:0] sub_in;
    input [15:0] expected;
    begin
        iterations = iterations + 1;
        subOp <= sub_in;
        a <= a_in;
        b <= b_in;
        c <= c_in;
        d <= d_in;
        #1;
        if (out !== expected) begin
            $display("Test failed for: ");
            $display("a = 0x%0h; b = 0x%0h;", a_in, b_in);
            $display("c = 0x%0h; d = 0x%0h;", c_in, d_in);
            $display("subOp = 0x%0h;", sub_in);
            $display("Result: 0x%0h; Expected: 0x%0h", out, expected);
            $display(" ");
        end else begin
            passed_tests = passed_tests + 1;
        end
    end
endtask


initial begin
    $dumpfile("./build/Adder_module_tb.vcd");
    $dumpvars(0, Adder_module_tb);
    roundingMode <= 3'b000;
    a <= 16'h0000;
    b <= 16'h0000;
    c <= 16'h0000;
    d <= 16'h0000;
    iterations = 0;
    passed_tests = 0;
    #1;
    check(16'h0000, 16'h0000, 16'h0000, 16'h0000, 3'b000, 16'h0000);
    check(16'h3C00, 16'h3C00, 16'h0000, 16'h0000, 3'b000, 16'h4000); // 1.0 + 1.0 = 2.0
    check(16'h4000, 16'h4000, 16'h3C00, 16'h0000, 3'b000, 16'h4500); // 2.0 + 2.0 + 1.0 = 5.0
    check(16'h4200, 16'hC200, 16'h0000, 16'h0000, 3'b000, 16'h0000); // 5.0 - 5.0 = 0.0
    check(16'h4200, 16'h4200, 16'h0000, 16'h0000, 3'b100, 16'h0000); // 5.0 + (- 5.0) = 0.0
    check(16'h4880, 16'h3C00, 16'h3800, 16'h3400, 3'b000, 16'h4960); // 9.0 + 1.0 + 0.5 + 0.25 = 10.75
    check(16'h3C00, 16'h4000, 16'h4500, 16'h4B00, 3'b101, 16'hC900); // 1.0 - 2.0 + 5.0 - 14.0 = -10.0
    check(16'h3C00, 16'hBC00, 16'h0000, 16'h0000, 3'b000, 16'h0000); // 1.0 + (-1.0) = 0.0
    check(16'h3C00, 16'hBC00, 16'h0000, 16'h0000, 3'b100, 16'h4000); // 1.0 - (-1.0) = 2.0
    check(16'h3C00, 16'h3C00, 16'h3C00, 16'h3C00, 3'b000, 16'h4400); // 1.0 + 1.0 + 1.0 + 1.0 = 4.0
    $display("Passed tests: %d/%d", passed_tests, iterations);
    $finish;
end

endmodule