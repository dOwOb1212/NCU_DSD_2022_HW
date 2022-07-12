module Ledclk(LedclkOut, clk, reset);
output reg LedclkOut;
input clk, reset;
reg [25:0]clkCounter = 26'b0;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        clkCounter <= 26'b0;
    end
    else
    begin
        clkCounter <= clkCounter + 1'b1;
        LedclkOut <= clkCounter[25];
    end
end
endmodule
