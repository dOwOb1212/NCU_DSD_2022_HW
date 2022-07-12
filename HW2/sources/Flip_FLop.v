module Flip_Flop(Q,D,CLK,Reset,resetNum);
input D,CLK,Reset,resetNum;
output reg Q;
always @(posedge CLK or negedge Reset)
    begin
    if(!Reset)
        Q <= resetNum;
    else
        Q <= D;
    end
endmodule
