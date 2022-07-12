`timescale 1ns / 1ps
module sim();
reg Speed, Mode;
reg [3:0]Pattern;
reg [1:0]Times;
reg reset;
reg clk = 1'b0;
wire [15:0]LedOut;

Top uut(.LedOut(LedOut[15:0]),.Pattern(Pattern),.Times(Times),.Speed(Speed),.Mode(Mode),.clk(clk),.reset(reset));

always
begin
    #1 clk=~clk;
end
initial 
begin
    #1; Speed = 0;Mode = 0;Pattern = 4'b0001;Times = 2'b10;
    #10; reset = 1;
    #4; reset = 0;
    #3; reset = 1;
    #50; Speed = 0;Mode = 1;Pattern = 4'b0001;Times = 2'b11;
    #3; reset = 0;
    #3; reset = 1;
    #200;
    $finish;
end

endmodule
