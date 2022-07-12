module chance(out[1:0], state[1:0], clk);
output [1:0]out;
input [1:0]state;
input clk;
reg [1:0]life = 2'b10;
assign out = life;
always @(posedge clk)
begin
    if(state == 2'b11)
        life <= life - 1;
    if(life == 2'b11)
        life <= 2'b10;
end
endmodule
