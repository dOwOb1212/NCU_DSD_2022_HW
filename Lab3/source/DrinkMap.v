module DrinkMap(Enable, SevenSeg0, SevenSeg1, clk, drink, reset, State);
input clk, reset;
input [7:0]drink;
input [1:0]State;
output [6:0]SevenSeg0, SevenSeg1;
output reg [3:0]Enable;
wire clkSevenSeg;
reg [1:0]flag;
reg [4:0]right, left;
parameter C = 8'h21;
parameter S = 8'h1B;
parameter F = 8'h2B;
parameter P = 8'h4D;
SevenSegMap U1(SevenSeg0, left);
SevenSegMap U2(SevenSeg1, right);
SevenSegclk U0(clkSevenSeg, clk, reset);
always @(posedge clkSevenSeg or negedge reset)
begin
    if(!reset)
    begin
        right <= 5'd21;
        left <= 5'd21;
        flag <= 2'b00;
        Enable <= 4'b0;
    end
    else
    begin
        if(State == 2'b01)
        begin
            if(drink == C)
            begin
                case(flag)
                    2'b00:  begin
                        left <= 5'd21;
                        right <= 5'd11;
                        Enable <= 4'b1000;
                    end
                    2'b01:  begin
                        left <= 5'd21;
                        right <= 5'd10;
                        Enable <= 4'b0100;
                    end
                    2'b10:  begin
                        left <= 5'd11;
                        right <= 5'd5;
                        Enable <= 4'b0010;
                    end
                    2'b11:  begin
                        left <= 5'd16;
                        right <= 5'd2;
                        Enable <= 4'b0001;
                    end
                endcase
            end
            else if(drink == S)
            begin
                case(flag)
                    2'b00:  begin
                        left <= 5'd19;
                        right <= 5'd20;
                        Enable <= 4'b1000;
                    end
                    2'b01:  begin
                        left <= 5'd17;
                        right <= 5'd12;
                        Enable <= 4'b0100;
                    end
                    2'b10:  begin
                        left <= 5'd18;
                        right <= 5'd8;
                        Enable <= 4'b0010;
                    end
                    2'b11:  begin
                        left <= 5'd14;
                        right <= 5'd3;
                        Enable <= 4'b0001;
                    end
                endcase
            end
            else if(drink == F)
            begin
                case(flag)
                    2'b00:  begin
                        left <= 5'd21;
                        right <= 5'd20;
                        Enable <= 4'b1000;
                    end
                    2'b01:  begin
                        left <= 5'd13;
                        right <= 5'd10;
                        Enable <= 4'b0100;
                    end
                    2'b10:  begin
                        left <= 5'd10;
                        right <= 5'd4;
                        Enable <= 4'b0010;
                    end
                    2'b11:  begin
                        left <= 5'd15;
                        right <= 5'd8;
                        Enable <= 4'b0001;
                    end
                endcase
            end
            else if(drink == P)
            begin
                case(flag)
                    2'b00:  begin
                        left <= 5'd21;
                        right <= 5'd19;
                        Enable <= 4'b1000;
                    end
                    2'b01:  begin
                        left <= 5'd17;
                        right <= 5'd14;
                        Enable <= 4'b0100;
                    end
                    2'b10:  begin
                        left <= 5'd12;
                        right <= 5'd5;
                        Enable <= 4'b0010;
                    end
                    2'b11:  begin
                        left <= 5'd17;
                        right <= 5'd0;
                        Enable <= 4'b0001;
                    end
                endcase
            end
            else
	        begin
        	    right <= 5'd21;
           	    left <= 5'd21;
            end
        	flag <= flag + 1'b1;
        end
        else
        begin
            right <= 5'd23;
            left <= 5'd23;
        end
    end
end
endmodule
