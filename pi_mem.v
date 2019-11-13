module pi_mem # (
	parameter N = 24 * 512,
	parameter ADDR_W = 24,
	parameter DATA_W = 18
) (
	input wire clk,
	input wire [ADDR_W-1:0] addr,
	output wire [DATA_W-1:0] d_out
);

reg [DATA_W-1:0] mem [N-1:0];
reg [DATA_W-1:0] data [2:0];

assign d_out = data[2];

// 141 _ 592 _ 653 _ 589 _ 793 _ 238 _ 462 _ 643
// 001_100_0_001
// 101_011_1_010
// 110_101_0_011
// 101_100_1_111
// 111_011_1_011
// 010_011_1_000
// 100_110_0_010
// 110_100_0_011

//2e8c1
//fd4e
//23bbb
//39893
//d0

initial begin
	$readmemh("mem.hex", mem, 0, N-1);
end

always @(posedge clk) begin
	data[0] <= mem[addr];
	data[1] <= data[0];
	data[2] <= data[1];
end

endmodule // pi_mem