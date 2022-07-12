`timescale 1ns / 1ps
module HW2_tb;
reg CLK, reset, Disable;
wire [3:0]O;
Decremeter uut(O,Disable,CLK,reset);
always
begin
#5; CLK = ~CLK; 
end
initial
begin
$monitor("Output = %0h",O);
#100
CLK <= 0; reset <= 1; Disable <= 0;
#10; reset <= 0; Disable <= 0;
#10 reset <= 1; Disable <= 0;
#180; reset <= 1; Disable <= 1;
#20;
$finish;
end
endmodule
