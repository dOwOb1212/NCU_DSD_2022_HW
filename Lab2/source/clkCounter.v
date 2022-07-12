module clkCounter(SevenSegclkOut, LedclkOut, Speed, clk);
output reg LedclkOut;
output reg SevenSegclkOut;
input Speed;
input clk;
reg [19:0]clkCounter = 20'b0;
reg [27:0]clkCounterOn = 28'b0;
reg [25:0]clkCounterOff = 26'b0;
always @(posedge clk)
begin
    if(Speed == 1'b1)
    begin
        clkCounterOn <= clkCounterOn + 1'b1;
        LedclkOut <= clkCounterOn[27];
    end
    else
    begin
        clkCounterOff <= clkCounterOff + 1'b1;
        LedclkOut <= clkCounterOff[25];
    end        
end
always @(posedge clk)
begin
        clkCounter <= clkCounter + 1'b1;
        SevenSegclkOut <= clkCounter[19];
end
endmodule
