`timescale 1ns / 1ps
module Func2_module(O,X,Y,Z);
input X,Y,Z;
output O;
assign O = (X ^~ Y) &~ Z;
endmodule
