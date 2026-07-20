module top_module(
input clk,
input areset,    // Freshly brainwashed Lemmings walk left.
input bump_left,
input bump_right,
input ground,
input dig,
output walk_left,
output walk_right,
output aaah,
output digging );

// We need 3 bits for 7 states
reg [2:0] state, next_state;

// A 5-bit counter can count up to 31 (plenty for our 20-cycle limit)
reg [4:0] fall_count;

// Added the SPLAT state (State 6)
parameter LEFT=0, RIGHT=1, DIG_L=2, DIG_R=3, FALL_L=4, FALL_R=5, SPLAT=6;

// --------------------------------------------------------
// SEQUENTIAL BLOCK: State Memory & The Fall Counter
// --------------------------------------------------------
always @ (posedge clk, posedge areset) begin
    if(areset) begin
        state <= LEFT;
        fall_count <= 0;
    end
    else begin
        state <= next_state;
        
        // If we are currently falling, increment the counter
        if (state == FALL_L || state == FALL_R) begin
            // Cap the counter at 31 so it doesn't overflow and reset to 0
            if (fall_count < 31) begin
                fall_count <= fall_count + 1;
            end
        end 
        // If we are doing anything else, reset the fall counter to 0
        else begin
            fall_count <= 0;
        end
    end
end

// --------------------------------------------------------
// COMBINATIONAL BLOCK: State Transitions
// --------------------------------------------------------
always @ (*) begin
    case(state)
        
        LEFT: begin
            if (!ground) next_state = FALL_L;
            else if (dig) next_state = DIG_L;
            else if (bump_left) next_state = RIGHT;
            else next_state = LEFT;
        end
        
        RIGHT: begin
            if (!ground) next_state = FALL_R;
            else if (dig) next_state = DIG_R;
            else if (bump_right) next_state = LEFT;
            else next_state = RIGHT;
        end
        
        DIG_L: begin
            if (!ground) next_state = FALL_L;
            else next_state = DIG_L;
        end
        
        DIG_R: begin
            if (!ground) next_state = FALL_R;
            else next_state = DIG_R;
        end
        
        FALL_L: begin
            // When the ground appears, check our fall timer!
            if(ground) begin
                if (fall_count >= 20) next_state = SPLAT;
                else next_state = LEFT;
            end
            else next_state = FALL_L;
        end
        
        FALL_R: begin
            // When the ground appears, check our fall timer!
            if(ground) begin
                if (fall_count >= 20) next_state = SPLAT;
                else next_state = RIGHT;
            end
            else next_state = FALL_R;
        end
        
        SPLAT: begin
            // A terminal state. Once here, you never leave (until areset).
            next_state = SPLAT;
        end
        
        default: next_state = LEFT;
        
    endcase
end

// --------------------------------------------------------
// OUTPUT LOGIC
// --------------------------------------------------------
// Notice we don't need to write anything for SPLAT! 
// Because SPLAT doesn't match LEFT, RIGHT, FALL, or DIG, all 
// of these equations will safely evaluate to 0.

assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);
assign aaah = ((state == FALL_L) || (state == FALL_R));
assign digging = ((state == DIG_L) || (state == DIG_R));


endmodule
