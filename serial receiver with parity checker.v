module top_module(
input clk,
input in,
input reset,    // Synchronous reset
output [7:0] out_byte,
output done
);

// 1. Define 14 States
parameter IDLE = 0, B1 = 1, B2 = 2, B3 = 3, B4 = 4, B5 = 5, B6 = 6, B7 = 7, B8 = 8, 
          PARITY_ST = 9, STOP = 10, DONE = 11, WAIT = 12, ERROR = 13;
          
// 4 bits needed for 14 states
reg [3:0] state, next_state;

// 2. Parity Module Integration
wire parity_reset;
wire p;

// Reset the parity module whenever we are outside of the active reception window.
// This perfectly readies it for the very next start bit.
assign parity_reset = (state == IDLE) || (state == DONE) || (state == WAIT) || (state == ERROR) || reset;

// Instantiate the provided parity module
parity u_parity (
    .clk(clk),
    .reset(parity_reset),
    .in(in),
    .odd(p) // FIXED: Port name changed from .p to .odd
);

// 3. COMBINATIONAL: Next-State Routing Logic
always @(*) begin
    case(state)
        IDLE:      next_state = (in == 0) ? B1 : IDLE;
        B1:        next_state = B2;
        B2:        next_state = B3;
        B3:        next_state = B4;
        B4:        next_state = B5;
        B5:        next_state = B6;
        B6:        next_state = B7;
        B7:        next_state = B8;
        B8:        next_state = PARITY_ST;
        PARITY_ST: next_state = STOP;
        STOP: begin
            // Check Framing (Stop bit) AND Parity
            if (in == 0)      next_state = ERROR; // Framing error (Missing stop bit)
            else if (p == 1)  next_state = DONE;  // Valid stop bit AND Valid Odd Parity
            else              next_state = WAIT;  // Valid stop bit BUT Failed Parity
        end
        DONE:      next_state = (in == 0) ? B1 : IDLE;
        WAIT:      next_state = (in == 0) ? B1 : IDLE; // Just like DONE, but 'done' is 0
        ERROR:     next_state = (in == 1) ? IDLE : ERROR;
        default:   next_state = IDLE;
    endcase
end

// 4. SEQUENTIAL: State Memory & Datapath
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
        
        // Unconditionally save the payload during the B1-B8 states
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
    end
end

// 5. OUTPUT LOGIC: Moore Machine
assign done = (state == DONE);


endmodule