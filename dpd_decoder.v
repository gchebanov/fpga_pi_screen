module dpd_decoder(
	input wire [9:0]b_in,
	output wire [3:0]d_out[2:0]
);

assign d_out[0][0] = b_in[0];
assign d_out[1][0] = b_in[4];
assign d_out[2][0] = b_in[7];

wire [6:0] b;
assign b = {b_in[9:8], b_in[6:5], b_in[3:1]};

logic [8:0] d;
assign d_out[0][3:1] = d[2:0];
assign d_out[1][3:1] = d[5:3];
assign d_out[2][3:1] = d[8:6];

always_comb begin
	casez (b)
	7'b????0??: d = {1'b0, b[6:5], 1'b0, b[4:3], 1'b0, b[1:0]};
	
	7'b????100: d = {1'b0, b[6:5], 1'b0, b[4:3], 3'b100};
	7'b????101: d = {1'b0, b[6:5], 3'b100, 1'b0, b[1:0]};
	7'b????110: d = {3'b100, 1'b0, b[4:3], 1'b0, b[1:0]};
	
	7'b??00111: d = {6'b100100, 1'b0, b[1:0]};
	7'b??01111: d = {4'b1000, b[4:3], 3'b100};
	7'b??10111: d = {1'b0, b[6:5], 6'b100100};
	
	7'b??11111: d = 9'b100100100;
	default: d = '0;
	endcase
end

endmodule