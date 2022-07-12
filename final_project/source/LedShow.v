module LedShow(LedOut, state, Led_clk, reset);
output reg [15:0] LedOut;
input [2:0] state;
input Led_clk, reset;
reg flag; 
reg [1:0]counter;
reg [15:0]pos;
always @(posedge Led_clk or negedge reset)
begin
    if(!reset)
    begin
        LedOut <= 16'b0;
        flag <= 0;
        counter <= 0;
        pos <= 16'h8000;
    end
    else
    begin
        if(state == 3'b011)
        begin
            if(!counter[1] && !flag)
                LedOut <= 16'hffff;
            else
                LedOut <= 16'h0000;
            flag <= ~flag;
            counter <= counter + 1;
        end
        else if(state == 3'b100)
        begin
            if(!flag)
            begin
                LedOut <= pos;
                pos <= pos >> 1;
            end
            if(pos == 16'h0000)
            begin
                LedOut <= 16'h0000;
                flag <= 1;
            end
        end
    end
end
endmodule
