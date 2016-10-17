// Binary-to-BCD counter example

module top (
	input hwclk,
	output SEGMENT_A, 
	output SEGMENT_B,
	output SEGMENT_C,
	output SEGMENT_D,
	output SEGMENT_E,
	output SEGMENT_F,
	output SEGMENT_G,
	output SEGMENT_DP,
	output ENABLE_UNITS,
	output ENABLE_TENS,
	output ENABLE_HUNDREDS);
	
	// 8-bit counter and clock. This is the data that is displayed
	// on the output.
	reg[7:0] counter = 0;
	wire countclk;

	// Three BCD digits holding converted counter value
	wire [3:0] units;
	wire [3:0] tens;
	wire [1:0] hundreds;

	// Actively displayed digit
	wire [3:0] activeDigit;

	// 7-segment display output for active digit
	reg [6:0] segments;
	wire displayclk;

	// Ripple-blanking tracking bit. When 1 and current digit
	// is 0, display is blanked.
	reg blank = 0;

	// Count clock, 1Hz
	scaler #(.N(12000000)) scaler1 (hwclk, countclk);

	// Display clock, 20KHz
	scaler #(.N(600)) scaler2 (hwclk, displayclk);

	// 8-bit binary to 3-digit BCD converter 
	bcd_combinational bcd (counter, units, tens, hundreds);

	// BCD to 7 segment converter
	sevensegment display(activeDigit, 0, segments);

	// Counter implementation
	always @(posedge countclk) begin
	  counter = counter + 1;
	end

	// Digit enable bits, active high.
	reg[2:0] enable = 3'b000;

	// State definitions for one-hot digit enable
	parameter[2:0]
		START = 3'b000,
		HUNDREDS = 3'b100,
		TENS = 3'b010,
		UNITS = 3'b001
		;

	// One-hot state cycles (HUNDREDS => TENS => UNITS => HUNDREDS) to display the active digit
	reg[2:0] displayState = START;

	// Digit cycling and blanking
	always @(displayclk) begin
		case(displayState)
			HUNDREDS: begin
				activeDigit <= hundreds;
				if (activeDigit == 0 && blank == 1) begin
					// Blank the digit
					enable <= 0;
				end
				else begin
					// Show the digit
					enable <= displayState;
					// Don't blank subsequent digits
					blank <= 0;
				end

				// Move to next digit
				displayState <= TENS;
			end

			TENS: begin
				activeDigit <= tens;
				if (activeDigit == 0 && blank == 1) begin
					// Blank the digit
					enable <= 0;
				end
				else begin
					// Show the digit
					enable <= displayState;
					// Don't blank subsequent digits
					blank <= 0;
				end

				// Move to next digit
				displayState <= UNITS;
			end

			UNITS: begin
				activeDigit <= units;
				// Never blank units
				enable <= displayState;

				// Prepare to blank MSD on next pass
				blank <= 0;

				// Move to next digit
				displayState = HUNDREDS;
			end

			default: begin
				// START or other state: initialize
				blank <= 1;
				enable <= 0;
				displayState <= HUNDREDS;
			end
		endcase
	end


	// Assign outputs
	assign SEGMENT_A = segments[0];
	assign SEGMENT_B = segments[1];
	assign SEGMENT_C = segments[2];
	assign SEGMENT_D = segments[3];
	assign SEGMENT_E = segments[4];
	assign SEGMENT_F = segments[5];
	assign SEGMENT_G = segments[6];
	assign SEGMENT_DP = 0;

	assign ENABLE_UNITS = enable[0];
	assign ENABLE_TENS = enable[1];
	assign ENABLE_HUNDREDS = enable[2];

endmodule