module SevenSegMap(Enable[1:0], out[6:0], Lseg[3:0], Rseg[3:0], Dis);
output reg [6:0]out;
output reg [1:0]Enable;
input Dis;
input [3:0]Lseg;
input [3:0]Rseg;
always @(*) begin
    if(~Dis) begin
        Enable[1:0] = 2'b10;
        if(Lseg == 4'b0000) begin 
            out = 7'b0111111;    
        end 
        else if(Lseg == 4'b0001) begin 
            out = 7'b0000110;
        end
        else if(Lseg == 4'b0010) begin 
            out = 7'b1011011;
        end
        else if(Lseg == 4'b0011) begin 
            out = 7'b1001111;
        end
        else if(Lseg == 4'b0100) begin 
            out = 7'b1100110;
        end
        else if(Lseg == 4'b0101) begin 
            out = 7'b1101101;
        end
        else if(Lseg == 4'b0110) begin 
            out = 7'b1111101;
        end
        else if(Lseg == 4'b0111) begin 
            out = 7'b0000111;
        end
        else if(Lseg == 4'b1000) begin 
            out = 7'b1111111;
        end
        else if(Lseg == 4'b1001) begin 
            out = 7'b1101111;
        end
        else if(Lseg == 4'b1010) begin 
            out = 7'b1110111;
        end
        else if(Lseg == 4'b1011) begin 
            out = 7'b1111100;
        end
        else if(Lseg == 4'b1100) begin 
            out = 7'b0111001;
        end
        else if(Lseg == 4'b1101) begin 
            out = 7'b1011110;
        end
        else if(Lseg == 4'b1110) begin 
            out = 7'b1111001;
        end
        else if(Lseg == 4'b1111) begin 
            out = 7'b1110001;
        end
    end
    else begin
        Enable[1:0] = 2'b01;
        if(Rseg == 4'b0000) begin 
            out = 7'b0111111;    
        end 
        else if(Rseg == 4'b0001) begin 
            out = 7'b0000110;
        end
        else if(Rseg == 4'b0010) begin 
            out = 7'b1011011;
        end
        else if(Rseg == 4'b0011) begin 
            out = 7'b1001111;
        end
        else if(Rseg == 4'b0100) begin 
            out = 7'b1100110;
        end
        else if(Rseg == 4'b0101) begin 
            out = 7'b1101101;
        end
        else if(Rseg == 4'b0110) begin 
            out = 7'b1111101;
        end
        else if(Rseg == 4'b0111) begin 
            out = 7'b0000111;
        end
        else if(Rseg == 4'b1000) begin 
            out = 7'b1111111;
        end
        else if(Rseg == 4'b1001) begin 
            out = 7'b1101111;
        end
        else if(Rseg == 4'b1010) begin 
            out = 7'b1110111;
        end
        else if(Rseg == 4'b1011) begin 
            out = 7'b1111100;
        end
        else if(Rseg == 4'b1100) begin 
            out = 7'b0111001;
        end
        else if(Rseg == 4'b1101) begin 
            out = 7'b1011110;
        end
        else if(Rseg == 4'b1110) begin 
            out = 7'b1111001;
        end
        else if(Rseg == 4'b1111) begin 
            out = 7'b1110001;
        end
    end
end
endmodule