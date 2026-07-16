// Note the Verilog-1995 module declaration syntax here:
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;     // Removed 'reg out;' so it defaults to a wire
    
    parameter A=0, B=1; 
    reg state, next_state;

    // 1. STATE MEMORY (Sequential)
    // Notice how 'reset' is NOT in the sensitivity list. 
    // This makes it a synchronous reset, evaluated only on the clock edge.
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end
        else begin
            state <= next_state;  // Update the current state!
        end
    end

    // 2. NEXT-STATE LOGIC (Combinational)
    // This block ONLY calculates where to go next. It has no memory.
    always @(*) begin
        case (state)
            A: begin
                if (in == 1'b0) next_state = B;
                else            next_state = A;
            end
            B: begin
                if (in == 1'b0) next_state = A;
                else            next_state = B;
            end
            default: next_state = B; 
        endcase
    end

    // 3. OUTPUT LOGIC (Combinational)
    assign out = (state == B);

endmodule