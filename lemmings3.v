 reg [2:0] state, next_state;
    
    parameter LEFT=0, RIGHT=1, DIG_R=2, DIG_L=3, FALL_R=4, FALL_L=5;
    
    always @ (posedge clk, posedge areset) begin
        if(areset) begin
            state <= LEFT;
        end
        else begin
            state <= next_state;
        end
    end
    
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
            
            FALL_R: begin
                if(ground) next_state = RIGHT;
                else next_state = FALL_R;
            end
            
            FALL_L: begin
                if(ground) next_state = LEFT;
                else next_state = FALL_L;
            end
            
        endcase
        
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = ((state == FALL_L) || (state == FALL_R));
    assign digging = ((state == DIG_L) || (state == DIG_R));

endmodule
