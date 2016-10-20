module bcd_combinational_tb();

	bcd_combinational dut(data, units, tens, hundreds);

	reg [7:0] data;
	wire [1:0] hundreds;
	wire [3:0] tens;
	wire [3:0] units;

	initial  begin
    	$dumpfile ("bcd_combinational.vcd"); 
    	$dumpvars; 
    	$display("\t\ttime,\tdata,\t100s,\t10s,\t1s"); 
    	$monitor("%d,\t%d,\t%d,\t%d,\t%d",$time, data, hundreds, tens, units); 
		data = 4'b0000;
    end 
  
	always begin
		#10 data = data + 1;
	end

	initial begin
		#2600 $finish;
	end

endmodule