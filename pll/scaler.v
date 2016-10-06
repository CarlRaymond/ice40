module scaler (input clk_in, output clk_out);

	reg ready = 0;
	reg clk_out = 0;
	reg [23:0] counter = 0;

	always @(posedge clk_in) begin
    if (ready) 
        begin
           if (counter == 12000000) 
             begin
                counter <= 0;
                clk_out = ~clk_out;
             end
           else 
             counter <= counter + 1;
        end
      else 
        begin
           ready <= 1;
           counter <= 0;
        end
   end		
endmodule