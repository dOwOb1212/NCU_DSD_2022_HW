module SevenSegclk(SevenSegclkOut, clk, reset);
output reg SevenSegclkOut;
input clk, reset;
reg [15:0]clkCounter;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        clkCounter <= 16'b0;
    end
    else
    begin
        clkCounter <= clkCounter + 1'b1;
        SevenSegclkOut <= clkCounter[15];
    end
end
endmodule
