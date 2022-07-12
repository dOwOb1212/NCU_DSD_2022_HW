module SevenSegMap(Out, now);
input [3:0]now;
output reg [6:0]Out;
always @(*)
begin
    case(now)
        4'd0:   begin
            Out = 7'b0111111;
        end
        4'd1:   begin
            Out = 7'b0000110;
        end
        4'd2:   begin
            Out = 7'b1011011;
        end
        4'd3:   begin
            Out = 7'b1001111;
        end
        4'd4:   begin
            Out = 7'b1100110;
        end
        4'd5:   begin
            Out = 7'b1101101;
        end
        4'd6:   begin
            Out = 7'b1111101;
        end
        4'd7:   begin
            Out = 7'b0000111;
        end
        4'd8:   begin
            Out = 7'b1111111;
        end
        4'd9:   begin
            Out = 7'b1101111;
        end
        default
            Out = 7'b0000000;
    endcase
end
endmodule
