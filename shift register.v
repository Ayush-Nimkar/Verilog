module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);
    // Create a 4-bit internal register to represent the four flip-flops
    reg [3:0] q;
    always @ (posedge clk) begin
        if(~resetn)
            q<=4'b0000;
        else
            q <= {in, q[3:1]};
    end
    assign out = q[0];

endmodule
