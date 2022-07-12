module state(NS, reset, clk, TouchFruit, TouchGhost);
input reset, clk, TouchFruit, TouchGhost;
output reg [1:0]NS;
reg [1:0]CS;
parameter Init = 2'b00, Dead = 2'b01, Win = 2'b10;
always @(posedge clk or posedge reset) begin
    if (!reset)
        CS <= Init;
    else
        CS <= NS;
end
always @(*) begin
    NS = Init;
    case (CS)
        Init: begin
            if(TouchGhost)
                NS = Dead;
            else if(TouchFruit)
                NS = Win;
            else
                NS = CS;
        end
        Dead: begin
            
                NS = Dead;
        end
        Win: begin
            
                NS = Win;
        end
        default: begin
                
                NS = CS;
        end
    endcase
end
endmodule
