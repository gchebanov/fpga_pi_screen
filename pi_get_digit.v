module pi_get_digit # (
	parameter N = 17
) (
	input wire clk,
	input wire rst,
	input wire [N-1:0] pi_index,
	output wire [3:0] pi_digit
);

localparam MEM_W = 36;
localparam D = 0;
reg [N-1:0] addr [D:0];
reg [N-1:0] addr_base [D:0];
reg [N-1:0] digit_base [D:0];
reg [N-1:0] digit_base10 [D:0];
reg [5:0] addr_shift [D:0];
reg [2:0] digit_shift [D:0];

always @(posedge clk) begin
	for (int i = 1; i <= D; i++) begin
		addr[i] <= addr[i-1];
		addr_base[i] <= addr_base[i-1];
		digit_base[i] <= digit_base[i-1];
		digit_base10[i] <= digit_base10[i-1];
		addr_shift[i] <= addr_shift[i-1];
		digit_shift[i] <= digit_shift[i-1];
	end
end

wire [MEM_W-1:0] mem_q;
pi_mem pi_mem1 (clk, addr[0], mem_q);

reg [9:0] dpd_b_in;
reg [3:0] dpd_d_out [2:0];
dpd_decoder dpd_ins0(dpd_b_in, dpd_d_out);
assign pi_digit = dpd_d_out[2 - digit_shift[D]];

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
		addr[0] <= addr_base[D] + cnt;
		addr_base[0] <= digit_base10[D] / MEM_W;
		addr_shift[0] <= digit_base10[D] % MEM_W;
		digit_shift[0] <= pi_index % 3;
		digit_base[0] <= pi_index / 3;
		digit_base10[0] <= digit_base[D] * 10;
		mem_ab <= {mem_b, mem_a};
		dpd_b_in <= mem_ab[addr_shift[D] +: 10];
	end
end

endmodule // pi_get_digit

