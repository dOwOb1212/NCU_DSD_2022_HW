module shuriken (clk, reset, state, S1_Y, S2_Y, S3_Y);
input clk, reset;
input [1:0] state;
output reg [3:0] S1_Y, S2_Y, S3_Y;
parameter Stop = 2'b00, Movement = 2'b01, Elevation = 2'b10, Die = 2'b11;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        S1_Y <= 8;
        S2_Y <= 5;
        S3_Y <= 2;
    end
    else if (state == Movement || state == Elevation) begin
        if (S1_Y == 0) begin
            S1_Y <= 8;
            S2_Y <= S2_Y - 1;
            S3_Y <= S3_Y - 1;
        end
        else if (S2_Y == 0) begin
            S1_Y <= S1_Y - 1;
            S2_Y <= 8;
            S3_Y <= S3_Y - 1;
        end
        else if (S3_Y == 0) begin
            S1_Y <= S1_Y - 1;
            S2_Y <= S2_Y - 1;
            S3_Y <= 8;
        end
        else begin
            S1_Y <= S1_Y - 1;
            S2_Y <= S2_Y - 1;
            S3_Y <= S3_Y - 1;
        end
    end
end
endmodule
