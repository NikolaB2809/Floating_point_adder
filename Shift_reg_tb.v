module Shift_reg_tb;

localparam WIDTH = 16;

reg serial_in;
reg clk_in;
reg rst_in;
reg en_in;
reg wr_in;
wire input_rdy;
wire [WIDTH-1:0] parallel_out;

integer i;

Shift_reg dut(
    .serial_in(serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(en_in),
    .wr_in(wr_in),
    .input_rdy(input_rdy),
    .parallel_out(parallel_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [WIDTH-1:0] in;  // Inputs to apply
        input [WIDTH-1:0] expected;  // Expected result
        begin
            wr_in <= 1'b1;
            en_in <= 1'b0;
            for(i = 0; i < WIDTH; i = i + 1) begin
                serial_in = in[i];
                if (input_rdy == 1'b1 && i > 0) begin
                    $display("Test failed for in = 0x%0h: input_rdy = %d; expected: 0; iteration: %d", in, input_rdy, i);
                end
                #10;
            end
            wr_in <= 1'b0;
            #10;
            if (parallel_out != 16'h0000) begin
                $display("Test failed for in = 0x%0h: expected: 0x0000, got: 0x%0h", in, parallel_out);
            end
            en_in <= 1'b1;
            #10;
            if (parallel_out != expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, parallel_out);
            end else begin
                $display("Test passed for in = 0x%0h; Result: 0x%0h", in, parallel_out);
            end
            if (input_rdy == 0) begin
                $display("Test failed for in = 0x%0h: input_rdy = %d; expected: 1;", in, input_rdy);
            end
        end
    endtask

initial begin
    $dumpfile("./build/Shift_reg_tb.vcd");
    $dumpvars(0, Shift_reg_tb);
    serial_in <= 1'b0;
    clk_in <= 1'b0;
    rst_in <= 1'b1;
    wr_in <= 1'b0;
    en_in <= 1'b0;
    #10;
    rst_in <= 0;
    #10;
    check(16'h0000, 16'h0000);
    check(16'hffff, 16'hffff);
    check(16'habcd, 16'habcd);
    check(16'h6789, 16'h6789);
    $finish;
end

endmodule