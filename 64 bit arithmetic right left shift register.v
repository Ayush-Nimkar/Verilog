module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
    always @ (posedge clk) begin
        if(load) begin
                q<=data; // 1. Highest Priority: Load overrides everything
        end
        else if(ena) begin
                if (amount == 2'b00) begin
                    q<= {q[62:0],1'b0}; // Shift Left by 1 (63 bits + 1 bit = 64)
                end
                else if (amount == 2'b01) begin
                    q<= {q[55:0],8'b0}; // Shift Left by 8 (56 bits + 8 bits = 64)
                end
                else if (amount == 2'b10) begin
                    q<= {q[63],q[63:1]}; // Arithmetic Shift Right by 1 (1 sign bit + 63 bits = 64)
                end
                else if (amount == 2'b11) begin
                    q<= {{8{q[63]}}, q[63:8]}; // Arithmetic Shift Right by 8 (8 sign bits + 56 bits = 64)
                end
            end
    end
            

endmodule
