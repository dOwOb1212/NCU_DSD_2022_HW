module Top(Enable_L, Enable_R, Led, SevenSeg0, SevenSeg1, PS2_clk, clk, S1_i, S2_i, S3_i, S4_i, K_input, reset);
input PS2_clk, clk, S1_i, S2_i, S3_i, S4_i, reset, K_input;
output reg [3:0]Enable_L, Enable_R;
output reg [6:0]SevenSeg0, SevenSeg1;
output reg [15:0]Led;
State U1(State, S1, S2, S3, S4, reset, clk, drink);
DrinkMap U2(Enable_S, SevenSeg0_S, SevenSeg1_S, clk, drink, reset, State);
Pay U3(Enable_P, SevenSeg0_P, SevenSeg1_P, Paid_1, Paid_0, drink, reset, clk, State);
Done U4(Enable_D, Led_D, SevenSeg0_D, SevenSeg1_D, clk, reset, drink, Paid_1, Paid_0, State);
reg S1, S2, S3, S4, judge;
reg [20:0]debouncer;
reg [9:0]data;
reg [3:0]num;
reg flag;
wire [15:0]Led_D;
wire [6:0]SevenSeg1_S, SevenSeg0_S,
         SevenSeg1_P, SevenSeg0_P, SevenSeg1_D, SevenSeg0_D;
wire [7:0]drink;
wire [1:0]State;
wire [3:0]Enable_S, Enable_P, Enable_D;
reg [4:0]Paid_0, Paid_1;
assign drink = data[8:1];
always @(negedge PS2_clk or negedge reset)
begin
    if(!reset)
    begin
       num <= 4'd1;
       data <= 10'b0;
       flag <= 0;
    end
    else
    begin
        if(K_input == 0 && num == 4'd1)
        begin
            flag <= 1'b1;
            data[8:1] <= 0;
        end
        else
            flag <= flag;
        if(flag)
        begin 
            data[num] <= K_input;
            num <= num + 1;
            if(num == 4'd10)
            begin
                num <= 4'd1;
                flag <= 1'b0;
            end
        end
    end
end
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        S1 <= 1'b0;
        S2 <= 1'b0;
        S3 <= 1'b0;
        S4 <= 1'b0;
        debouncer <= 0;
        Paid_1 <= 5'd0;
        Paid_0 <= 5'd0;
        judge <= 0;
    end
    else
    begin
        debouncer <= debouncer + 1;
        if(debouncer[20])
        begin
            if(S1_i == 1'b1)
            begin
                S1 <= 1'b1;
                S2 <= 1'b0;
                S3 <= 1'b0;
                S4 <= 1'b0;            
            end
            else if(S2_i == 1'b1)
            begin
                S1 <= 1'b0;
                S2 <= 1'b1;
                S3 <= 1'b0;
                S4 <= 1'b0;
                if(!judge && Paid_0 == 5'd9 && Paid_1 == 5'd9)
                begin
                    Paid_1 <= 5'd9;
                    Paid_0 <= 5'd9;
                end
                else if(!judge && Paid_0 == 5'd9)
                begin
                    Paid_1 <= Paid_1 + 5'd1;
                    Paid_0 <= 5'd0;
                end
                else if(!judge)
                begin
                    Paid_1 <= Paid_1;
                    Paid_0 <= Paid_0 + 5'd1;
                end
                else
                begin
                    Paid_1 <= Paid_1;
                    Paid_0 <= Paid_0;
                end
                judge <= 1;
            end
            else if(S3_i == 1'b1)
            begin
                S1 <= 1'b0;
                S2 <= 1'b0;
                S3 <= 1'b1;
                S4 <= 1'b0;
                if(!judge && Paid_0 == 5'd9 && Paid_1 == 5'd9)
                begin
                    Paid_1 <= 5'd9;
                    Paid_0 <= 5'd9;
                end
                else if(!judge && Paid_1 == 5'd9)
                begin
                    Paid_1 <= 5'd9;
                    Paid_0 <= 5'd9;
                end
                else if(!judge)
                begin
                    Paid_1 <= Paid_1 + 5'd1;
                    Paid_0 <= Paid_0;
                end
                else
                begin
                    Paid_1 <= Paid_1;
                    Paid_0 <= Paid_0;
                end
                judge <= 1;
            end
            else if(S4_i == 1'b1)
            begin
                S1 <= 1'b0;
                S2 <= 1'b0;
                S3 <= 1'b0;
                S4 <= 1'b1;
                if(!judge && Paid_0 == 5'd9 && Paid_1 == 5'd9)
                begin
                    Paid_1 <= 5'd9;
                    Paid_0 <= 5'd9;
                end
                else if(!judge && Paid_1 > 5'd4)
                begin
                    Paid_1 <= 5'd9;
                    Paid_0 <= 5'd9;
                end
                else if(!judge)
                begin
                    Paid_1 <= Paid_1 + 5'd5;
                    Paid_0 <= Paid_0;
                end
                else
                begin
                    Paid_1 <= Paid_1;
                    Paid_0 <= Paid_0;
                end
                judge <= 1;
            end
            else
            begin
                S1 <= 1'b0;
                S2 <= 1'b0;
                S3 <= 1'b0;
                S4 <= 1'b0;
                debouncer <= 0;
                Paid_1 <= Paid_1;
                Paid_0 <= Paid_0;
                judge <= 0;
            end
        end
        else
        begin
            S1 <= S1;
            S2 <= S2;
            S3 <= S3;
            S4 <= S4;
            Paid_1 <= Paid_1;
            Paid_0 <= Paid_0;
        end
    end
end 
always @(State or SevenSeg1_S or SevenSeg0_S or Enable_S or SevenSeg1_P or SevenSeg0_P or Enable_P or SevenSeg0_D or SevenSeg1_D or Enable_D or Led_D)
begin
    if(State == 2'b00)
    begin
        Led = 16'b0;
        SevenSeg1 = 7'b0;
        SevenSeg0 = 7'b0;
        Enable_L = 2'b0;
        Enable_R = 2'b0;
    end
    else if(State == 2'b01)
    begin
        Led = 16'b0;
        SevenSeg1 = SevenSeg1_S;
        SevenSeg0 = SevenSeg0_S;
        Enable_L = Enable_S;
        Enable_R = Enable_S;
    end
    else if(State == 2'b10)
    begin
        Led = 16'b0;
        SevenSeg1 = SevenSeg1_P;
        SevenSeg0 = SevenSeg0_P;
        Enable_L = Enable_P;
        Enable_R = Enable_P;
    end
    else
    begin
        Led = Led_D;
        SevenSeg0 = SevenSeg0_D;
        SevenSeg1 = SevenSeg1_D;
        Enable_L = Enable_D;
        Enable_R = Enable_D;
    end
end
endmodule
