module TouchBarrier(Touchbarrier, snake_x, snake_y);
output reg Touchbarrier;
input [3:0] snake_x, snake_y;
always @(*)
begin
    if((snake_x == 4'd3 && snake_y == 4'd2) || (snake_x == 4'd4 && snake_y == 4'd2) || (snake_x == 4'd5 && snake_y == 4'd2) || (snake_x == 4'd6 && snake_y == 4'd2))
        Touchbarrier = 1;
    else
        Touchbarrier = 0;
end
endmodule
