module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_prev;
    always @ (posedge clk) begin
        in_prev<=in;
        anyedge = in ^ in_prev; // Math: 1 & ~0 -> 1 & 1 -> 1 (Edge Detected!) for any other 
                               //input combinations output will be 0 hence it either be falling edge or no change.
       
    end
endmodule
