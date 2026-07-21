module top_module(
input clk,
input [7:0] in,
input reset,    // Synchronous reset
output done); //

// STREAMING_CHUNK: Defining states and state variables
parameter B1 = 0, B2 = 1, B3 = 2, DONE = 3;
reg [1:0] state, next_state;

// STREAMING_CHUNK: Combinational Next-State Logic
always @(*) begin
    case (state)
        // Search for a byte where in[3] == 1
        B1: begin
            if (in[3]) next_state = B2;
            else       next_state = B1;
        end
        
        // 2nd byte of the packet (no checks needed)
        B2: begin
            next_state = B3;
        end
        
        // 3rd byte of the packet (no checks needed)
        B3: begin
            next_state = DONE;
        end
        
        // Packet complete. The next incoming byte is evaluated immediately.
        DONE: begin
            if (in[3]) next_state = B2;
            else       next_state = B1;
        end
        
        default: next_state = B1;
    endcase
end

// STREAMING_CHUNK: Sequential State Memory with Synchronous Reset
always @(posedge clk) begin
    if (reset) begin
        state <= B1;
    end else begin
        state <= next_state;
    end
end

// STREAMING_CHUNK: Output Logic
// done is high only in the DONE state
assign done = (state == DONE);


endmodule