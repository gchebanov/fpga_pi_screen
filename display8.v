module display8 (
	input wire clk,
	input wire rst,
	input reg [3:0] output_fn [7:0],
	output wire [7:0] dataout_w,
	output wire [7:0] en_w
);

reg [15:0] cnt_scan;
reg [3:0] dataout_buf;

reg [7:0] dataout;
reg [7:0] en;

assign dataout_w = dataout;
assign en_w = en;

always @(posedge clk) begin
	if (rst) begin
		cnt_scan <= 0;
	end else begin
		cnt_scan <= cnt_scan + 1;
	end
end

always @(posedge clk) begin
   case(cnt_scan[15:13])
       3'b000 : en <= 8'b1111_1110;
       3'b001 : en <= 8'b1111_1101;
       3'b010 : en <= 8'b1111_1011;
       3'b011 : en <= 8'b1111_0111;
       3'b100 : en <= 8'b1110_1111;
       3'b101 : en <= 8'b1101_1111;
       3'b110 : en <= 8'b1011_1111;
       3'b111 : en <= 8'b0111_1111;
       default : en <= 8'b1111_1110;
    endcase
end

always @(posedge clk) begin
	case(en)
		8'b1111_1110: dataout_buf <= output_fn[7];
		8'b1111_1101: dataout_buf <= output_fn[6];
		8'b1111_1011: dataout_buf <= output_fn[5];
		8'b1111_0111: dataout_buf <= output_fn[4];	
		8'b1110_1111: dataout_buf <= output_fn[3];
		8'b1101_1111: dataout_buf <= output_fn[2];
		8'b1011_1111: dataout_buf <= output_fn[1];
		8'b0111_1111: dataout_buf <= output_fn[0];
		default: dataout_buf <= 10;
	endcase
end

always @(posedge clk) begin
	case(dataout_buf)
		4'b0000: dataout <= 8'b1100_0000;
		4'b0001: dataout <= 8'b1111_1001;
		4'b0010: dataout <= 8'b1010_0100;
		4'b0011: dataout <= 8'b1011_0000;
		4'b0100: dataout <= 8'b1001_1001;
		4'b0101: dataout <= 8'b1001_0010;
		4'b0110: dataout <= 8'b1000_0010;
		4'b0111: dataout <= 8'b1111_1000;
		4'b1000: dataout <= 8'b1000_0000;
		4'b1001: dataout <= 8'b1001_0000;
		
//		4'b1010: dataout <= 8'b1000_1000;
//		4'b1011: dataout <= 8'b1000_0011;
//		4'b1100: dataout <= 8'b1100_0110;
//		4'b1101: dataout <= 8'b1010_0001;
//		4'b1110: dataout <= 8'b1000_0110;
//		4'b1111: dataout <= 8'b1000_1110;

		default: dataout <= 8'b0111_1111;
	endcase
end

endmodule // display8