module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    genvar i;
    generate
        for (i=0; i<100; i=i+1)//this same thing is generated 100 times
            begin:adder_chain// adder_chain is just a label or blockname which is required for generate loops
                if (i==0)// the very first adder0 takes the main internal cin
                    full_adder fa_inst (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout[0]));
                else // adders 1 to 99 take carryout from previous adder
                    full_adder fa_inst (.a(a[i]), .b(b[i]), .cin(cout[i-1]), .sum(sum[i]), .cout(cout[i]));
            end
    endgenerate
    

endmodule

module full_adder(
    input a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule
    
