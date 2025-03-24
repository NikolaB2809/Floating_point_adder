// This module is an output register which has a parallel input and serial output
module Output_reg(
    input [15:0] parallel_in,  // Parallel input for data
    input clk_in,              // Clock input
    input rst_in,              // Reset input (active high)
    input wr_in,               // Write enable signal - used to write into the register
    input output_read_in,      // Output read signal - used to read from the register serially
    output reg output_rdy,     // Output ready signal - used to signal that the register can be read from
    output reg serial_out      // Serial output
);

localparam WIDTH = 16;

reg [WIDTH-1:0] value;
integer i;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        serial_out <= 1'b0;
        value <= 32'b0;
        output_rdy <= 1'b0;
    end else begin
        if (wr_in == 1'b1) begin
            value <= parallel_in;
            output_rdy <= 1'b1;
            serial_out <= 1'b0;
        end else if (output_read_in == 1'b1) begin
            output_rdy <= 1'b0;
            serial_out <= value[0];
            for (i = 0; i < WIDTH - 1; i = i + 1) begin
                value[i] <= value[i + 1];
            end
            value[WIDTH - 1] <= 1'b0;
        end else begin
            value <= value;
        end
    end
end

endmodule