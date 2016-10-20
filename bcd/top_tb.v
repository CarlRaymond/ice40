// Testbench for top-level module

module top_tb();

	top dut (clk, counter, blank, segments, enable);

	reg clk;
	output [7:0] counter;
	output blank;
	output [6:0] segments;
	output [2:0] enable;

	initial  begin
    	$dumpfile ("top.vcd"); 
    	$dumpvars; 
    	$display("\t\ttime\tcount\tblank\tsegments\tenable"); 
    	$monitor("%d\t%d\t%b\t%b\t%b",$time, counter, blank, segments, enable); 
		clk = 0;
	end 

	always begin
		#1 clk = clk + 1;
	end
   	
	initial begin
		#120000000 $finish;
	end
endmodule
