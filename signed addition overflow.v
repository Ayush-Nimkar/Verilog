module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    assign s = a + b; //can do this way doesnt matter if signed or unsigned 
    // Overflow happens IF: (Positive + Positive = Negative) OR (Negative + Negative = Positive)
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule
