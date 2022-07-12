module TouchPoison(touch, snake_head_x, snake_head_y, state, poison_x, poison_y);
output reg touch;
input [2:0] state;
input [3:0] snake_head_x, snake_head_y, poison_x, poison_y;
always @(*)
begin
    if(snake_head_x == poison_x && snake_head_y == poison_y)
        touch = 1;
    else 
        touch = 0;
end
endmodule
