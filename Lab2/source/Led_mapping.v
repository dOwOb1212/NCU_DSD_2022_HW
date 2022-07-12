module Led_mapping(LedOut[15:0], now_group[2:0], now_times[1:0], PatternReg[3:0], Speed, Mode, Pattern[3:0], Times[1:0], clk, reset);
output reg [15:0]LedOut = 16'b0;
output reg [2:0]now_group;
output reg [1:0]now_times;
output reg [3:0]PatternReg;
input Speed, Mode;
input [3:0]Pattern;
input [1:0]Times;
input clk, reset;
reg flag = 1'b0;
wire [15:0]mode1Out;
wire [15:0]mode0Out;
clkCounter clkCount(.LedclkOut(clkOut), .Speed(Speed), .clk(clk));
LedShift mode0map(mode0Out[15:0], Pattern[3:0], now_group[2:0], flag);
LedShift mode1map(mode1Out[15:0], PatternReg[3:0], now_group[2:0], flag);
always @(posedge clkOut or negedge reset)
begin
    if(!reset)
    begin
        PatternReg <= Pattern;
        now_times <= 2'b0;
        now_group <= 3'b0;
        flag <= 1'b1;
    end
    else
    begin
        if(now_times != Times)
        begin
            if(Mode)
            begin
                    LedOut <= mode1Out;
            end
            else
            begin
                    LedOut <= mode0Out;
            end
            if(now_group == 3'b110)
            begin
                now_times <= now_times + 1'b1;
                now_group <= 3'b001;
                PatternReg <= PatternReg + 1'b1;
            end
            else
            begin
                now_group <= now_group + 3'b001;
            end
        end
    end
end

endmodule

