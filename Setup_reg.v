module Setup_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    output reg [7:0] parallel_out
);

reg [3:0] count;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 8'h0;
        count        <= 6'b000000;
    end else begin
        if (en_in == 1'b1) begin
            if (count < 8) begin
                parallel_out[count] <= serial_in;
                count <= count + 1;
            end else begin
                count <= count + 1; 
            end
        end else begin
            count <= count;
        end
    end
end

endmodule