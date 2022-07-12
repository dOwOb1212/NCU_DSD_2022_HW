module SevenSeg_pattern(out[6:0], Pattern[3:0], flag);
output reg [6:0]out;
input flag;
input [3:0]Pattern;
always @(*)
begin    
    if(flag)
    begin
        if(Pattern == 4'b0000) begin 
            out = 7'b0111111;    
        end 
        else if(Pattern == 4'b0001) begin 
            out = 7'b0000110;
        end
        else if(Pattern == 4'b0010) begin 
            out = 7'b1011011;
        end
        else if(Pattern == 4'b0011) begin 
            out = 7'b1001111;
        end
        else if(Pattern == 4'b0100) begin 
            out = 7'b1100110;
        end
        else if(Pattern == 4'b0101) begin 
            out = 7'b1101101;
        end
        else if(Pattern == 4'b0110) begin 
            out = 7'b1111101;
        end
        else if(Pattern == 4'b0111) begin 
            out = 7'b0000111;
        end
        else if(Pattern == 4'b1000) begin 
            out = 7'b1111111;
        end
        else if(Pattern == 4'b1001) begin 
            out = 7'b1101111;
        end
        else if(Pattern == 4'b1010) begin 
            out = 7'b1110111;
        end
        else if(Pattern == 4'b1011) begin 
            out = 7'b1111100;
        end
        else if(Pattern == 4'b1100) begin 
            out = 7'b0111001;
        end
        else if(Pattern == 4'b1101) begin 
            out = 7'b1011110;
        end
        else if(Pattern == 4'b1110) begin 
            out = 7'b1111001;
        end
        else if(Pattern == 4'b1111) begin 
            out = 7'b1110001;
        end
    end
end
endmodule
