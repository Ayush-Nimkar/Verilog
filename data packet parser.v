module top_module(
input clk,
input [7:0] in,
input reset,    // Synchronous reset
output [23:0] out_bytes,
output done);

// Defining states
parameter B1 = 0, B2 = 1, B3 = 2, DONE = 3;
reg [1:0] state, next_state;

// Combinational Next-State Logic (Same as previous problem)
always @(*) begin
    case (state)
        B1: begin
            if (in[3]) next_state = B2;
            else       next_state = B1;
        end
        B2: begin
            next_state = B3;
        end
        B3: begin
            next_state = DONE;
        end
        DONE: begin
            if (in[3]) next_state = B2;
            else       next_state = B1;
        end
        default: next_state = B1;
    endcase
end

// Sequential State Memory & Datapath Shift Register
always @(posedge clk) begin
    if (reset) begin
        state <= B1;
    end else begin
        state <= next_state;
    end
    
    // We can unconditionally shift the incoming byte every clock cycle.
    // When 'done' is eventually asserted, the last 3 bytes will be perfectly 
    // sitting in this 24-bit register.
    out_bytes <= {out_bytes[15:0], in};
end

// Output Logic
assign done = (state == DONE);


endmodule