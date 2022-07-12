module SnakeMove(flag, touch , direct, snake_x_out, snake_y_out, state, up, down, left, right, N_fruit_x, N_fruit_y, s_clk, clk, reset, key_state);
output [39:0] snake_x_out, snake_y_out;
output reg touch, flag;
output reg [1:0] direct;
input [2:0] state;
input s_clk, clk, reset, up, left, right, down, key_state;
input [3:0] N_fruit_x, N_fruit_y;
reg [3:0] snake_x[9:0], snake_y[9:0];
assign snake_x_out = {{snake_x[9]},{snake_x[8]},{snake_x[7]},{snake_x[6]},{snake_x[5]},{snake_x[4]},{snake_x[3]},{snake_x[2]},{snake_x[1]},{snake_x[0]}};
assign snake_y_out = {{snake_y[9]},{snake_y[8]},{snake_y[7]},{snake_y[6]},{snake_y[5]},{snake_y[4]},{snake_y[3]},{snake_y[2]},{snake_y[1]},{snake_y[0]}};
reg [1:0]prev_direct;

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        direct <= 2'b00;
    end
    else
    begin
        if(right && prev_direct != 2'b10 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b00;
        else if(up && prev_direct != 2'b11 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b01;
        else if(left && prev_direct != 2'b00 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b10;
        else if(down && prev_direct != 2'b01 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b11;
        else
            direct <= direct;
    end
end

reg touchFruit;
reg counter, times;
always @(posedge s_clk or negedge reset)
begin
    if(!reset)
    begin
        snake_x[9] <= 4'd2;
        snake_x[8] <= 4'd1;
        snake_x[7] <= 4'd0;
        snake_x[6] <= 4'd13;
        snake_x[5] <= 4'd13;
        snake_x[4] <= 4'd13;
        snake_x[3] <= 4'd13;
        snake_x[2] <= 4'd13;
        snake_x[1] <= 4'd13;
        snake_x[0] <= 4'd13;
        snake_y[9] <= 4'd7;
        snake_y[8] <= 4'd7;
        snake_y[7] <= 4'd7;
        snake_y[6] <= 4'd13;
        snake_y[5] <= 4'd13;
        snake_y[4] <= 4'd13;
        snake_y[3] <= 4'd13;
        snake_y[2] <= 4'd13;
        snake_y[1] <= 4'd13;
        snake_y[0] <= 4'd13;
        touch <= 0;
        prev_direct <= 2'b00;
        touchFruit <= 0;
        flag <= 0;
        times <= 0;
        counter <= 0;
    end
    else
    begin
        if(state == 3'b001 || state == 3'b010)
        begin 
            if(state == 3'b010 && counter && times)
                flag <= ~flag;
            if(state == 3'b010)
            begin
                times <= 1;
                counter <= ~counter;
            end
            prev_direct <= direct;
            if(snake_x[9] != 4'd13 && snake_y[9] != 4'd13)
            begin
                case(direct)
                2'b00:  begin
                    snake_x[9] <= snake_x[9] + 1;
                    snake_y[9] <= snake_y[9];    
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[9] <= snake_x[9];
                        touch <= 1;
                    end 
                end
                2'b01:  begin
                    snake_x[9] <= snake_x[9];
                    snake_y[9] <= snake_y[9] - 1;
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_y[9] <= snake_y[9];
                        touch <= 1;
                    end 
                end
                2'b10: begin
                    snake_x[9] <= snake_x[9] - 1;
                    snake_y[9] <= snake_y[9];
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[9] <= snake_x[9];
                        touch <= 1;
                    end 
                end
                2'b11:  begin
                    snake_x[9] <= snake_x[9];
                    snake_y[9] <= snake_y[9] + 1;
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_y[9] <= snake_y[9];
                        touch <= 1;
                    end
                end
                endcase
            end
            else
            begin
                snake_x[9] <= snake_x[9];
                snake_y[9] <= snake_y[9];
            end
            if(snake_x[8] != 4'd13 && snake_y[8] != 4'd13)
            begin
                snake_x[8] <= snake_x[9];
                snake_y[8] <= snake_y[9];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end     
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                endcase
            end
            else
            begin
                snake_x[8] <= snake_x[8];
                snake_y[8] <= snake_y[8];
            end
            if(snake_x[7] != 4'd13 && snake_y[7] != 4'd13)
            begin
                snake_x[7] <= snake_x[8];
                snake_y[7] <= snake_y[8];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[7] <= snake_x[7];
                snake_y[7] <= snake_y[7];
            end
            if(snake_x[6] != 4'd13 && snake_y[6] != 4'd13)
            begin
                snake_x[6] <= snake_x[7];
                snake_y[6] <= snake_y[7];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                endcase
            end
            else
            begin
                snake_x[6] <= snake_x[6];
                snake_y[6] <= snake_y[6];
            end
            if(snake_x[5] != 4'd13 && snake_y[5] != 4'd13)
            begin
                snake_x[5] <= snake_x[6];
                snake_y[5] <= snake_y[6];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                endcase
            end
            else
            begin
                snake_x[5] <= snake_x[5];
                snake_y[5] <= snake_y[5];
            end
            if(snake_x[4] != 4'd13 && snake_y[4] != 4'd13)
            begin
                snake_x[4] <= snake_x[5];
                snake_y[4] <= snake_y[5];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[4] <= snake_x[4];
                snake_y[4] <= snake_y[4];
            end
            if(snake_x[3] != 4'd13 && snake_y[3] != 4'd13)
            begin
                snake_x[3] <= snake_x[4];
                snake_y[3] <= snake_y[4];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[3] <= snake_x[3];
                snake_y[3] <= snake_y[3];
            end
            if(snake_x[2] != 4'd13 && snake_y[2] != 4'd13)
            begin
                snake_x[2] <= snake_x[3];
                snake_y[2] <= snake_y[3];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[2] <= snake_x[2];
                snake_y[2] <= snake_y[2];
            end
            if(snake_x[1] != 4'd13 && snake_y[1] != 4'd13)
            begin
                snake_x[1] <= snake_x[2];
                snake_y[1] <= snake_y[2];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[1] <= snake_x[1];
                snake_y[1] <= snake_y[1];
            end
            if(snake_x[0] != 4'd13 && snake_y[0] != 4'd13)
            begin
                snake_x[0] <= snake_x[1];
                snake_y[0] <= snake_y[1];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[0] <= snake_x[0];
                snake_y[0] <= snake_y[0];
            end
            if((direct == 2'b00 && (snake_x[9] + 1) == N_fruit_x && (snake_y[9]) == N_fruit_y) || 
            (direct == 2'b01 &&(snake_x[9]) == N_fruit_x && (snake_y[9] - 1) == N_fruit_y) || 
            (direct == 2'b10 && (snake_x[9] - 1) == N_fruit_x && (snake_y[9]) == N_fruit_y) || 
            (direct == 2'b11 && (snake_x[9]) == N_fruit_x && (snake_y[9] + 1) == N_fruit_y))
            begin
               if(snake_x[6] == 4'd13 && snake_y[6] == 4'd13)
               begin
                   snake_x[6] <= snake_x[7];
                   snake_y[6] <= snake_y[7];
               end 
               else if(snake_x[5] == 4'd13 && snake_y[5] == 4'd13)
               begin
                   snake_x[5] <= snake_x[6];
                   snake_y[5] <= snake_y[6];
               end
               else if(snake_x[4] == 4'd13 && snake_y[4] == 4'd13)
               begin
                   snake_x[4] <= snake_x[5];
                   snake_y[4] <= snake_y[5];
               end
               else if(snake_x[3] == 4'd13 && snake_y[3] == 4'd13)
               begin
                   snake_x[3] <= snake_x[4];
                   snake_y[3] <= snake_y[4];
               end
               else if(snake_x[2] == 4'd13 && snake_y[2] == 4'd13)
               begin
                   snake_x[2] <= snake_x[3];
                   snake_y[2] <= snake_y[3];
               end
               else if(snake_x[1] == 4'd13 && snake_y[1] == 4'd13)
               begin
                   snake_x[1] <= snake_x[2];
                   snake_y[1] <= snake_y[2];
               end
               else if(snake_x[0] == 4'd13 && snake_y[0] == 4'd13)
               begin
                   snake_x[0] <= snake_x[1];
                   snake_y[0] <= snake_y[1];
               end
            end
        end
    end
end
endmodule
