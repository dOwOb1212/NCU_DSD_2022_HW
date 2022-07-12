module State(state[1:0], N_xloc[3:0], N_yloc[3:0], chance[1:0], start, OnElevator, touch, drop, clk, reset, goRight, goLeft);
output [1:0]state;
output reg [3:0]N_xloc;
output reg [3:0]N_yloc;
output reg [1:0]chance = 2'b10;
input start, OnElevator, touch, drop, clk, reset;
input goRight, goLeft;
reg [1:0]nowState;
reg [1:0]nextState;
reg [1:0]Stop = 2'b00;
reg [1:0]Movement = 2'b01;
reg [1:0]Elevation = 2'b10;
reg [1:0]Die = 2'b11;
assign state = nowState;
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        nowState <= Stop;
        N_xloc <= 4'b0110;
        N_yloc <= 4'b0000;
    end
    else
    begin
        nowState <= nextState;
        case(nextState)
            Stop:
            begin
                N_xloc <= N_xloc;
                N_yloc <= N_yloc;
            end
            Movement:
            begin
                if(goRight)
                begin
                   N_xloc <= N_xloc + 1; 
                end
                else if(goLeft)
                begin
                   N_xloc <= N_xloc - 1; 
                end
                else
                begin
                    N_xloc <= N_xloc;
                end
            end
            Elevation:
            begin
                if(goRight)
                begin
                    N_xloc <= N_xloc + 1; 
                end
                else if(goLeft)
                begin
                    N_xloc <= N_xloc - 1; 
                end
                else
                begin
                    N_xloc <= N_xloc;
                end
            end
            Die:
            begin
                N_xloc <= N_xloc;
                N_yloc <= N_yloc;
                chance <= chance - 1;
            end
        endcase    
        if(OnElevator)
            N_yloc <= N_yloc + 1;  
        if(N_yloc == 4'b1011)
            N_yloc <= 4'b000;  
    end
end
always @(start or OnElevator or touch or drop or chance or nowState)
begin
    case(nowState)
        Stop:
        begin
            if(start)
                nextState = Movement;
            else
                nextState = Stop;
        end
        Movement:
        begin
            if(OnElevator)
                nextState = Elevation;
            else if(touch || drop)
                nextState = Die;
        end
        Elevation:
        begin
            if(~OnElevator)
                nextState = Movement;
            else if(touch || drop)
                nextState = Die;
        end
        Die:
        begin
            if(chance != 2'b00)
                nextState = Movement;
            else
                nextState = Stop;
        end
    endcase
end
endmodule
