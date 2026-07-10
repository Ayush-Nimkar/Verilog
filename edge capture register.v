module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);
    reg [31:0] in_prev;

    always @ (posedge clk) begin
        in_prev <= in;
        if (reset) begin
            out<=32'b0;
        end
        else begin
            out <= out | (~in & in_prev); // ~in & in_prev logic for falling edge 1->0 and we OR out with this logic 
            //to operate the capture logic i.e. If out is already 1, the OR gate keeps it at 1. 
            //If an edge is detected, the OR gate forces it to 1. 
        end
    end
endmodule
