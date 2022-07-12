module Lab1_tb();
reg [7:0]DIP;
reg [3:0]Seven_Seg_Num;
wire [6:0]SegOutput;
wire [15:0]LEDOutput;
Top uut(.pos(DIP[7:5]), .patt(DIP[4:1]), .Dis(DIP[0]), .SegOutput(SegOutput[6:0]), .LEDOutput(LEDOutput[15:0]));
always @(*) begin
if(~DIP[0]) begin
        if(SegOutput == 7'b0111111) begin 
            Seven_Seg_Num[3:0] = 4'b0000;    
        end 
        else if(SegOutput == 7'b0000110) begin 
            Seven_Seg_Num[3:0] = 4'b0001;
        end
        else if(SegOutput == 7'b1011011) begin 
            Seven_Seg_Num[3:0] = 4'b0010;
        end
        else if(SegOutput == 7'b1001111) begin 
            Seven_Seg_Num[3:0] = 4'b0011;
        end
        else if(SegOutput == 7'b1100110) begin 
            Seven_Seg_Num[3:0] = 4'b0100;
        end
        else if(SegOutput == 7'b1101101) begin 
            Seven_Seg_Num[3:0] = 4'b0101;
        end
        else if(SegOutput == 7'b1111101) begin 
            Seven_Seg_Num[3:0] = 4'b0110;
        end
        else if(SegOutput == 7'b0000111) begin 
            Seven_Seg_Num[3:0] = 4'b0111;
        end
        else if(SegOutput == 7'b1111111) begin 
            Seven_Seg_Num[3:0] = 4'b1000;
        end
        else if(SegOutput == 7'b1101111) begin 
            Seven_Seg_Num[3:0] = 4'b1001;
        end
        else if(SegOutput == 7'b1110111) begin 
            Seven_Seg_Num[3:0] = 4'b1010;
        end
        else if(SegOutput == 7'b1111100) begin 
            Seven_Seg_Num[3:0] = 4'b1011;
        end
        else if(SegOutput == 7'b0111001) begin 
            Seven_Seg_Num[3:0] = 4'b1100;
        end
        else if(SegOutput == 7'b1011110) begin 
            Seven_Seg_Num[3:0] = 4'b1101;
        end
        else if(SegOutput == 7'b1111001) begin 
            Seven_Seg_Num[3:0] = 4'b1110;
        end
        else if(SegOutput == 7'b1110001) begin 
            Seven_Seg_Num[3:0] = 4'b1111;
        end
    end
    else begin
        if(SegOutput == 7'b0111111) begin 
            Seven_Seg_Num[3:0] = 4'b0000;    
        end 
        else if(SegOutput == 7'b0000110) begin 
            Seven_Seg_Num[3:0] = 4'b0001;
        end
        else if(SegOutput == 7'b1011011) begin 
            Seven_Seg_Num[3:0] = 4'b0010;
        end
        else if(SegOutput == 7'b1001111) begin 
            Seven_Seg_Num[3:0] = 4'b0011;
        end
        else if(SegOutput == 7'b1100110) begin 
            Seven_Seg_Num[3:0] = 4'b0100;
        end
        else if(SegOutput == 7'b1101101) begin 
            Seven_Seg_Num[3:0] = 4'b0101;
        end
        else if(SegOutput == 7'b1111101) begin 
            Seven_Seg_Num[3:0] = 4'b0110;
        end
        else if(SegOutput == 7'b0000111) begin 
            Seven_Seg_Num[3:0] = 4'b0111;
        end
        else if(SegOutput == 7'b1111111) begin 
            Seven_Seg_Num[3:0] = 4'b1000;
        end
        else if(SegOutput == 7'b1101111) begin 
            Seven_Seg_Num[3:0] = 4'b1001;
        end
        else if(SegOutput == 7'b1110111) begin 
            Seven_Seg_Num[3:0] = 4'b1010;
        end
        else if(SegOutput == 7'b1111100) begin 
            Seven_Seg_Num[3:0] = 4'b1011;
        end
        else if(SegOutput == 7'b0111001) begin 
            Seven_Seg_Num[3:0] = 4'b1100;
        end
        else if(SegOutput == 7'b1011110) begin 
            Seven_Seg_Num[3:0] = 4'b1101;
        end
        else if(SegOutput == 7'b1111001) begin 
            Seven_Seg_Num[3:0] = 4'b1110;
        end
        else if(SegOutput == 7'b1110001) begin 
            Seven_Seg_Num[3:0] = 4'b1111;
        end
    end
end
initial begin
DIP = 8'b01000011;
#100 DIP = 8'b11000010;
#100 DIP = 8'b10000101;
#100 DIP = 8'b10100100;
#100 DIP = 8'b11011011;
#100 DIP = 8'b11111010;
$finish;
end
endmodule