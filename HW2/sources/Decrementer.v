module Decremeter(Dec[3:0],Disable,CLK,reset);
input Disable,CLK,reset;
output wire [3:0]Dec;
//wire out0,out1,out2,out3;
wire response0,response1,response2,response3;
Flip_Flop ff0(Dec[0],response0,CLK,reset,1);
Flip_Flop ff1(Dec[1],response1,CLK,reset,0);
Flip_Flop ff2(Dec[2],response2,CLK,reset,0);
Flip_Flop ff3(Dec[3],response3,CLK,reset,0);
assign response0 = ~((Disable ^ Dec[0]));
assign response1 = ~((Disable | Dec[0]) ^ Dec[1]);
assign response2 = ~((Disable | Dec[0] | Dec[0] | Dec[1]) ^ Dec[2]);
assign response3 = ~((Disable | Dec[0] | Dec[0] | Dec[1] | Dec[0] | Dec[1] | Dec[2]) ^ Dec[3]);
endmodule