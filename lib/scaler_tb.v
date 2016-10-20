module scaler_tb();

	scaler #(.N(10)) dut (clk_in, clk_out);

	reg clk_in;
	wire clk_out;

	initial begin
	  clk_in = 0;
	end

	always begin
		#5 clk_in = !clk_in;
	end

	initial  begin
    	$dumpfile ("scaler.vcd"); 
    	$dumpvars; 
    end 
      
    initial  begin
      $display("\t\ttime,\tclk_in,\tclk_out"); 
      $monitor("%d,\t%b,\t%b",$time, clk_in, clk_out); 
    end 
      
	initial begin
		#200 $finish;
	end
endmodule