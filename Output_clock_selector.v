module Output_clock_selector(
    input sel_in,
    input clk_internal_in,
    input clk_external_in,
    output clk_out
);

assign clk_out = (!sel_in & clk_internal_in) | (sel_in & clk_external_in);

endmodule