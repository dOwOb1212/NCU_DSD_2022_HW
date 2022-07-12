module Shuriken(ylocOut[3:0], Yinit[3:0], clk, reset);
output [3:0]ylocOut;
input [3:0]Yinit;
input clk, reset; 
reg [3:0]yloc;
assign ylocOut = yloc;
always @(posedge clk)
begin
    if(reset)
    begin
        yloc <= Yinit;
    end
    else
    begin
        if(yloc == 4'b0000)
            yloc <= 4'b1000;
        else
            yloc <= yloc - 1; 
    end
end
endmodule
