module top_module(
    input clk,
    input in,
    input reset,
    output out); 
    
    parameter A=0, B=1, C=2, D=3;
    reg [1:0] state, next_state;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            state <= next_state;
        end
    end
    
    always @ (*) begin
        case (state) 
            A:begin 
                if(in==0) next_state = A;
                else next_state = B;
            end
            B:begin 
                if(in==0) next_state = C;
                else next_state = B;
            end
            C:begin 
                if(in==0) next_state = A;
                else next_state = D;
            end
            D:begin 
                if(in==0) next_state = C;
                else next_state = B;
            end
        endcase
    end
    
    assign out = (state == D);
            
    
endmodule
