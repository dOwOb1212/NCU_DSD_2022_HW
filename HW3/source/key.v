module key(Key, N_xloc[3:0], N_yloc[3:0]);
output reg Key;
input [3:0]N_xloc;
input [3:0]N_yloc;
always @(N_xloc or N_yloc)
begin
    if(N_xloc == 0 && N_yloc == 5)
        Key = 1'b1;
    else
        Key = Key;
end
endmodule
