`timescale 1ns / 1ps

module HW3_tb();
reg clk;
reg reset;
reg Goleft;
reg Goright;
reg start;
wire [6:0] Score;
wire Touch, Drop, Key, OnElevation;
wire [3:0] NinjaX, NinjaY, Elevator1Y, Elevator2Y, Elevator3Y, Shuriken1Y, Shuriken2Y;
wire [3:0] Shuriken3Y;
wire [1:0] Chance;
Top U0 (clk, reset, start, OnElevation, Score, Touch, Drop, Key, NinjaX, NinjaY, Elevator1Y, Elevator2Y, Elevator3Y, Shuriken1Y, Shuriken2Y, Shuriken3Y, Goleft, Goright, Chance);
always@(*)begin
    #50 clk<=~clk;
    end
initial begin
clk<=1;
reset<=1;
Goleft<=0;
Goright<=0;
start<=0;
reset<= #50 0;
start<= #150 1;
start<= #250 0;
Goleft<= #250 1;
Goleft<= #550 0;
Goleft<= #850  1;
Goleft<= #1150  0;
Goright<= #1150 1;
Goright<= #1250 0;
Goright<= #1350 1;
Goright<= #1450 0;
Goright<= #1550 1;
Goright<= #1750 0;
Goright<= #2250 1;
Goright<= #2550 0;
end
endmodule

