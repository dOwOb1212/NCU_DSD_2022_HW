module clkDivider(f_clk, Led_clk, i_clk, snake_clk, c_clk, SevenSeg_clk, clk, reset);
input clk, reset;
output reg Led_clk, i_clk, snake_clk, SevenSeg_clk, c_clk, f_clk;
reg [26:0] Hz1;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        Hz1 <= 0;
    end
    else
    begin
        Hz1 <= Hz1 + 27'b1;
        c_clk <= Hz1[26];
        snake_clk <= Hz1[25];
        i_clk <= Hz1[25];
        SevenSeg_clk <= Hz1[16];
        Led_clk <= Hz1[24];
        f_clk <= Hz1[6];
    end
end
endmodule
