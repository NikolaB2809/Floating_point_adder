module Shift_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    input wr_in,
    output reg input_rdy,
    output reg [15:0] parallel_out
);

localparam WIDTH = 16;

reg [3:0] count;
reg [WIDTH-1:0] value;
integer i;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 32'b0;
        input_rdy <= 1'b1;
        count <= 4'b000;
        value <= 16'h0000;
    end else begin
        if (count == 4'b1111) begin
            count <= 4'b0000;
            input_rdy <= 1'b1;
        end else if (wr_in == 1'b1) begin
            for (i = WIDTH - 1; i > 0; i = i - 1) begin
                value[i - 1] <= value[i];
            end
            value[WIDTH-1] <= serial_in;
            if (input_rdy == 1'b1) begin
                input_rdy <= 1'b0;
            end else begin
                count <= count + 1;
            end
        end
        if (en_in == 1'b1) begin
            parallel_out <= value;
        end else begin
            parallel_out <= 16'h0000;
        end
    end
end

endmodule