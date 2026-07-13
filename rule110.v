module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    always @ (posedge clk) begin
        if(load)
            q<=data;
        else // use the truth table to get logic function and apply it here the logic is (C XOR R) OR (C AND NOT L)
            q <= (q ^ {q[510:0], 1'b0}) | (q & ~{1'b0, q[511:1]});
               // q xored with left and this is q anded with not of right neighbour.
    end

endmodule
