// Binary-to-BCD counter example

module top (
	input hwclk,
	output [7:0] counter,
	output blank,
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

	// Three BCD digits holding converted counter value
	wire [3:0] units;
	wire [3:0] tens;
	wire [1:0] hundreds;

	// Actively displayed digit
	reg [3:0] activeDigit;

	// 7-segment display output for active digit
	wire [6:0] segments;
	wire displayclk;

	// Leading zero tracking bit. When 1 and current digit
	// is 0, display is blanked.
	reg blank = 0;

	// Display multiplexing clock, 20KHz
	scaler #(.N(300)) scaler2 (hwclk, displayclk);

	// 8-bit binary to 3-digit BCD converter 
	bcd_combinational bcd (counter, units, tens, hundreds);

	// BCD to 7 segment converter
	sevensegment display(activeDigit, 0, segments, rbo);
	wire rbo;

	// Digit enable bits, active high.
	reg[2:0] enable = 3'b000;

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
	always @(posedge displayclk) begin
		case(displayState)
			HUNDREDS: begin
				activeDigit <= hundreds;
				if (hundreds == 0 && blank == 1) begin
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
				if (tens == 0 && blank == 1) begin
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


	// Assign outputs
	assign SEGMENTS = segments;
	assign ENABLE = enable;
endmodule