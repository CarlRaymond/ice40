module display_multiplexer_tb ();

	display_multiplexer dut (data, clk, segments, enable);

	reg clk;
	reg [7:0] data;
	wire [6:0] segments;
	wire [2:0] enable;

	initial  begin
    	$dumpfile ("display_multiplexer.vcd"); 
    	$dumpvars; 
    	$display("\t\ttime\tdata\tsegments\tenable"); 
    	$monitor("%d\t%d\t%b\t%b",$time, data, segments, enable); 
		clk <= 0;
		
		data <= 8'd0;
		#12 data <= 8'd42;
		#24 data <= 8'd255;
	end 

	always begin
		#1 clk = ~clk;
	end
   	
	initial begin
		#50 $finish;
	end

endmodule