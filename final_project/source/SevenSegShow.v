module SevenSegShow(L_SevenSegOut, R_SevenSegOut, enable, countDown, score100, score10, score1, state, SevenSeg_clk, reset);
output [6:0] L_SevenSegOut, R_SevenSegOut;
output reg [3:0] enable;
input [3:0] score100, score10, score1;
input [2:0] countDown;
input [2:0] state;
input SevenSeg_clk, reset;
reg [3:0] score, num;
SevenSegMap u0(L_SevenSegOut, score);
SevenSegMap u1(R_SevenSegOut, num);
reg [3:0]flag;
always @(posedge SevenSeg_clk or negedge reset)
begin
    if(!reset)
    begin
        score <= 4'd10;
        num <= 4'd10;
        flag <= 4'd0;
    end
    else
    begin
        if(state == 3'b010)
        begin
            case(flag)
                2'b00: begin
                    score <= score1;
                    num <= {1'b0,countDown};
                    enable <= 4'b0001;
                end
                2'b01: begin
                    score <= score10;
                    num <= 4'd10;
                    enable <= 4'b0010;
                end
                2'b10: begin
                    score <= score100;
                    num <= 4'd10;
                    enable <= 4'b0100;
                end
                2'b11: begin
                    score <= 4'd10;
                    num <= 4'd10;
                    enable <= 4'b1000;
                end
            endcase
        end
        else
        begin
            case(flag)
                2'b00: begin
                    score <= score1;
                    num <= 4'd10;
                    enable <= 4'b0001;
                end
                2'b01: begin
                    score <= score10;
                    num <= 4'd10;
                    enable <= 4'b0010;
                end
                2'b10: begin
                    score <= score100;
                    num <= 4'd10;
                    enable <= 4'b0100;
                end
                2'b11: begin
                    score <= 4'd10;
                    num <= 4'd10;
                    enable <= 4'b1000;
                end
            endcase
        end
        flag <= flag + 1'b1 ;
    end
end
endmodule
