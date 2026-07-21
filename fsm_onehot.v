module top_module(
input in,
input [9:0] state,
output [9:0] next_state,
output out1,
output out2);

// --------------------------------------------------------
// COMBINATIONAL: Next-State Logic (Derived by inspection)
// For each state bit, we look at which states have arrows 
// pointing TO it, and what the 'in' value is on that arrow.
// --------------------------------------------------------

// State 0 is the destination for almost every state when in=0 (except S5 and S6)
assign next_state[0] = ~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]);

// State 1 is reached from S0, S8, and S9 when in=1
assign next_state[1] = in & (state[0] | state[8] | state[9]);

// States 2 through 6 are a simple chain when in=1
assign next_state[2] = in & state[1];
assign next_state[3] = in & state[2];
assign next_state[4] = in & state[3];
assign next_state[5] = in & state[4];
assign next_state[6] = in & state[5];

// State 7 is reached from S6 (in=1) and loops on itself (in=1)
assign next_state[7] = in & (state[6] | state[7]);

// State 8 is reached from S5 when in=0
assign next_state[8] = ~in & state[5];

// State 9 is reached from S6 when in=0
assign next_state[9] = ~in & state[6];

// --------------------------------------------------------
// COMBINATIONAL: Output Logic 
// Based on the state diagram bubbles, out1 is 1 in S8 and S9.
// out2 is 1 in S7 and S9.
// --------------------------------------------------------

assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];


endmodule