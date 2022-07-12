`timescale 1ns / 1ps
module OAI_module(O,X,Y,Z);
input X,Y,Z;
output O;
assign O = (X|Y)&~Z;
endmodule
