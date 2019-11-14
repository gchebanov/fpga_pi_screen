module pi_mem # (
	parameter N = 24 * 256,
	parameter ADDR_W = 24,
	parameter DATA_W = 36
) (
	input wire clk,
	input wire [ADDR_W-1:0] addr,
	output wire [DATA_W-1:0] d_out
);

reg [DATA_W-1:0] data [1:0];
wire [DATA_W-1:0] mem_q;
assign d_out = data[1];

rom i_rom (addr, clk, mem_q);

always @(posedge clk) begin
	data[0] <= mem_q;
	data[1] <= data[0];
end

// 141 _ 592 _ 653 _ 589 _ 793 _ 238 _ 462 _ 643
// 001_100_0_001
// 101_011_1_010
// 110_101_0_011
// 101_100_1_111
// 111_011_1_011
// 010_011_1_000
// 100_110_0_010
// 110_100_0_011

endmodule // pi_mem