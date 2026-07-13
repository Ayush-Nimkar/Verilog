module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q ); 
    always @ (posedge clk) begin
        if(load)
            q<=data;
        else
            // Calculate the next generation using vector bitwise XOR.
            // Left shift (padding LSB with 0) XOR Right shift (padding MSB with 0)
            q <= {q[510:0], 1'b0} ^ {1'b0, q[511:1]};
                //this is left and this one is right neighbour.
    end

endmodule
