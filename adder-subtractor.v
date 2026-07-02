module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] out;
    wire x; //cant declare cout() or cout(0) and then declare cin(cout) in the next instantiation 
            //hence just gave a random wire x to it initially no use of x though.
    
    add16 inst1 ( .a(a[15:0]), .b(out[15:0]), .cin(sub), .cout(x), .sum(sum[15:0]));
    add16 inst2 ( .a(a[31:16]), .b(out[31:16]), .cin(x), .cout(), .sum(sum[31:16]));
    assign out = b ^ {32{sub}};
    

endmodule
