module top_module (
    input [7:0] a, b, c, d,
    output reg [7:0] min);
   
    always @ (*) begin
        min = (a>b) ? b:a;
        min = (min>c) ? c:min;
        min = (min>d) ? d:min;
    end


endmodule
