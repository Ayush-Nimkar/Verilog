module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire sel;
    reg [31:0] in;
    reg [15:0] out;
    wire [15:0] uppersumcin0;
    wire [15:0] uppersumcin1;
    
    add16 inst1 ( .a(a[15:0]), .b(b[15:0]), .sum(sum[15:0]), .cin(0), .cout(sel)); //add16 module pre given.
    add16 inst2 ( .a(a[31:16]), .b(b[31:16]), .sum(uppersumcin0), .cin(1'b0), .cout());
    add16 inst3 ( .a(a[31:16]), .b(b[31:16]), .sum(uppersumcin1), .cin(1'b1), .cout());
    
    always @(*) begin
        case(sel)
            1'b0: out = uppersumcin0;
            1'b1: out = uppersumcin1;
          
            default: out = 16'b0;
        endcase
    end
    assign sum = {out, sum[15:0]};
    
    
endmodule
