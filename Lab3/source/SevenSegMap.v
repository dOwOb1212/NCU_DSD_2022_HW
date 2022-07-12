module SevenSegMap(Out, now);
input [4:0]now;
output reg [6:0]Out;
always @(*)
begin
    case(now)
        5'd0:   begin
            Out = 7'b0111111;
        end
        5'd1:   begin
            Out = 7'b0000110;
        end
        5'd2:   begin
            Out = 7'b1011011;
        end
        5'd3:   begin
            Out = 7'b1001111;
        end
        5'd4:   begin
            Out = 7'b1100110;
        end
        5'd5:   begin
            Out = 7'b1101101;
        end
        5'd6:   begin
            Out = 7'b1111101;
        end
        5'd7:   begin
            Out = 7'b0000111;
        end
        5'd8:   begin
            Out = 7'b1111111;
        end
        5'd9:   begin
            Out = 7'b1101111;
        end
        5'd10:   begin 
            Out = 7'b1011111; //A
        end
        5'd11:   begin
            Out = 7'b0111001; //C
        end
        5'd12:   begin
            Out = 7'b1111001; //E
        end
        5'd13:   begin
            Out = 7'b1110001; //F
        end
        5'd14:   begin
            Out = 7'b0000110; //I
        end
        5'd15:   begin
            Out = 7'b1010100; //N
        end
        5'd16:   begin
            Out = 7'b0111111; //0
        end
        5'd17:   begin
            Out = 7'b1110011; //P
        end
        5'd18:   begin
            Out = 7'b1010000; //R
        end
        5'd19:   begin
            Out = 7'b1101101; //S
        end
        5'd20:   begin
            Out = 7'b1111000; //T
        end
        default 
            Out = 7'b0000000; 
    endcase
end
endmodule
