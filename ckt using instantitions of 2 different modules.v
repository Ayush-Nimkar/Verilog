module top_module (input x, input y, output z);
    wire q, w, e, r, out, op;
    
    A inst1 (.x(x), .y(y), .z(q));
    A inst2 (.x(x), .y(y), .z(e));
    B inst3 (.x(x), .y(y), .z(w));
    B inst4 (.x(x), .y(y), .z(r));
    
    assign out = q | w;
    assign op = e & r;
    
    assign z = out ^ op;
    

endmodule


module A (input x, input y, output z);
    assign z = (x^y) & x;
endmodule
module B ( input x, input y, output z );
    assign z = ~(x^y);
endmodule

