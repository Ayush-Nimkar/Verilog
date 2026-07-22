module top_module(
input clk,
input in,
input reset,    // Synchronous reset
output done
);
// Define 12 States
parameter IDLE=0, B1=1, B2=2, B3=3, B4=4, B5=5, B6=6, B7=7, B8=8, STOP=9, DONE=10, ERROR=11;

// 4 bits needed for 12 states
reg [3:0] state, next_state;

// 1. COMBINATIONAL: Next-State Routing Logic
always @(*) begin
    case(state)
        IDLE: next_state = (in == 0) ? B1 : IDLE; // Wait for start bit (0)
        
        // Unconditionally count 8 clock cycles for the data payload
        B1: next_state = B2;
        B2: next_state = B3;
        B3: next_state = B4;
        B4: next_state = B5;
        B5: next_state = B6;
        B6: next_state = B7;
        B7: next_state = B8;
        B8: next_state = STOP;
        
        // Check the 10th bit to ensure it is a valid stop bit (1)
        STOP: begin
            if (in == 1) next_state = DONE;  // Valid packet
            else         next_state = ERROR; // Framing error! Missing stop bit.
        end
        
        DONE: begin
            // A new start bit might arrive immediately! 
            if (in == 0) next_state = B1;
            else         next_state = IDLE;
        end
        
        ERROR: begin
            // Wait until we see a 1 (line returns to idle state) to recover
            if (in == 1) next_state = IDLE;
            else         next_state = ERROR;
        end
        
        default: next_state = IDLE;
    endcase
end

// 2. SEQUENTIAL: State Memory
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// 3. OUTPUT LOGIC: Moore Machine
assign done = (state == DONE);


endmodule