module TouchFruit(Touch_N_Fruit, Touch_I_Fruit, N_fruit_x, I_fruit_x, I_fruit_y, N_fruit_y, snake_head_x, snake_head_y);
output reg Touch_I_Fruit, Touch_N_Fruit;
input [3:0]N_fruit_x, N_fruit_y, snake_head_x, snake_head_y, I_fruit_x, I_fruit_y;
always @(*)
begin
    if(N_fruit_x == snake_head_x && N_fruit_y == snake_head_y)
        Touch_N_Fruit = 1;
    else if(snake_head_x == I_fruit_x && snake_head_y == I_fruit_y)
        Touch_I_Fruit = 1;
    else 
    begin
        Touch_I_Fruit = 0;
        Touch_N_Fruit = 0;
    end
end
endmodule
