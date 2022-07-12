module Ninja(xlocOut[3:0], ylocOut[3:0], Rmove, Lmove, state[1:0], clk, reset);
output [3:0]xlocOut;
output [3:0]ylocOut;
input Rmove, Lmove, clk, reset;
input [1:0]state;
reg [3:0]xloc;
reg [3:0]yloc;
assign xlocOut = xloc;
assign ylocOut = yloc;
always @(posedge clk or posedge reset)
begin
    if(reset || state == 2'b11)
    begin
        xloc <= 4'b0;
        yloc <= 4'b1;
    end
    else 
    begin
        if(state == 2'b10)
        begin
            yloc <= yloc + 1;
        end
        if(state != 2'b00)
        begin
            if(Rmove)
            begin
                xloc <= xloc + 1;
            end 
            if(Lmove)
            begin
                xloc <= xloc -1;
            end
        end
    end
end
endmodule
