module top_module (
    input clk,
    input x,
    output z,
    input reset
); 
    reg q0=1'b0;
    reg q1=1'b0;
    reg q2=1'b0;
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            q0 <= 1'b0;
            q1 <= 1'b0;
            q2 <= 1'b0;
        end else begin
            q0 <= x ^ q0;
            q1 <= x & ~q1;
            q2 <= x | ~q2;
        end
    end
    assign z = ~(q0 | q1 | q2);

endmodule
