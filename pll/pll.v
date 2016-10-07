module top(input clk, output D1, output D2, output D3, output D4, output D5);
   
    wire clk;
    wire clk_fast;
    wire clk_scaler1;
    wire clk_scaler2;
    wire BYPASS;
    wire RESETB;

    reg[3:0] spinner1;
    reg[3:0] spinner2;
    reg[3:0] out;
    reg ready = 0;

    SB_PLL40_CORE #(
        .FEEDBACK_PATH("PHASE_AND_DELAY"),
        .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
        .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
        .PLLOUT_SELECT("SHIFTREG_0deg"),
        .SHIFTREG_DIV_MODE(1'b0),
        .FDA_FEEDBACK(4'b0000),
        .FDA_RELATIVE(4'b0000),
        .DIVR(4'b0000),
        .DIVF(7'd7), // frecuency multiplier = 6+1 = 7
        .DIVQ(3'd3),
        .FILTER_RANGE(3'b001),
    ) uut (
        .REFERENCECLK   (clk),
        .PLLOUTGLOBAL   (clk_fast), // output frequency = 7 * input frequency
        .BYPASS         (BYPASS),
        .RESETB         (RESETB)
        //.LOCK (LOCK )
    );

    //assign LED = clk_new;
    assign BYPASS = 0;
    assign RESETB = 1;

    scaler scaler1(
      .clk_in (clk),
      .clk_out (clk_scaler1)
    );

    scaler scaler2(
      .clk_in  (clk_fast),
      .clk_out (clk_scaler2)
    );

    always @(posedge clk_scaler1) begin
      spinner1 <= { spinner1[2:0], spinner1[3] };
    end

    always @(posedge clk_scaler2) begin
      spinner2 <= { spinner2[0], spinner2[3:1] };
    end
    
    always @(posedge clk) begin
      if (ready)
        begin
          out <= spinner1;
        end
      else
        begin
          spinner1 <= 4'b0101;
          spinner2 <= 4'b0101;
          ready <= 1;
        end
    end

    always @(negedge clk) begin
      if (ready) begin
        out <= spinner2;
      end
    end

    assign D1 = out[0];
    assign D2 = out[1];
    assign D3 = out[2];
    assign D4 = out[3];
    assign D5 = 1;
endmodule // top
