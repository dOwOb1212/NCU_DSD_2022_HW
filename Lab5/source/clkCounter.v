module clkCounter(L_clk, S_clk, g_clk, clk, reset);
output reg L_clk, S_clk, g_clk;
input clk, reset;
reg [16:0] S_clkCounter;
reg [25:0] L_clkCounter;
reg [26:0] g_clkCounter;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        S_clkCounter <= 16'b0;
        L_clkCounter <= 26'b0;
        g_clkCounter <= 27'b0;
    end
    else
    begin
        S_clkCounter <= S_clkCounter + 1'b1;
        L_clkCounter <= L_clkCounter + 1'b1;
        g_clkCounter <= g_clkCounter + 1'b1;
        S_clk <= S_clkCounter[15];
        L_clk <= L_clkCounter[25];
        g_clk <= g_clkCounter[26];
    end
end
endmodule
