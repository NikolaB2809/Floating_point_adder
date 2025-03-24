module Output_reg_tb;

localparam WIDTH = 16;

reg [WIDTH-1:0] parallel_in;
reg clk_in;
reg rst_in;
reg wr_in;
reg output_read_in;
wire output_rdy;
wire serial_out;

reg [WIDTH-1:0] result;
integer i;
integer iteration;
integer num_of_tests;
integer test_failed;
integer passed_tests;

Output_reg dut(
    .parallel_in(parallel_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .wr_in(wr_in),
    .output_read_in(output_read_in),
    .output_rdy(output_rdy),
    .serial_out(serial_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [WIDTH-1:0] in;  // Inputs to apply
        input [WIDTH-1:0] expected;  // Expected result
        begin
            wr_in <= 1'b1;
            parallel_in <= in;
            test_failed = 0;
            if (output_rdy == 1'b1) begin
                $display("Test failed for in = 0x%0h: output_rdy = 0x%0b; expected: 0", in, output_rdy);
                test_failed = 1;
            end
            #10;
            wr_in <= 1'b0;
            if (output_rdy == 1'b0) begin
                $display("Test failed for in = 0x%0h: output_rdy = 0x%0b; expected: 1", in, output_rdy);
                test_failed = 1;
            end
            output_read_in <= 1'b1;
            #10;
            for (i = 0; i < 16; i = i + 1) begin
                result[i] <= serial_out;
                #10;
            end
            output_read_in <= 1'b0;
            if (result !== expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, result);
                test_failed = 1;
            end
            num_of_tests = num_of_tests + 1;
            if (test_failed == 0) begin
                passed_tests = passed_tests + 1;
            end
        end
    endtask

initial begin
    parallel_in = 16'h0000;
    clk_in = 1'b0;
    rst_in = 1'b1;
    wr_in = 1'b0;
    output_read_in = 1'b0;
    num_of_tests = 0;
    passed_tests = 0;
    #10;
    rst_in = 0;
    #10;
    for (iteration = 0; iteration <= 16'hffff; iteration = iteration + 1) begin
        check(iteration[WIDTH-1:0], iteration[WIDTH-1:0]);
    end
    $display("Passed tests: %d/%d", passed_tests, num_of_tests);
    $finish;
end

endmodule