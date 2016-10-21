module display_multiplexer(data, clk, segments, enable);
	input [7:0] data;
	input clk;
	output  [6:0] segments;
	output reg [2:0] enable;

	// Three BCD digits holding converted data value
	wire [3:0] units;
	wire [3:0] tens;
	wire [1:0] hundreds;

	// Actively displayed digit
	reg [3:0] activeDigit;

	// Leading zero tracking bit. When 1 and current digit
	// is 0, display is blanked.
	reg blank = 0;

	// 8-bit binary to 3-digit BCD converter 
	bcd_combinational bcd (data, units, tens, hundreds);

	// BCD to 7 segment converter
	sevensegment display(activeDigit, rbi, segments, rbo);
	reg rbi;	// Ripple blanking input
	wire rbo;	// Ripple blanking output. Unused.

	// State definitions for one-hot digit multiplexing
	parameter[2:0]
		START = 3'b000,
		HUNDREDS = 3'b100,
		TENS = 3'b010,
		UNITS = 3'b001
		;

	// One-hot state cycles (HUNDREDS => TENS => UNITS => HUNDREDS)
	// to multiplex the displayed digit
	reg[2:0] displayState = START;

	// Digit cycling and blanking
	always @(posedge clk) begin
		case(displayState)
			HUNDREDS: begin
				activeDigit <= hundreds;
				enable <= displayState;

				if (hundreds == 0 && blank == 1) begin
					// Blank the digit
					rbi <= 1;
				end
				else begin
					// Show the digit
					rbi <= 0;

					// Don't blank subsequent digits
					blank <= 0;
				end

				// Move to next digit
				displayState <= TENS;
			end

			TENS: begin
				activeDigit <= tens;
				enable <= displayState;

				if (tens == 0 && blank == 1) begin
					// Blank the digit
					rbi <= 1;
				end
				else begin
					// Show the digit
					rbi <= 0;
					
					// Don't blank subsequent digits
					blank <= 0;
				end

				// Move to next digit
				displayState <= UNITS;
			end

			UNITS: begin
				activeDigit <= units;
				enable <= displayState;

				// Never blank units
				rbi <= 0;

				// Prepare to blank MSD on next pass
				blank <= 1;

				// Move to next digit
				displayState <= HUNDREDS;
			end

			default: begin
				// START or other state: initialize
				blank <= 1;
				enable <= 0;
				displayState <= HUNDREDS;
			end
		endcase
	end


endmodule