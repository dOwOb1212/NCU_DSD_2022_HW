module I_fruit(I_fruit_x, I_fruit_y, state, snake_x_i, snake_y_i, poison_x, poison_y, N_fruit_x, N_fruit_y, Q, Touch_I_fruit, clk, f_clk, reset, key_state);
output reg [3:0] I_fruit_x, I_fruit_y;
input [2:0] state;
input [39:0] snake_y_i, snake_x_i;
input [3:0] poison_x, poison_y, N_fruit_x, N_fruit_y;
input reset, clk, Q, Touch_I_fruit, f_clk, key_state;
reg valid;
reg [3:0] allow_x, allow_y;
wire [3:0] snake_x[9:0], snake_y[9:0];
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(posedge f_clk or negedge reset)
begin
    if(!reset)
    begin
        I_fruit_x <= 4'd13;
        I_fruit_y <= 4'd13;
        valid <= 0;
    end
    else
    begin
        if(state == 3'b001 && Q && key_state)
        begin
            begin
                if(!valid)
                begin
                    I_fruit_x <= allow_x;
                    I_fruit_y <= allow_y;
                    valid <= 1;
                end
                if(Touch_I_fruit)
                begin
                    I_fruit_x <= 4'd13;
                    I_fruit_y <= 4'd13;
                end
            end
        end
        else if(state == 3'b010)
        begin
            I_fruit_x <= 4'd13;
            I_fruit_y <= 4'd13;
        end
        else
        begin
            I_fruit_x <= I_fruit_x;
            I_fruit_y <= I_fruit_y;
        end
    end
end

reg [3:0] x, y;
reg [3:0] prev_N_fruit_x, prev_N_fruit_y;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        x <= 0;
        y <= 0;
    end
    else
    begin
        x <= x + 1;
        if(x == 4'd9)
        begin
            y <= y + 1;
            x <= 4'd0; 
        end
        if(y == 4'd7 && x == 4'd9)
        begin
            y <= 0;
            x <= 0;
        end
    end
end

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        allow_y <= 0;
        allow_x <= 0; 
        prev_N_fruit_x <= 0;
        prev_N_fruit_y <= 0;
    end
    else
    begin
        prev_N_fruit_x <= N_fruit_x;
        prev_N_fruit_y <= N_fruit_y;
        if((x != poison_x || y != poison_y) && (x != N_fruit_x || y != N_fruit_y) &&
        !((prev_N_fruit_x == N_fruit_x) && (prev_N_fruit_y == N_fruit_y)) &&
        !(x == snake_x[9] && y == snake_y[9]) && !(x == snake_x[8] && y == snake_y[8]) && 
        !(x == snake_x[7] && y == snake_y[7]) && !(x == snake_x[6] && y == snake_y[6]) && 
        !(x == snake_x[5] && y == snake_y[5]) && !(x == snake_x[4] && y == snake_y[4]) && 
        !(x == snake_x[3] && y == snake_y[3]) && !(x == snake_x[2] && y == snake_y[2]) && 
        !(x == snake_x[1] && y == snake_y[1]) && !(x == snake_x[0] && y == snake_y[0]))
        begin
            allow_x <= x;
            allow_y <= y;
        end
    end
end
endmodule

