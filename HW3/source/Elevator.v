module Elevator(ylocOut[3:0], Yinit[3:0], clk, reset, start);
output [3:0]ylocOut;
input [3:0]Yinit;
input clk, reset;
input start;
reg [3:0]yloc;
assign ylocOut = yloc;
reg flag = 1'b0;
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        yloc <= Yinit;
    end
    else if(flag)
    begin
        if(yloc == 4'b1011)
            yloc <= 0;
        else
            yloc <= yloc + 1;
    end
end
always @(start)
begin
    if(start)
        flag = 1'b1;
    else
        flag = flag;
end
endmodule
