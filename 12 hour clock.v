module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss); 
    
    
    //Minutes Enable: Only ticks when ena is high AND seconds are at 59.
    //Hours Enable: Only ticks when ena is high AND seconds are at 59 AND minutes are at 59.
    
    wire ena_mm = ena && (ss == 8'h59);
    wire ena_hh = ena_mm && (mm == 8'h59);
    
   always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset forces 12:00:00 AM
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else if (ena) begin
            
            // --- Seconds Logic (00 to 59) ---
            if (ss == 8'h59) begin
                ss <= 8'h00;
            end else if (ss[3:0] == 4'h9) begin
                ss[3:0] <= 4'h0;
                ss[7:4] <= ss[7:4] + 1'b1;
            end else begin
                ss[3:0] <= ss[3:0] + 1'b1;
            end

            // --- Minutes Logic (00 to 59) ---
            if (ena_mm) begin
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                end else if (mm[3:0] == 4'h9) begin
                    mm[3:0] <= 4'h0;
                    mm[7:4] <= mm[7:4] + 1'b1;
                end else begin
                    mm[3:0] <= mm[3:0] + 1'b1;
                end
            end

            // --- Hours Logic (01 to 12) ---
            if (ena_hh) begin
                if (hh == 8'h12) begin
                    hh <= 8'h01; // 12 rolls over to 1
                end else if (hh[3:0] == 4'h9) begin
                    hh[3:0] <= 4'h0;
                    hh[7:4] <= hh[7:4] + 1'b1; // e.g., 09 to 10
                end else begin
                    hh[3:0] <= hh[3:0] + 1'b1;
                end
            end

            // --- AM/PM Toggle ---
            // Toggles exactly when transitioning from 11:59:59 to 12:00:00
            if (ena_hh && (hh == 8'h11)) begin
                pm <= ~pm;
            end
            
        end
    end 
endmodule
