// Binary-to-BCD counter example

module top (
	input hwclk,
	output [7:0] counter,
	output [6:0] SEGMENTS, // LSB is A, MSB is G
	output [2:0] ENABLE
	);
	
	// 8-bit counter and clock. This is the data that is displayed
	// on the output.
	reg[7:0] counter = 0;
	wire countclk;

	// Count clock, 1Hz
	scaler #(.N(6000000)) scaler1 (hwclk, countclk);

	// Counter implementation
	always @(posedge countclk) begin
	  counter = counter + 1;
	end

	// Display multiplexing clock, 20KHz
	scaler #(.N(300)) scaler2 (hwclk, displayclk);

	// Display multiplexer
	display_multiplexer multi (counter, displayclk, segments, enable);
	wire [6:0] segments;
	wire [2:0] enable;

	// Assign outputs
	assign SEGMENTS = segments;
	assign ENABLE = enable;
endmodule