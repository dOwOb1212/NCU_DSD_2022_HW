module CountDown(out_num, state, c_clk, reset);
output reg [2:0]out_num;
input [2:0]state;
input c_clk, reset;
always @(posedge c_clk or negedge reset)
begin
    if(!reset)
        out_num <= 3'd5;
    else
    begin
        if(state == 3'b010)
            out_num <= out_num - 1;
    end
end
endmodule
