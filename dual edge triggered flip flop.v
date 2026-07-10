module top_module (
    input clk,
    input d,
    output q
);
    reg p_edge, n_edge;

    // 1. Capture data on the rising edge
    always @(posedge clk) begin
        p_edge <= d;
    end

    // 2. Capture data on the falling edge
    always @(negedge clk) begin
        n_edge <= d;
    end

    // 3. The Multiplexer
    // When clk is 1, output the posedge register.
    // When clk is 0, output the negedge register.
    assign q = clk ? p_edge : n_edge;
   
    

endmodule
