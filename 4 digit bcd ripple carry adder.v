module top_module ( 
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );
    
    // Create a 3-wire internal cable to route the carry signals 
    // between the 4 individual BCD adders.
    wire [2:0] internal_carry;

    // Digit 0: The Least Significant Digit (Bits 3 to 0)
    bcd_fadd digit0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),                  // Takes the main external carry-in
        .cout(internal_carry[0]),   // Drives the first internal wire
        .sum(sum[3:0])
    );

    // Digit 1: (Bits 7 to 4)
    bcd_fadd digit1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(internal_carry[0]),    // Takes the carry from Digit 0
        .cout(internal_carry[1]),   // Drives the second internal wire
        .sum(sum[7:4])
    );

    // Digit 2: (Bits 11 to 8)
    bcd_fadd digit2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(internal_carry[1]),    // Takes the carry from Digit 1
        .cout(internal_carry[2]),   // Drives the third internal wire
        .sum(sum[11:8])
    );

    // Digit 3: The Most Significant Digit (Bits 15 to 12)
    bcd_fadd digit3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(internal_carry[2]),    // Takes the carry from Digit 2
        .cout(cout),                // Drives the final external carry-out
        .sum(sum[15:12])
    );

endmodule

module bcd_fadd (
    input [3:0] a,
    input [3:0] b,
    input     cin,
    output   cout,
    output [3:0] sum );

    wire [4:0] raw_sum;
    wire [4:0] adjusted;
    wire       carry_out;

    assign raw_sum = {1'b0, a} + {1'b0, b} + {4'b0000, cin};
    assign adjusted = raw_sum + 5'd6;
    assign carry_out = raw_sum > 5'd9;
    assign sum = carry_out ? adjusted[3:0] : raw_sum[3:0];
    assign cout = carry_out;

endmodule
