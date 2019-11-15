`timescale 1 ps/ 1 ps
module led_0_7_tb();

reg clk;
reg nrst;

reg [7:0] dataout;
reg [7:0] en;

led_0_7 led_0_7_inst0(clk, nrst, dataout, en);

initial                                                
begin                                                  
  clk = 0;
  nrst = 1;
  $display("Running testbench");                       
end

always #5 clk = ~clk;

initial begin
	#25 nrst = 0;
	#1000 $finish();
end

endmodule //led_0_7_tb