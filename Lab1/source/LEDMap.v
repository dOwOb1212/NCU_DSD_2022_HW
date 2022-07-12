module LEDMap(out[15:0], pos[2:0], patt[3:0]);
output reg [15:0]out;
input [2:0]pos;
input [3:0]patt;
reg [3:0]group1;
reg [3:0]group2;
reg [3:0]group3;
reg [3:0]group4;
always @(*) begin
    if(pos == 3'b000) begin
        group1 = patt;
        group2 = patt;
        group3 = 4'b0000;
        group4 = 4'b0000;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b001) begin
        group1 = patt;
        group2 = 4'b0000;
        group3 = patt;
        group4 = 4'b0000;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b010) begin
        group1 = patt;
        group2 = 4'b0000;
        group3 = 4'b0000;
        group4 = patt;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b011) begin
        group1 = 4'b0000;
        group2 = patt;
        group3 = patt;
        group4 = 4'b0000;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b100) begin
        group1 = 4'b0000;
        group2 = patt;
        group3 = 4'b0000;
        group4 = patt;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b101) begin
        group1 = 4'b0000;
        group2 = 4'b0000;
        group3 = patt;
        group4 = patt;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b110) begin
        group1 = patt;
        group2 = patt;
        group3 = patt;
        group4 = 4'b0000;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end
    else if(pos == 3'b111) begin
        group1 = 4'b0000;
        group2 = patt;
        group3 = patt;
        group4 = patt;
        out[15:0] = {group1[3:0],group2[3:0],group3[3:0],group4[3:0]};
    end    
end
endmodule
