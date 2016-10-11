module top(input hwclk, output D1, output D2, output D3, output D4, output D5);
   
    wire hwclk;       // Hardware clock, 12MHz
    wire clk_fast;    // Fast clock, stepped up by PLL
    wire clk_scaler1; // Output from scaler1
    wire clk_scaler2; // Output from scaler2

    wire BYPASS;
    wire RESETB;

    reg ready = 0;
    reg[3:0] spinner1 = 4'b0001;
    reg[3:0] spinner2 = 4'b0100;
    wire[3:0] out;
    
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("PHASE_AND_DELAY"),
        .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
        .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
        .PLLOUT_SELECT("SHIFTREG_0deg"),
        .SHIFTREG_DIV_MODE(1'b0),
        .FDA_FEEDBACK(4'b0000),
        .FDA_RELATIVE(4'b0000),
        .DIVR(4'b0000),
        .DIVF(7'd6), // frecuency multiplier = 4+1 = 5
        .DIVQ(3'd3),
        .FILTER_RANGE(3'b001),
    ) pll (
        .REFERENCECLK   (hwclk),
        .PLLOUTGLOBAL   (clk_fast),
        .BYPASS         (BYPASS),
        .RESETB         (RESETB)
        //.LOCK (LOCK )
    );

    assign BYPASS = 0;
    assign RESETB = 1;

    scaler #(.N(3000000)) scaler1(
      .clk_in (hwclk),
      .clk_out (clk_scaler1)
    );

    scaler #(.N(3000000)) scaler2(
      .clk_in  (clk_fast),
      .clk_out (clk_scaler2)
    );

    // Spinner1 rotates clockwise
    always @(posedge clk_scaler1) begin
      spinner1 <= { spinner1[2:0], spinner1[3] };
    end

    // Spinner2 rotates counterclockwise
    always @(posedge clk_scaler2) begin
      spinner2 <= { spinner2[0], spinner2[3:1] };
    end

    // Alternate output between spinner1 and spinner2
    assign out = ({4{hwclk}} & spinner1) | ({4{~hwclk}} & spinner2);

    assign D1 = out[0];
    assign D2 = out[1];
    assign D3 = out[2];
    assign D4 = out[3];    
    assign D5 = 1;
endmodule // top
