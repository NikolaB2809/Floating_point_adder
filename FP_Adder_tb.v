module FP_Adder_tb;

localparam WIDTH = 16;

reg serial1_in;
reg serial2_in;
reg serial3_in;
reg serial4_in;
reg wr_in;
reg setup_serial_in;
reg clk_in;
reg rst_in;
reg output_clk_in;
reg output_read_in;
wire input_rdy;
wire output_rdy;
wire serial_out;

integer iterations;
integer passed_tests;

integer i;
reg [WIDTH-1:0] result;

FP_Adder dut(
    .serial1_in(serial1_in),
    .serial2_in(serial2_in),
    .serial3_in(serial3_in),
    .serial4_in(serial4_in),
    .wr_in(wr_in),
    .setup_serial_in(setup_serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .output_clk_in(output_clk_in),
    .output_read_in(output_read_in),
    .input_rdy(input_rdy),
    .output_rdy(output_rdy),
    .serial_out(serial_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
    input [WIDTH-1:0] a_in;
    input [WIDTH-1:0] b_in;
    input [WIDTH-1:0] c_in;
    input [WIDTH-1:0] d_in;
    input [7:0] setup_in;
    input [WIDTH-1:0] expected;  // Expected result
    begin
        iterations = iterations + 1;
        wr_in <= 1'b1;
        setup_serial_in <= 1'b0;
        result <= 16'h0000;
        if (input_rdy != 1'b1) begin
            $display("Time: %0t", $time);
            $display("Test failed for: ");
            $display("a = 0x%0h; b = 0x%0h;", a_in, b_in);
            $display("c = 0x%0h; d = 0x%0h;", c_in, d_in);
            $display("Input ready signal not set");
        end
        for (i = 0; i < WIDTH; i = i + 1) begin
            serial1_in <= d_in[i];
            serial2_in <= c_in[i];
            serial3_in <= b_in[i];
            serial4_in <= a_in[i];
            if (i < 8) begin
                setup_serial_in <= setup_in[i];
            end
            #10;
        end
        wr_in <= 1'b0;
        setup_serial_in <= 1'b0;
        #30;
        output_read_in <= 1'b1;
        #10;
        for (i = 0; i < WIDTH; i = i + 1) begin
            result[i] <= serial_out;
            #10;
        end
        output_read_in <= 1'b0;
        #10;
        if (result !== expected) begin
            $display("Time: %0t", $time);
            $display("Test failed for: ");
            $display("a = 0x%0h; b = 0x%0h;", a_in, b_in);
            $display("c = 0x%0h; d = 0x%0h;", c_in, d_in);
            $display("Setup = 0x%0h;", setup_in);
            $display("Result: 0x%0h; Expected: 0x%0h", result, expected);
            $display(" ");
        end else begin
            passed_tests = passed_tests + 1;
        end
    end
endtask

initial begin
    $dumpfile("FP_Adder_tb.vcd");  // Specify VCD file name
    $dumpvars(0, FP_Adder_tb);     // Dump all variables in the module
    iterations = 0;
    passed_tests = 0;
    serial1_in <= 1'b0;
    serial2_in <= 1'b0;
    serial3_in <= 1'b0;
    serial4_in <= 1'b0;
    wr_in <= 1'b0;
    setup_serial_in <= 1'b0;
    clk_in <= 1'b0;
    rst_in <= 1'b1;
    output_clk_in <= 1'b0;
    output_read_in <= 1'b0;
    #10;
    rst_in <= 1'b0;
    #10;
    check(16'h0000, 16'h0000, 16'h0000, 16'habcd, 8'b00011100, 16'h0000);
    check(16'h3C00, 16'h3C00, 16'h0000, 16'h0000, 8'b00011110, 16'h4000); // 1.0 + 1.0 = 2.0
    check(16'h4000, 16'h4000, 16'h3C00, 16'h1111, 8'b00011100, 16'h4500); // 2.0 + 2.0 + 1.0 = 5.0
    check(16'h4200, 16'hC200, 16'h0000, 16'h0000, 8'b00011110, 16'h0000); // 5.0 - 5.0 = 0.0
    check(16'h4200, 16'h4200, 16'h4200, 16'h4200, 8'b10011000, 16'h0000); // 5.0 + (- 5.0) = 0.0
    check(16'h4880, 16'h3C00, 16'h3800, 16'h3400, 8'b00011110, 16'h4960); // 9.0 + 1.0 + 0.5 + 0.25 = 10.75
    check(16'h3C00, 16'h4000, 16'h4500, 16'h4B00, 8'b10111110, 16'hC900); // 1.0 - 2.0 + 5.0 - 14.0 = -10.0
    check(16'h3C00, 16'hBC00, 16'h0000, 16'h0000, 8'b00011110, 16'h0000); // 1.0 + (-1.0) = 0.0
    check(16'h3C00, 16'hBC00, 16'h0000, 16'h0000, 8'b10011110, 16'h4000); // 1.0 - (-1.0) = 2.0
    check(16'h3C00, 16'h3C00, 16'h3C00, 16'h3C00, 8'b00011110, 16'h4400); // 1.0 + 1.0 + 1.0 + 1.0 = 4.0
    $display("Passed tests: %d/%d", passed_tests, iterations);
    $finish;
end


endmodule