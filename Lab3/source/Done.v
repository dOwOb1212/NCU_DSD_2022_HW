module Done(Enable, Led, SevenSeg0, SevenSeg1, clk, reset, drink, Paid_1, Paid_0, State);
input clk, reset;
input [1:0]State;
input [7:0]drink;
input [4:0]Paid_0, Paid_1;
output reg [15:0]Led;
output [6:0]SevenSeg0, SevenSeg1;
output reg [3:0]Enable;
parameter C = 8'h21;
parameter S = 8'h1B;
parameter F = 8'h2B;
parameter P = 8'h4D;
reg [4:0]Price_1, Price_0, right, left, Change_1, Change_0;
reg [1:0]flag;
reg Led_first_time;
reg Led_flag_1, Led_flag_0;
wire clkLed, clkSevenSeg;
reg [15:0]Led_0, Led_1, times;
Ledclk U00(clkLed, clk, reset);
SevenSegclk U01(clkSevenSeg, clk, reset);
SevenSegMap U1(SevenSeg1, right);
SevenSegMap U2(SevenSeg0, left);
always @(*)
begin
    if(drink == C)
    begin
        Price_1 = 5'd5;
        Price_0 = 5'd2;
    end
    else if(drink == S)
    begin
        Price_1 = 5'd8;
        Price_0 = 5'd3;
    end
    else if(drink == F)
    begin
        Price_1 = 5'd4;
        Price_0 = 5'd8;
    end
    else if(drink == P)
    begin
        Price_1 = 5'd5;
        Price_0 = 5'd0;
    end
end
always @(Price_0 or Price_1 or Paid_0 or Paid_1)
begin
    if(Paid_1 >= Price_1 && Paid_0 >= Price_0 )
    begin
        Change_0 = Paid_0 - Price_0;
        Change_1 = Paid_1 - Price_1;
    end
    else if(Paid_1 > Price_1 && Paid_0 < Price_0)
    begin
        Change_0 = Paid_0 + 5'd10 - Price_0;
        Change_1 = Paid_1 - Price_1 - 5'd1;
    end
    else
    begin
        Change_0 = 5'd0;
        Change_1 = 5'd0;
    end
end
always @(posedge clkSevenSeg or negedge reset)
begin
    if(!reset)
    begin
        right <= 5'd21;
        left <= 5'd21;
        flag <= 2'b0;
        Enable <= 4'b0;
    end
    else
    begin
        if(State == 2'b11)
        begin
            if((Paid_1 > Price_1) || (Paid_1 == Price_1 && Paid_0 >= Price_0))
            begin
                if(flag[1] == 1'b0)
                begin
                    if(Change_1 == 0)
                        left <= 5'd21;
                    else
                        left <= Change_1;
                    Enable <= 4'b1000;
                end
                else
                begin
                    left <= Change_0;
                    Enable <= 4'b0100;
                end
            end
            else
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
                            right <= Paid_1;
                            Enable <= 4'b0010;
                        end
                        2'b11:  begin
                            left <= 5'd16;
                            right <= Paid_0;
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
                            right <= Paid_1;
                            Enable <= 4'b0010;
                        end
                        2'b11:  begin
                            left <= 5'd14;
                            right <= Paid_0;
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
                            right <= Paid_1;
                            Enable <= 4'b0010;
                        end
                        2'b11:  begin
                            left <= 5'd15;
                            right <= Paid_0;
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
                            right <= Paid_1;
                            Enable <= 4'b0010;
                        end
                        2'b11:  begin
                            left <= 5'd17;
                            right <= Paid_0;
                            Enable <= 4'b0001;
                        end
                    endcase
                end
                else
                begin
                    right <= 5'd21;
                    left <= 5'd21;
                end
            end
            flag <= flag + 1;
        end
        else
        begin
            right <= 5'd21;
            left <= 5'd21;
        end
    end
end
always @(posedge clkLed or negedge reset)
begin
    if(!reset)
    begin
        Led_1 <= 16'h0000;
        Led_0 <= 16'h0000;
        Led_first_time <= 0;
        Led_flag_1 <= 0;
        Led_flag_0 <= 0;
        times <= 0;
    end
    else
    begin
        if(State == 2'b11)
        begin
            if(!Led_first_time)
            begin
                Led_first_time <= !Led_first_time;
                Led_1 <= 16'h8000;
                Led_0 <= 16'hffff;
            end
            else
            begin
                if(!Led_flag_1)
                    Led_1 <= Led_1 >> 1;
                if(!Led_flag_0)
                    Led_0 <= ~Led_0; 
                times <= times + 1;
                if((Paid_1 > Price_1) || (Paid_1 == Price_1 && Paid_0 >= Price_0))
                begin
                    if(times == 16'hf)
                    begin
                        Led_flag_1 <= 1;
                        Led_1 <= 16'b0;
                    end
                end
                else
                begin
                    if(times == 16'h5)
                    begin
                        Led_flag_0 <= 1;
                        Led_0 <= 16'b0;
                    end
                end
            end
        end
        else
        begin
            Led_1 <= 16'h0000;
            Led_0 <= 16'h0000;
        end
    end
end
always @(*)
begin
    if((Paid_1 > Price_1) || (Paid_1 == Price_1 && Paid_0 >= Price_0))
    begin
        Led = Led_1;
    end
    else
    begin
        Led = Led_0; 
    end                   
end
endmodule
