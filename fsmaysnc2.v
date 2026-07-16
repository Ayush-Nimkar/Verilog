module top_module(
    input clk,
    input areset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case(state)
            ON:begin 
                if(k==1) next_state = OFF;
                else next_state = ON;
            end
            
            OFF:begin
                if(j==1) next_state = ON;
                else next_state = OFF;
            end
            default: next_state = OFF;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset) begin
            state <= OFF;
        end
        else begin
            state <= next_state;
        end
    end

    assign out = (state == ON);

endmodule
