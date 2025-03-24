module Setup_reg_tb;

reg serial_in;
reg clk_in;
reg rst_in;
reg en_in;
wire [7:0] parallel_out;
integer i;

Setup_reg dut(
    .serial_in(serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(en_in),
    .parallel_out(parallel_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [7:0] in;  // Inputs to apply
        input [7:0] expected;  // Expected result
        begin
            // Apply stimulus
            en_in <= 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                if (i < 8) begin
                    serial_in <= in[i];
                end else begin
                    serial_in <= 1'b1;
                end
                #10;
            end
            en_in <= 1'b0;
            for (i = 0; i < 16; i = i + 1) begin
                serial_in <= 1'b1;
                #10;
            end
            // Compare expected and actual output
            if (parallel_out !== expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, parallel_out);
            end else begin
                $display("Test passed for in = 0x%0h; Result: 0x%0h", in, parallel_out);
            end
        end
    endtask

initial begin
    $dumpfile("./build/Setup_reg_tb.vcd");
    $dumpvars(0, Setup_reg_tb);
    serial_in <= 1'b0;
    clk_in <= 1'b0;
    en_in <= 1'b0;
    rst_in <= 1'b1;
    #10;
    rst_in <= 1'b0;
    check(8'h00, 8'h00);
    check(8'haa, 8'haa);
    check(8'hff, 8'hff);
    check(8'h12, 8'h12);
    check(8'hcd, 8'hcd);
    $finish;
end

endmodule