module top_module(
input clk,
input in,
input reset,    // Synchronous reset
output [7:0] out_byte, // NEW: 8-bit output payload
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
        B1: next_state = B2;
        B2: next_state = B3;
        B3: next_state = B4;
        B4: next_state = B5;
        B5: next_state = B6;
        B6: next_state = B7;
        B7: next_state = B8;
        B8: next_state = STOP;
        STOP: begin
            if (in == 1) next_state = DONE;  
            else         next_state = ERROR; 
        end
        DONE: begin
            if (in == 0) next_state = B1;
            else         next_state = IDLE;
        end
        ERROR: begin
            if (in == 1) next_state = IDLE;
            else         next_state = ERROR;
        end
        default: next_state = IDLE;
    endcase
end

// 2. SEQUENTIAL: State Memory & Datapath
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
        
        // --- THE NEW DATAPATH LOGIC ---
        // We sample the 'in' wire while we are in the data states.
        // LSB is sent first, so B1 goes to index 0, B8 goes to index 7.
        case (state)
            B1: out_byte[0] <= in;
            B2: out_byte[1] <= in;
            B3: out_byte[2] <= in;
            B4: out_byte[3] <= in;
            B5: out_byte[4] <= in;
            B6: out_byte[5] <= in;
            B7: out_byte[6] <= in;
            B8: out_byte[7] <= in;
        endcase
        // ------------------------------
    end
end

// 3. OUTPUT LOGIC: Moore Machine
assign done = (state == DONE);


endmodule