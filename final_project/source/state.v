module state(NS, reset, clk, start, Long_enough, TouchEdge, TouchPoison, TouchSelf, Touch_I_Fruit, Touchbarrier, countDown);
input reset, clk, start, Long_enough, TouchEdge, TouchPoison, TouchSelf, Touch_I_Fruit, Touchbarrier;
input [2:0] countDown;
output reg [2:0]NS;
reg [2:0]CS;
parameter Init = 3'b000, Basic = 3'b001, Invincible = 3'b010, Dead = 3'b011, Win = 3'b100;
always @(posedge clk or posedge reset) begin
    if (!reset)
        CS <= Init;
    else
        CS <= NS;
end
always @(posedge  clk or negedge reset) begin
    if(!reset)
        NS <= Init;
    else
    begin
        case (CS)
            Init: begin
                if(start)
                    NS <= Basic;
                else 
                    NS <= CS;
            end
            Basic: begin
                if(TouchPoison || TouchEdge || TouchSelf || Touchbarrier)
                    NS <= Dead;
                else if(Touch_I_Fruit)
                    NS <= Invincible;
                else if(Long_enough)
                    NS <= Win;
                else
                    NS <= CS;
            end
            Invincible: begin
                if(Long_enough)
                    NS <= Win;
                if(countDown == 0)
                begin
                    NS <= Basic;
                end
                else if(TouchEdge || TouchSelf || Touchbarrier)
                    NS <= Dead;
                else
                    NS <= CS;
            end
            Dead: begin
                    NS <= Dead;
            end
            Win: begin
                    NS <= Win;
            end
            default: begin
                    NS <= CS;
            end
        endcase
    end
end
endmodule
