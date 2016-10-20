module sevensegment_tb();
	sevensegment dut (data, rbi, segments, rbo);

	reg [3:0] data;
	reg rbi;
	wire [6:0] segments;
	wire rbo;


	initial  begin
    	$dumpfile ("sevensegment.vcd"); 
    	$dumpvars; 
      $display("\t\ttime,\tdata,\tsegments"); 
      $monitor("%d,\t%b,\t%b",$time, data, segments); 
	  data = 4'b0000;
    end 
      
	always begin
		#10 data = data + 1;
	end

	initial begin
		#200 $finish;
	end
endmodule