module Top(SevenSegout[6:0], LedOut[15:0], Enable[1:0], Speed, Mode, Pattern[3:0], Times[1:0], reset, clk);
output [15:0]LedOut;
output [1:0]Enable;
output [6:0]SevenSegout;
input Speed, Mode;
input [3:0]Pattern;
input [1:0]Times;
input reset;
input clk;
reg [3:0]Lseg;
reg [2:0]Rseg;
wire [2:0]now_group;
wire [1:0]now_times;
wire [3:0]PatternReg;
Led_mapping Leds(LedOut[15:0],now_group[2:0], now_times[1:0], PatternReg[3:0], Speed, Mode, Pattern[3:0], Times[1:0], clk, reset);
SevenSeg_mapping SevenSegs(SevenSegout[6:0], Enable[1:0], Lseg[3:0], Rseg[2:0], clk, reset);
always @(Mode or PatternReg or now_group or now_times)
begin
    if(Mode)
    begin
            if(now_group == 3'b001 && now_times != 0)
            begin
                Lseg = PatternReg - 1'b1;
            end
            else
            begin
                Lseg = PatternReg;
            end
    end
    else 
    begin
        Lseg = Pattern; 
    end 
end
always @(now_group)
begin
    if(now_group > 4'b100)
    begin
        Rseg = 3'b100 - (now_group - 3'b100);
    end
    else
    begin
        Rseg = now_group;
    end
end
endmodule
