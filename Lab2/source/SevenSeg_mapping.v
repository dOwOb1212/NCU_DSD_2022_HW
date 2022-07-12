module SevenSeg_mapping(out[6:0], Enable[1:0], Lseg[3:0], Rseg[2:0], clk, reset);
output reg [6:0]out;
output reg [1:0]Enable;
input reset;
input [3:0]Lseg;
input [2:0]Rseg;
input clk;
wire [3:0]Rseg_new;
wire [6:0]Lout;
wire [6:0]Rout;
reg [19:0]clkCounter;
wire clkOut;
reg flag = 1'b0;
reg judge = 1'b0;
assign Rseg_new = {{1'b0},{Rseg}};
SevenSeg_pattern Lmap(Lout[6:0], Lseg[3:0], judge);
SevenSeg_pattern Rmap(Rout[6:0], Rseg_new[3:0], judge);
clkCounter clkCount(.SevenSegclkOut(clkOut), .Speed(Speed), .clk(clk));
always @(posedge clkOut or negedge reset)
begin
    if(!reset)
    begin
        judge <= 1'b1;
    end
    else
    begin
        if(flag)
        begin
            Enable[1:0] <= 2'b10;
            out <= Lout;
        end
        else
        begin
            Enable[1:0] <= 2'b01;
            out <= Rout;
        end    
        flag <= flag + 1;
    end
end
endmodule
