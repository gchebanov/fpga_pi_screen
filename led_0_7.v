module led_0_7 (
	input wire clk,
	input wire nrst,
	output wire [7:0] dataout,
	output wire [7:0] en
);

localparam MAXN = (30 * 256) * 36 / 10 * 3 - 8;

wire rst = !nrst;

reg [3:0] output_fn [7:0];
display8 display8_0 (
	clk, rst, output_fn, dataout, en
);

reg [16:0] pi_index;
wire [3:0] pi_digit_out;
pi_get_digit pgd0(
	clk, rst, pi_index, pi_digit_out
);

reg [31:0] cnt, pi_digit_base;
always @(posedge clk) begin
	if (rst) begin
		cnt <= 0;
		pi_digit_base <= 0;
		pi_index <= 0;
		output_fn <= '{default:0};
	end else begin
		cnt <= cnt + 1;
		if (pi_digit_base < MAXN) begin
			pi_digit_base <= pi_digit_base + (cnt[24:0] == '1 ? 1 : 0);
		end else begin
			pi_digit_base <= 0;
		end
		pi_index <= pi_digit_base + cnt[15:13];
		output_fn[cnt[15:13]] <= pi_digit_out;
	end
end

endmodule // led_0_7
