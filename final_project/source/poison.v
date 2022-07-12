module poison(poison_x, poison_y, state, TouchPoison, clk, reset);
output reg [3:0] poison_x, poison_y;
input [2:0] state;
input TouchPoison, clk ,reset;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        poison_x <= 4'd5;
        poison_y <= 4'd3;
    end
    else
    begin
        if(state == 3'b010 && TouchPoison)
        begin
            poison_x <= 4'd13;
            poison_y <= 4'd13;
        end
        else 
        begin
            poison_x <= poison_x;
            poison_y <= poison_y;
        end
    end
end
endmodule
