module ScoreAndStep(SevenSegOut, enable, PacMan_x, PacMan_y, TouchFruit, S_clk, clk, reset);
output [6:0] SevenSegOut;
output reg [3:0] enable;
input [2:0] PacMan_x, PacMan_y;
input TouchFruit, S_clk, reset, clk;
reg [1:0] flag;
reg [3:0] now;
reg [3:0] Step0, Step1, Score0, Score1;
reg [2:0] prev_PacMan_x, prev_PacMan_y;
SevenSegMap U0(SevenSegOut, now);
always @(TouchFruit)
begin
    if(TouchFruit)
    begin
        Score0 = 4'd5;
        Score1 = 4'd0;
    end
    else
    begin
        Score0 = 4'd10;
        Score1 = 4'd10;
    end
end
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        prev_PacMan_x <= 3'd0;
        prev_PacMan_y <= 3'd5;
        Step0 <= 4'd0;
        Step1 <= 4'd0;
    end
    else
    begin
        if(PacMan_x != prev_PacMan_x)
        begin
            Step1 <= Step1 + 1;
            prev_PacMan_x <= PacMan_x;
            if(Step1 == 4'd9 && Step0 != 4'd9)
            begin
                Step0 <= Step0 + 4'd1;
                Step1 <= 4'd0;
            end
            else if(Step1 == 4'd9 && Step0 == 4'd9)
            begin
                Step0 <= 4'd9;
                Step1 <= 4'd9;
            end
        end
        else if(PacMan_y != prev_PacMan_y)
        begin
            Step1 <= Step1 + 1;
            prev_PacMan_y <= PacMan_y;
            if(Step1 == 4'd9 && Step0 != 4'd9)
            begin
                Step0 <= Step0 + 4'd1;
                Step1 <= 4'd0;
            end
            else if(Step1 == 4'd9 && Step0 == 4'd9)
            begin
                Step0 <= 4'd9;
                Step1 <= 4'd9;
            end
        end
    end
end
always @(posedge S_clk or negedge reset)
begin
    if(!reset)
    begin
        flag <= 4'd0;
    end
    else
    begin
        flag <= flag + 1'b1 ;
        case(flag)
            2'b00: begin
                now <= Score0;
                enable <= 4'b0001;
            end
            2'b01: begin
                now <= Score1;
                enable <= 4'b0010;
            end
            2'b10: begin
                now <= Step0;
                enable <= 4'b0100;
            end
            2'b11: begin
                now <= Step1;
                enable <= 4'b1000;
            end
        endcase
    end
end
endmodule
