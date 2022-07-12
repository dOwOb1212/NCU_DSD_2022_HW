module LedMap(LedOut, State, L_clk, reset);
output reg [15:0] LedOut;
input [1:0] State;
input L_clk, reset;
reg [2:0] times;
always @(posedge L_clk or negedge reset)
begin
    if(!reset)
    begin
        times <= 3'd0;
        LedOut <= 16'd0;
    end
    else
    begin
        if(State == 2'b01)
        begin
            times <= times + 3'd1;
            case(times)
                3'b000:
                    LedOut <= 16'haaaa;
                3'b001:
                    LedOut <= 16'h5554;
                3'b010:
                    LedOut <= 16'h2aa8;
                3'b011:
                    LedOut <= 16'h1550;
                3'b100:
                    LedOut <= 16'h0aa0;
                3'b101:
                    LedOut <= 16'h0540;
                3'b110:
                    LedOut <= 16'h0280;
                3'b111:
                    LedOut <= 16'h0100;
            endcase
        end
    end
end
endmodule
