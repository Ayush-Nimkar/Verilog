module top_module (
    input [3:0] x,
    input [3:0] y,
    input cin,
    output [3:0] cout,
    output [4:0] sum);
    fa inst1 (.x(x[0]), .y(y[0]), .cin(cin), .sum(sum[0]), .cout(cout[0]));
    fa inst2 (.x(x[1]), .y(y[1]), .cin(cout[0]), .sum(sum[1]), .cout(cout[1]));
    fa inst3 (.x(x[2]), .y(y[2]), .cin(cout[1]), .sum(sum[2]), .cout(cout[2]));
    fa inst4 (.x(x[3]), .y(y[3]), .cin(cout[2]), .sum(sum[3]), .cout(cout[3]));
    assign sum[4] = cout[3];

endmodule
module fa(
    input x,y,
    input cin,
    output cout,
    output sum);
    assign sum = x^y^cin;
    assign cout = (x & y) | (cin & (x ^ y));
endmodule
