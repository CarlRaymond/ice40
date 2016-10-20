module scaler (input clk_in, output clk_out);

	reg clk_out = 0;
	reg [23:0] counter = 0;
  parameter N = 6000000;

	always @(posedge clk_in) begin
    if (counter == N) 
      begin
        counter <= 0;
        clk_out <= ~clk_out;
      end
    else 
      counter <= counter + 1;
   end		
endmodule