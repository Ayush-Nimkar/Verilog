module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    wire [99:0] internal_carry;
    genvar i;
    generate
        for (i=0; i<100; i=i+1)
            begin : bcdadder
                if (i==0) // The first adder is hardwired to the external 'cin'
                    bcd_fadd inst1 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(internal_carry[0]));
                else // Adders 1-99 use math to slice the 400-bit vectors into 4-bit chunks
                    bcd_fadd inst1 (.a(a[i*4+3 : i*4]), .b(b[i*4+3 : i*4]), .cin(internal_carry[i-1]), .sum(sum[i*4+3 : i*4]), .cout(internal_carry[i]));
            //You could replace the math in the code above with a[i*4 +: 4]. 
            //This tells the compiler: "Start at bit i*4, and slice exactly 4 wires going upwards."
            end
    endgenerate
    // The very last carry wire in the chain is routed to the physical output pin
    assign cout = internal_carry[99];

endmodule
