module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q ); 
    // We need a temporary variable to hold the next generation before the clock ticks
    reg [255:0] next_q;
    
    integer i, j;
    reg [3:0] neighbors;
    reg [3:0] r_up, r_dn, c_l, c_r;
    
    always @(*) begin
        // Loop through every row (i) and column (j)
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                
                // Calculate wrapped coordinates
                r_up = (i == 0)  ? 4'd15 : i[3:0] - 4'd1;
                r_dn = (i == 15) ? 4'd0  : i[3:0] + 4'd1;
                c_l  = (j == 0)  ? 4'd15 : j[3:0] - 4'd1;
                c_r  = (j == 15) ? 4'd0  : j[3:0] + 4'd1;
                
                // Sum the 8 neighbors using our wrapped coordinates
                // We multiply the row by 16 and add the column to get the 1D index
                neighbors = q[{r_up, 4'b0} + c_l] + q[{r_up, 4'b0} + j] + q[{r_up, 4'b0} + c_r] +
                            q[{i[3:0], 4'b0} + c_l] + q[{i[3:0], 4'b0} + c_r] + q[{r_dn, 4'b0} + c_l] + q[{r_dn, 4'b0} + j] + q[{r_dn, 4'b0} + c_r];
                        
                // Apply Conway's Rules
                if (neighbors == 3) begin
                    next_q[i*16 + j] = 1'b1;        // Birth
                end else if (neighbors == 2) begin
                    next_q[i*16 + j] = q[i*16 + j]; // Survival (state remains unchanged)
                end else begin
                    next_q[i*16 + j] = 1'b0;        // Death (loneliness or overpopulation)
                end
                
            end
        end
    end

    // Sequential flip-flop update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule
