module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); 
    wire [3:0] q0, q1, q2;
    
// --- STAGE 0: The Fast Counter ---
    // Runs constantly on every clock tick
    assign c_enable[0] = 1'b1;
    bcdcount counter0 (.clk(clk), .reset(reset), .enable(c_enable[0]), .Q(q0));
    
    // --- STAGE 1: The Medium Counter ---
    // Runs only when Stage 0 is about to roll over(i.e. reach 9 and go to 0)
    assign c_enable[1] = (q0 == 4'd9);
    bcdcount counter1 (.clk(clk), .reset(reset), .enable(c_enable[1]), .Q(q1));
    
    // --- STAGE 2: The Slow Counter ---
    // Runs only when Stage 0 AND Stage 1 are about to roll over
    assign c_enable[2] = (q0 == 4'd9) && (q1 == 4'd9);
    bcdcount counter2 (.clk(clk), .reset(reset), .enable(c_enable[2]), .Q(q2));
    
    // --- The Final 1 Hz Pulse ---
    // Pulses high for exactly 1 cycle when all counters hit 9 (cycle 999)
    assign OneHertz = (q0 == 4'd9) && (q1 == 4'd9) && (q2 == 4'd9);

endmodule

module bcdcount (
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 4'd0;
        else if (enable) begin
            if (Q == 4'd9)
                Q <= 4'd0;
            else
                Q <= Q + 4'd1;
        end
    end
endmodule
