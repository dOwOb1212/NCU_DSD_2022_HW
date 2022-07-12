`timescale 1ns / 1ps
module HW1_tb;
reg X,Y,Z,SEL1,SEL2;
wire O;
FourToOneMux UUT(
    .sel1(SEL1),
    .sel2(SEL2),
    .X(X),
    .Y(Y),
    .Z(Z),
    .O(O)
);
initial begin
      SEL1 = 0;SEL2 = 0;X = 1;Y = 0;Z = 0;
#100; SEL1 = 0;SEL2 = 1;X = 0;Y = 1;Z = 0;
#100; SEL1 = 1;SEL2 = 0;X = 1;Y = 0;Z = 1;
#100; SEL1 = 0;SEL2 = 1;X = 0;Y = 0;Z = 1;
#100; SEL1 = 0;SEL2 = 1;X = 0;Y = 1;Z = 0;
#100; SEL1 = 1;SEL2 = 1;X = 1;Y = 1;Z = 0;
#100; SEL1 = 1;SEL2 = 0;X = 1;Y = 1;Z = 1;
#100; SEL1 = 1;SEL2 = 0;X = 0;Y = 1;Z = 1;
#100; SEL1 = 1;SEL2 = 0;X = 0;Y = 0;Z = 0;
#100; SEL1 = 1;SEL2 = 1;X = 1;Y = 1;Z = 0;     
end
endmodule
