module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    wire r;
    assign r = ~(in1 ^ in2);
    assign out = r ^ in3;

endmodule
