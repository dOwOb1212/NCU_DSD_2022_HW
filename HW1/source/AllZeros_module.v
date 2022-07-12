`timescale 1ns / 1ps
module AllZeros_module(O,X,Y,Z);
input X,Y,Z;
output O;
assign O = ~X & ~Y & ~Z;
endmodule
