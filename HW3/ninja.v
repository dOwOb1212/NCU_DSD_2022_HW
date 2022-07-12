module ninja (N_X, N_Y, chance, clk, reset, goLeft, goRight,touch, drop, onelevation);
input clk, reset, goLeft, goRight;
output reg [3:0] N_X, N_Y;
output reg [1:0] chance;
input touch, drop, onelevation;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        N_X <= 6; N_Y <= 0; chance <= 2;
    end
    else begin
        if (goLeft)
            N_X <= N_X - 1;
        if (goRight)
            N_X <= N_X + 1;
        if (touch || drop) begin
            {N_X, N_Y} <= {4'd0, 4'd1};
            chance <= chance - 1;
        end
        if (onelevation) begin
            if (N_Y == 11)
                N_Y <= 0;
            else
                N_Y <= N_Y + 1;
        end
    end
end


endmodule