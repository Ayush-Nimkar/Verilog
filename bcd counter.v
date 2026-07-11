module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output reg [15:0] q);
    
    // Tens digit (ena[1]) ticks when Ones digit is at 9
    assign ena[1] = (q[3:0] == 4'd9);
    
    // Hundreds digit (ena[2]) ticks when Ones AND Tens are at 9
    assign ena[2] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
    
    // Thousands digit (ena[3]) ticks when Ones, Tens, AND Hundreds are at 9
    assign ena[3] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            
            // INDEPENDENT IF STATEMENTS! 
            // This allows all 4 digits to update simultaneously if needed.
            
            // --- Ones Digit [3:0] (Always counting) ---
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
            end else begin
                q[3:0] <= q[3:0] + 1'b1;
            end

            // --- Tens Digit [7:4] ---
            if (ena[1]) begin
                if (q[7:4] == 4'd9)
                    q[7:4] <= 4'd0;
                else                
                    q[7:4] <= q[7:4] + 1'b1;
            end

            // --- Hundreds Digit [11:8] ---
            if (ena[2]) begin
                if (q[11:8] == 4'd9) 
                    q[11:8] <= 4'd0;
                else                 
                    q[11:8] <= q[11:8] + 1'b1;
            end

            // --- Thousands Digit [15:12] ---
            if (ena[3]) begin
                if (q[15:12] == 4'd9)
                    q[15:12] <= 4'd0;
                else                  
                    q[15:12] <= q[15:12] + 1'b1;
            end
            
        end
    end
endmodule



