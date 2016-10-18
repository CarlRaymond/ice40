// Add3 module for BCD conversion: if input is 5 or greater, add 3. Otherwise pass through.
module add3(in, out);

	input [3:0] in;
	output [3:0] out;
	always @ (*) begin
		case (in)
			4'b0000: out = 4'b0000;	// 0 => 0
			4'b0001: out = 4'b0001;	// 1 => 1
			4'b0010: out = 4'b0010;	// 2 => 2
			4'b0011: out = 4'b0011;	// 3 => 3
			4'b0100: out = 4'b0100;	// 4 => 4
			4'b0101: out = 4'b1000;	// 5 => 8
			4'b0110: out = 4'b1001;	// 6 => 9
			4'b0111: out = 4'b1010;	// 7 => 10
			4'b1000: out = 4'b1011;	// 8 => 11
			4'b1001: out = 4'b1100;	// 9 => 12
			default: out = 4'b0000;
		endcase
	end
endmodule