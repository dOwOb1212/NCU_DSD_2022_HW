module Score(score100, score10, score1, Touch_N_Fruit, state, clk, reset);
output reg [3:0] score100, score10, score1;
input Touch_N_Fruit, clk, reset;
input [2:0] state;
reg flag, valid;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        score100 <= 4'd10;
        score10 <= 4'd10;
        score1 <= 4'd0;
        flag <= 0;
        valid <= 0;
    end
    else 
    begin
        if(Touch_N_Fruit && !valid)
        begin
            if(state == 3'b010)
            begin
                if(!flag)
                begin
                    if(score10 == 4'd9)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 1;
                        if(score10 == 4'd10)
                            score10 <= 4'd1;
                    end
                end
                else
                begin
                    if(score10 == 4'd8)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 4'd2;
                        if(score10 == 4'd10)
                            score10 <= 4'd2;
                    end
                end
            end
            else
            begin
                if(!flag)
                begin
                    if(score1 == 4'd5)
                    begin
                        if(score10 == 4'd9)
                        begin
                            score100 <= score100 + 4'd1;
                            score10 <= 4'd0;
                            score1 <= 4'd0;
                        end
                        else
                        begin
                            score10 <= score10 + 4'd1;
                            score1 <= 4'd0;
                        end
                    end
                    else
                    begin
                        score1 <= score1 + 4'd5;
                        if(score1 == 4'd10)
                            score1 <= 4'd5;
                    end
                end
                else
                begin
                    if(score10 == 4'd9)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 1;
                        if(score10 == 4'd10)
                            score10 <= 4'd1;
                    end
                end
            end
            flag <= ~flag;
            valid <= 1;
        end
        else if(valid && !Touch_N_Fruit)
        begin
            valid <= 0;
        end
    end
end
endmodule
