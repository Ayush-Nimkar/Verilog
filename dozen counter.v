module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);
    // 1. Generate the control signals
    assign c_enable = enable;
    assign c_load   = reset | (enable & (Q == 4'd12)); //cload is basically when a high voltage load is applied it stops the
    //operation and goes to 1. it overrides enable obviously. now this logic means - activate cload when it is reset by the
    //user or when enable is ON and output is 12.
    assign c_d      = 4'd1;//when load is ON and we have to override it goes to 1 hence this specification

    // 2. Instantiate the pre-built count4 module and wire it up
    count4 u0 (
        .clk(clk),
        .enable(c_enable),
        .load(c_load),
        .d(c_d),
        .Q(Q)
    );
    

endmodule

module count4(
    input clk,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] Q
);
    always @(posedge clk) begin
        if (load)
            Q <= d;
        else if (enable)
            Q <= Q + 1;
    end
endmodule
