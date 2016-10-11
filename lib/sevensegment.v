module sevensegment (data, rbi, segments, rbo);
	input [3:0] data;
	input rbi;
	output reg [6:0] segments; // from g to a
	output rbo;

	always @*
	if (rbi & data == 4'b0000) begin
		segments = 7'b0000000;
		rbo = 1;

	end else begin
		rbo = 0;
		case (data)
			4'b0000: segments = 7'b0111111;	// 0: a b c d e f -
			4'b0001: segments = 7'b0000110; // 1: - b c - - - -
			4'b0010: segments = 7'b1011011;	// 2: a b - d e - g
			4'b0011: segments = 7'b1001111; // 3: a b c d - - g
			4'b0100: segments = 7'b1100110; // 4: - b c - - f g
			4'b0101: segments = 7'b1101101;	// 5: a - c d - f g
			4'b0110: segments = 7'b1111101; // 6: a - c d e f g
			4'b0111: segments = 7'b0100111; // 7: a b c - - f -
			4'b1000: segments = 7'b1111111; // 8: a b c d e f g
			4'b1001: segments = 7'b1101111; // 9: a b c d - f g
			4'b1010: segments = 7'b1110111; // A: a b c - e f g
			4'b1011: segments = 7'b1111100; // B: - - c d e f g
			4'b1100: segments = 7'b0111001; // C: a - - d e f -
			4'b1101: segments = 7'b1011110; // D: - b c d e - f
			4'b1110: segments = 7'b1111001; // E: a - - d e f g
			4'b1111: segments = 7'b1110001; // F: a - - - e f g
			default: segments = 7'b0000000; // blank 
		endcase
	end
endmodule
