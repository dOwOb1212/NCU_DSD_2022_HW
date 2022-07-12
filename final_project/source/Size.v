module Size(Long_enough, snake_x_i, snake_y_i);
output reg Long_enough;
input [39:0] snake_x_i, snake_y_i;
wire [3:0] snake_x[9:0], snake_y[9:0];
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(*)
begin
    if(snake_x[0] != 4'd13 && snake_y[0] != 4'd13)
        Long_enough = 1;
    else 
        Long_enough = 0;
end
endmodule
