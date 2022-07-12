module state(NS, CS, reset, clk, chance, touch, drop, onelevation, start);
input clk, reset, start, onelevation, touch, drop, chance;
output reg [1:0]CS;
output reg [1:0]NS;
parameter Stop = 2'b00, Movement = 2'b01 , Elevation = 2'b10, Die = 2'b11;
always @(posedge clk or posedge reset) begin: SEQ
    if (reset)
        CS <= Stop;
        else
        CS <= NS;
    end
always @(*) begin: COMB
    NS = Stop;
    case (CS)
        Stop: begin
            if (start)
            NS = Movement;
        else
            NS = Stop;
        end
        Movement: begin
            if (touch || drop)
                NS = Die;
            else if (onelevation)
                NS = Elevation;
            else
                NS = Movement;
        end
        Elevation: begin
            if (touch || drop)
                NS = Die;
            else if (!onelevation)
                NS = Movement;
            else
                NS = Elevation;
            end
        Die: begin
            if (chance != 0)
                NS = Movement;
            else
            NS = Stop;
        end
    endcase
end
endmodule