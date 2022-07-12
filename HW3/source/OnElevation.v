module OnElevation(out, N_xloc[3:0], N_yloc[3:0], E_yloc[3:0], goRight, goLeft);
output reg out = 1'b0;
input [3:0]N_xloc;
input [3:0]N_yloc;
input [3:0]E_yloc;
input goRight, goLeft;
always @(N_xloc[3:0] or N_yloc[3:0] or E_yloc[3:0])
begin
    if(goRight)
    begin
        if(N_xloc == 4'b0010 && N_yloc == E_yloc)
        begin
            out = 1'b1;
        end
        else
        begin
            out = 1'b0;
        end
    end
    else if(goLeft)
    begin
        if(N_xloc == 4'b0101 && N_yloc == E_yloc)
        begin
            out = 1'b1;
        end
        else
        begin
            out = 1'b0;
        end
    end
end
endmodule
