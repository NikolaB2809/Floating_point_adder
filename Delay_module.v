module Delay_module(
    input in,
    input clk_in,
    input rst_in,
    output out
);

localparam DELAY = 17;
integer i;

reg [DELAY-1:0] shift_register;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        shift_register <= 16'h0000;
    end else begin
        if (~|shift_register & in) begin
            shift_register[DELAY-1] <= in;
        end else begin
            shift_register[DELAY-1] <= 1'b0;
        end
        for (i = DELAY - 1; i > 0; i = i - 1) begin
            shift_register[i - 1] <= shift_register[i];
        end
    end
end

assign out = shift_register[0];

endmodule