module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );
    wire x,y,z,s;
    assign x = p2a & p2b;
    assign y = p1a & p1c & p1b;
    assign z = p2c & p2d;
    assign s = p1f & p1e & p1d;
    assign p2y = x | z;
    assign p1y = y | s;


endmodule
