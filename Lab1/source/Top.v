module Top(Enable[1:0], SegOutput[6:0], LEDOutput[15:0], pos[2:0], patt[3:0], Dis);
output wire [6:0]SegOutput;
output wire [15:0]LEDOutput;
output [1:0]Enable;
input [2:0]pos;
input [3:0]patt;
input Dis;
wire [3:0]Lseg;
wire [3:0]Rseg;
toSeg SegInput(Lseg[3:0], Rseg[3:0], pos[2:0], patt[3:0]);
SevenSegMap Segoutput(Enable[1:0], SegOutput[6:0], Lseg[3:0], Rseg[3:0], Dis);
LEDMap LEDoutput(LEDOutput[15:0], pos[2:0], patt[3:0]);
endmodule