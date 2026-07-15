module top_module(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= B;
        end
        else begin
            state <= next_state;
        end
    end

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

    assign out = (state == B);

endmodule
