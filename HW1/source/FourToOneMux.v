`timescale 1ns / 1ps
module FourToOneMux(O, sel1, sel2, X, Y, Z);
input sel1, sel2, X, Y, Z;
output O;
wire sel1_n, sel2_n, T1, T2, T3, T4;
wire out00, out01, out10, out11;
not (sel1_n,sel1), (sel2_n,sel2);
EvenOnes_module mod00 (.X(X),.Y(Y),.Z(Z),.O(out00));
OAI_module mod01 (.X(X),.Y(Y),.Z(Z),.O(out01));
AllZeros_module mod10 (.X(X),.Y(Y),.Z(Z),.O(out10));
Func2_module mod11 (.X(X),.Y(Y),.Z(Z),.O(out11));
and AG00(T1,sel1_n,sel2_n,out00),
AG01(T2,sel1_n,sel2,out01),
AG10(T3,sel1,sel2_n,out10),
AG11(T4,sel1,sel2,out11);
or OG(O,T1,T2,T3,T4);
endmodule