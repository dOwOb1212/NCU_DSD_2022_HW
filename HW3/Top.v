module Top(CLK, RESET, START, OnElevation, Score, Touch, Drop, Key, NinjaX, NinjaY, Elevator1Y, Elevator2Y, Elevator3Y, Shuriken1Y, Shuriken2Y, Shuriken3Y, GoLeft, GoRight, Chance);
output [3:0] NinjaX, NinjaY;
output [1:0] Chance;
output [3:0] Shuriken1Y, Shuriken2Y, Shuriken3Y, Elevator1Y, Elevator2Y, Elevator3Y;
output reg Touch, Drop, Key, OnElevation;
input CLK, RESET, GoLeft, GoRight, START;
output reg [6:0] Score;
wire [1:0]State;
wire [1:0]NS;
parameter Stop = 2'b00, Movement = 2'b01 , Elevation = 2'b10, Die = 2'b11;
ninja U0(NinjaX, NinjaY, Chance, CLK, RESET, GoLeft, GoRight, Touch, Drop, OnElevation);
state U1(NS, State, RESET, CLK, Chance, Touch, Drop, OnElevation, START);
elevator U2(Elevator1Y, Elevator2Y, Elevator3Y, CLK, RESET, NS);
shuriken U3(CLK, RESET, NS, Shuriken1Y, Shuriken2Y, Shuriken3Y);
always @(*) begin: 
    if (RESET) begin
        OnElevation <= 0; Score <= 0; Touch <= 0; Drop <= 0; Key <= 0;
    end
    else begin
        if (Key) begin
            if ({NinjaX, NinjaY} == {4'd7, 4'd11})
                Score <= 100;
            else
                Score <= 50;
        end
        else
            Score <= 0;
        case (State)
        Stop: begin
            OnElevation <= 0; Touch <= 0; Drop <= 0;
        end
        Movement: begin
            if ((NinjaX == 2 && GoRight) || (NinjaX == 5 && GoLeft))
            case (NinjaY)
                Elevator1Y, Elevator1Y + 1, Elevator2Y, Elevator2Y + 1, Elevator3Y, Elevator3Y + 1: begin
                    OnElevation <= 1; Drop <= 0;
                end
            default: begin
                OnElevation <= 0; Drop <= 1;
            end
            endcase
            else begin
                OnElevation <= 0; Drop <= 0;
            end
            if (NinjaX == 2)
                case (NinjaY)
                    Shuriken1Y, Shuriken2Y, Shuriken3Y: Touch <= 1;
                default: Touch <= 0;
                endcase
            else
                Touch <= 0;
            if ({NinjaX, NinjaY} == {4'd0, 4'd5})
                Key <= 1;
        end
        Elevation: begin
            Touch <= 0;
            if ((NinjaX == 3 && GoLeft) || (NinjaX == 4 && GoRight)) begin
                OnElevation <= 0;
                if (NinjaY == 5 || NinjaY == 11)
                    Drop <= 0;
                else	
                    Drop <= 1;
            end
            else begin
                OnElevation <= 1; Drop <= 0;
            end
        end
        Die: begin
            OnElevation <= 0; Touch <= 0; Drop <= 0;
        end
        endcase
    end
end
endmodule
