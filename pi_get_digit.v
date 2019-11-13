module pi_get_digit # (
	parameter N = 24
) (
	input wire clk,
	input wire rst,
	input wire [N-1:0] pi_index,
	output wire [3:0] pi_digit
);

localparam MEM_W = 18;
reg [N-1:0] addr, addr_base, digit_base, digit_base10;
reg [3:0] addr_shift;
reg [2:0] digit_shift;
wire [MEM_W-1:0] mem_q;
pi_mem pi_mem1 (clk, addr, mem_q);

reg [9:0] dpd_b_in;
reg [3:0] dpd_d_out [2:0];
dpd_decoder dpd_ins0(dpd_b_in, dpd_d_out);
assign pi_digit = dpd_d_out[2 - digit_shift];

reg cnt;
reg [MEM_W-1:0] mem_a, mem_b;
reg [MEM_W*2-1:0] mem_ab;

always @(posedge clk) begin
	if (cnt) begin
		mem_a <= mem_q;
	end else begin
		mem_b <= mem_q;
	end
end

always @(posedge clk) begin
	if (rst) begin
		cnt <= 0;
		addr <= 0;
		addr_base <= 0;
		addr_shift <= 0;
		digit_shift <= 0;
		digit_base <= 0;
		digit_base10 <= 0;
		mem_ab <= '0;
		dpd_b_in <= '0;
	end else begin
		cnt <= ~cnt;
		addr <= addr_base + cnt;
		addr_base <= digit_base10 / MEM_W;
		addr_shift <= digit_base10 % MEM_W;
		digit_shift <= pi_index % 3;
		digit_base <= pi_index / 3;
		digit_base10 <= digit_base * 10;
		mem_ab <= {mem_a, mem_b};
		dpd_b_in <= mem_ab[addr_shift +: 10];
	end
end

endmodule // pi_get_digit
