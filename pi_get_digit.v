module pi_get_digit # (
	parameter N = 17
) (
	input wire clk,
	input wire rst,
	input wire [N-1:0] pi_index,
	output logic [3:0] pi_digit
);

localparam MEM_W = 36;

reg [N-1:0] addr;
reg [N-1:0] addr_base;
reg [N-1:0] addr_base_unshift;
reg [N-1:0] digit_base;
reg [N-1:0] digit_base_unshift;
reg [N-1:0] digit_base10;
reg [5:0] addr_shift;
reg [1:0] digit_shift;

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
		addr[0] <= 0;
		addr_base[0] <= 0;
		addr_shift[0] <= 0;
		digit_shift[0] <= 0;
		digit_base[0] <= 0;
		digit_base10[0] <= 0;
		mem_ab <= '0;
		dpd_b_in <= '0;
	end else begin
		cnt <= ~cnt;
		addr <= addr_base + cnt;
		addr_base <= ((digit_base10 / 4) * 32'd29128) / 19'h4_0000;
		addr_base_unshift <= addr_base * MEM_W;
		addr_shift <= digit_base10 - addr_base_unshift;
		digit_base_unshift <= digit_base * 2'd3;
		digit_shift <= pi_index - digit_base_unshift;
		digit_base <= (pi_index * 32'd87382) / 19'h4_0000;
		digit_base10 <= digit_base * 4'd10;
		mem_ab <= {mem_b, mem_a};
		dpd_b_in <= mem_ab[addr_shift +: 10];
	end
end

endmodule // pi_get_digit

