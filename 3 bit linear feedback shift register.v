module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output reg [2:0]LEDR);  // Q
    
    always @(posedge KEY[0]) begin
        
        // MUX for Q[0] (LEDR[0])
        LEDR[0] <= KEY[1] ? SW[0] : LEDR[2];
        
        // MUX for Q[1] (LEDR[1])
        LEDR[1] <= KEY[1] ? SW[1] : LEDR[0];
        
        // MUX for Q[2] (LEDR[2]) with the XOR gate on the feedback path
        LEDR[2] <= KEY[1] ? SW[2] : (LEDR[1] ^ LEDR[2]);
        
    end


endmodule
