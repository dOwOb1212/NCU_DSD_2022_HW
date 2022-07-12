module LedShift(modeOut[15:0], Pattern[3:0], now_group[2:0], flag);
output [15:0]modeOut;
input [3:0]Pattern;
input [2:0]now_group;
input flag;
reg [3:0]group1;
reg [3:0]group2;
reg [3:0]group3; 
reg [3:0]group4;
assign modeOut = {group4,group3,group2,group1};
always @(*)
begin
    if(flag)
    begin
        if(now_group == 3'b000)
        begin
            group1[3:0] = Pattern[3:0];
            group2[3:0] = 4'b0;
            group3[3:0] = 4'b0;
            group4[3:0] = 4'b0;
        end
        else if(now_group == 3'b001) 
        begin
            group1[3:0] = 4'b0;
            group2[3:0] = Pattern[3:0];
            group3[3:0] = 4'b0;
            group4[3:0] = 4'b0;
        end
        else if(now_group == 3'b010)
        begin 
            group1[3:0] = 4'b0;
            group2[3:0] = 4'b0;
            group3[3:0] = Pattern[3:0];
            group4[3:0] = 4'b0;
        end
        else if(now_group == 3'b011)
        begin
            group1[3:0] = 4'b0;
            group2[3:0] = 4'b0;
            group3[3:0] = 4'b0;
            group4[3:0] = Pattern[3:0];
        end
        else if(now_group == 3'b100)
        begin
            group1[3:0] = 4'b0;
            group2[3:0] = 4'b0;
            group3[3:0] = Pattern[3:0];
            group4[3:0] = 4'b0;
        end
        else if(now_group == 3'b101) 
        begin
            group1[3:0] = 4'b0;
            group2[3:0] = Pattern[3:0];
            group3[3:0] = 4'b0;
            group4[3:0] = 4'b0;
        end
        else if(now_group == 3'b110)
        begin 
            group1[3:0] = Pattern[3:0];
            group2[3:0] = 4'b0;
            group3[3:0] = 4'b0;
            group4[3:0] = 4'b0;
        end
    end
end
endmodule
