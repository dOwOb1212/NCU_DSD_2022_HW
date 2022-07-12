module Goal(out, N_xloc[3:0], N_yloc[3:0]);
output reg out;
input [3:0]N_xloc;
input [3:0]N_yloc;
always @(N_xloc or N_yloc)
begin
    if(N_xloc == 4'b0111 && N_yloc == 4'b1011)
        out = 1'b1;
    else
        out = 1'b0;
end
endmodule
