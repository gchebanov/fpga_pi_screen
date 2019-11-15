module pi_get_digit # (
	parameter N = 17
) (
	input wire clk,
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

reg[17:0] mul_a, mul_b;
reg[35:0] mul_ab;

always @(posedge clk) begin
	mul_ab <= mul_a * mul_b;
end

reg [1:0] cnt;
reg [MEM_W-1:0] mem_a, mem_b;
reg [MEM_W*2-1:0] mem_ab;

always @(posedge clk) begin
	case (cnt[0])
	0: begin
		mem_a <= mem_q;
		addr <= addr_base + 1'b1;
	end
	1: begin
		mem_b <= mem_q;
		addr <= addr_base;
	end
	endcase
end

always @(posedge clk) begin
	case (cnt)
	0: begin
		mul_a <= digit_base10 >> 2;
		mul_b <= 29128;
		addr_base_unshift <= mul_ab;
	end
	1: begin
		mul_a <= pi_index;
		mul_b <= 87382;
		digit_base10 <= mul_ab;
	end
	2: begin
		mul_a <= addr_base;
		mul_b <= MEM_W;
		addr_base <= mul_ab[35:18];
	end
	3: begin
		mul_a <= digit_base;
		mul_b <= 4'd10;
		digit_base <= mul_ab[35:18];
	end
	endcase
end

always @(posedge clk) begin
	cnt <= cnt + 1;
	addr_shift <= digit_base10 - addr_base_unshift;
	digit_shift <= pi_index - digit_base_unshift;
	digit_base_unshift <= digit_base * 2'd3;
	mem_ab <= {mem_b, mem_a};
	dpd_b_in <= mem_ab[addr_shift +: 10];
end

endmodule // pi_get_digit

