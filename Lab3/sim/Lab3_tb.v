`timescale 1ns / 1ps
module Lab3_tb(PS2_clk, K_input, S4, S3, S2, S1, clk, reset);
output PS2_clk, K_input, S4, S3, S2, S1, clk, reset;
reg K_input;
reg PS2_clk;
reg S4;
reg S3;
reg S2;
reg S1;
reg reset;
reg clk=0;
wire [3:0]Enable_L, Enable_R;
wire [6:0]SevenSeg0, SevenSeg1;
wire [15:0]Led;
Top UUT(Enable_L, Enable_R, Led, SevenSeg0, SevenSeg1, PS2_clk, clk, S1, S2, S3, S4, K_input, reset);
initial begin
reset = 1;
K_input = 1;
PS2_clk = 0;
S1 = 0;
S2 = 0;
S3 = 0;
S4 = 0;
#10 reset = 0;
#13 reset = 1; 
//0 10000100 11 Coca
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 1;
#50;
//0 11011000 1 1 Sprite
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 1;
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 1;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 0;
#20 K_input = 1;
#20 K_input = 1;
#100 S4 = 1;
#50 S4 = 0;
#50 S3 = 1;
#50 S3 = 0;
#50 S3 = 1;
#50 S3 = 0;
#50 S3 = 1;
#50 S3 = 0;
#50 S2 = 1;
#50 S2 = 0;
#50 S2 = 1;
#50 S2 = 0;
#50 S1 = 1;
#50 S1 = 0;
#211 $finish;
end
always@(*)begin
    #10 clk <= ~clk;
    end
always@(*)begin
    #10 PS2_clk <= ~PS2_clk;
    end
endmodule