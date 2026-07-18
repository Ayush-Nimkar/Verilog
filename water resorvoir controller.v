module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    reg [2:0] state, next_state;
  
// 6 States:
//BELOW (Water is empty)
//Z1_RISE (Water is in Zone 1, and got there by rising)
//Z1_FALL (Water is in Zone 1, and got there by falling)
//Z2_RISE (Water is in Zone 2, and got there by rising)
//Z2_FALL (Water is in Zone 2, and got there by falling)
//ABOVE (Water is full)
    
    parameter BELOW   = 0;
    parameter Z1_RISE = 1;
    parameter Z1_FALL = 2;
    parameter Z2_RISE = 3;
    parameter Z2_FALL = 4;
    parameter ABOVE   = 5;
    
    always @ (posedge clk) begin
        if (reset) begin
            state <= BELOW;
        end
        else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        
        
        case (state)
         BELOW: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_RISE;
            else if (s == 3'b011) next_state = Z2_RISE;
            else                  next_state = ABOVE;
         end
        
         Z1_RISE: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_RISE;  // Maintain rising momentum
            else if (s == 3'b011) next_state = Z2_RISE;  // Moved up
            else                  next_state = ABOVE;
         end
        
         Z1_FALL: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_FALL;  // Maintain falling momentum
            else if (s == 3'b011) next_state = Z2_RISE;  // Momentum changed to rising!
            else                  next_state = ABOVE;
         end
        
         Z2_RISE: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_FALL;  // Momentum changed to falling!
            else if (s == 3'b011) next_state = Z2_RISE;  // Maintain rising momentum
            else                  next_state = ABOVE;
         end
        
         Z2_FALL: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_FALL;  // Moved down
            else if (s == 3'b011) next_state = Z2_FALL;  // Maintain falling momentum
            else                  next_state = ABOVE;
         end
        
         ABOVE: begin
            if      (s == 3'b000) next_state = BELOW;
            else if (s == 3'b001) next_state = Z1_FALL;
            else if (s == 3'b011) next_state = Z2_FALL;
            else                  next_state = ABOVE;
         end
        
         default: next_state = BELOW;        
            endcase
    end

assign fr3 = (state == BELOW);
assign fr2 = (state == BELOW) || (state == Z1_RISE) || (state == Z1_FALL);
assign fr1 = (state == BELOW) || (state == Z1_RISE) || (state == Z1_FALL) || (state == Z2_RISE) || (state == Z2_FALL);

// Supplemental valve turns on when completely empty, OR when falling through the middle zones
assign dfr = (state == BELOW) || (state == Z1_FALL) || (state == Z2_FALL);

endmodule
