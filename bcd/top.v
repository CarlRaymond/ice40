// Binary-to-BCD counter example

module top (
	input hwclk,
	output SEG_A, 
	output SEG_B,
	output SEG_C,
	output SEG_D,
	output SEG_E,
	output SEG_F,
	output SEG_G,
	output SEG_DP,
	output STROBE_UNITS,
	output STROBE_TENS,
	output STROBE_HUNDREDS);
	
	reg[7:0] counter = 0;
	wire countclk;

	wire [3:0] units;
	wire [3:0] tens;
	wire [1:0] hundreds;
	wire [6:0] unitsSegs;
	wire [6:0] tensSegs;
	wire [6:0] hundredsSegs;
	wire unitsRbo;
	wire tensRbo;

	bcd_combinational bcd (counter, units, tens, hundreds);

	sevensegment unitsDigit(units, 0, unitsSegs);
	sevensegment tensDigit(tens, 1, tensSegs, tensRbo);
	sevensegment hundredsDigit(hundreds, tensRbo, hundredsSegs);

	// Count once per second
	scaler #(.N(12000000)) scaler1 (hwclk, countclk);
	always @(posedge countclk) begin
	  counter = counter + 1;
	end

	// Temporary
	assign SEG_A = unitsSegs[0];
	assign SEG_B = unitsSegs[1];
	assign SEG_C = unitsSegs[2];
	assign SEG_D = unitsSegs[3];
	assign SEG_E = unitsSegs[4];
	assign SEG_F = unitsSegs[5];
	assign SEG_G = unitsSegs[6];
	assign SEG_DP = 0;

	assign STROBE_UNITS = 0;
	assign STROBE_TENS = 1;
	assign STROBE_HUNDREDS = 1;
endmodule