module ghost_move(ghost_x, ghost_y, g_clk, reset, state);
output reg [2:0] ghost_x, ghost_y;
input g_clk, reset; 
input [1:0] state;
always @(posedge g_clk or negedge reset)
begin
    if(!reset)
    begin
        ghost_x <= 3'd3;
        ghost_y <= 3'd4;
    end
    else
    begin
        if(state == 2'b00)
        begin
            ghost_y <= ghost_y - 3'd1;
            if(ghost_y == 3'd0)
                ghost_y <= 3'd5;
        end
    end
end
endmodule
