module toSeg(Lseg[3:0], Rseg[3:0], pos[2:0], patt[3:0]);
output [3:0]Lseg;
output [3:0]Rseg;
input [2:0]pos;
input [3:0]patt;
assign Lseg[3:0] = patt[3:0];
assign Rseg[3:0] = pos[2:0] - 3'b001; 
endmodule