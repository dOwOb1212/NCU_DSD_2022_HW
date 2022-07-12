module PacMan_move(PacMan_x, PacMan_y, S1_D, S0_D, S3_D, S4_D, clk, reset, state);
output reg [2:0] PacMan_x, PacMan_y;
input S1_D, S0_D, S3_D, S4_D, clk, reset;
input [1:0] state;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        PacMan_x <= 3'd0;
        PacMan_y <= 3'd5;
    end
    else
    begin
        if(state == 2'b0)
        begin
            if(S1_D && PacMan_y != 3'd5 && (PacMan_y != 3'd1 || PacMan_x != 3'd0) && (PacMan_y != 3'd0 || (PacMan_x != 3'd1 && PacMan_x != 3'd2)) && (PacMan_y != 3'd3 || (PacMan_x != 3'd1 && PacMan_x != 3'd2)) && (PacMan_y != 3'd0 || (PacMan_x != 3'd4 && PacMan_x != 3'd5)) && (PacMan_y != 3'd2 || (PacMan_x != 3'd4 && PacMan_x != 3'd5)) && (PacMan_y != 3'd1 || PacMan_x != 3'd7))
                PacMan_y <= PacMan_y + 3'd1;
            else if(S0_D && PacMan_x != 3'd7 && ((PacMan_y != 3'd1 && PacMan_y != 3'd4 )|| PacMan_x != 3'd0) && ((PacMan_y != 3'd1 && PacMan_y != 3'd3) || PacMan_x != 3'd3) && ((PacMan_y != 3'd2 && PacMan_y != 3'd3) || PacMan_x != 3'd6))
                PacMan_x <= PacMan_x + 3'd1;
            else if(S3_D && PacMan_x != 3'd0 && (PacMan_x != 3'd3 || (PacMan_y != 3'd1 && PacMan_y != 3'd4)) && (PacMan_x != 3'd1 || (PacMan_y != 3'd3 && PacMan_y != 3'd2)) && (PacMan_x != 3'd6 || (PacMan_y != 3'd1 && PacMan_y != 3'd3)))
                PacMan_x <= PacMan_x - 3'd1;
            else if(S4_D && PacMan_y != 3'd0 && (PacMan_y != 3'd4 || PacMan_x != 3'd0) && ((PacMan_y != 3'd2 && PacMan_y != 3'd5) || PacMan_x != 3'd1) && ((PacMan_y != 3'd2 && PacMan_y != 3'd5) || PacMan_x != 3'd2) && ((PacMan_y != 3'd2 && PacMan_y != 3'd4) || PacMan_x != 3'd4) && ((PacMan_y != 3'd4 && PacMan_y != 3'd2) || PacMan_x != 3'd5) && (PacMan_y != 3'd4 || PacMan_x != 3'd7))
                PacMan_y <= PacMan_y - 3'd1;
        end
    end
end 
endmodule
