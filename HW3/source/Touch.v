module Touch(touch, N_xloc[3:0], N_yloc[3:0], S1_yloc[3:0], S2_yloc[3:0], S3_yloc[3:0]);
output reg touch;
input [3:0]N_xloc;
input [3:0]N_yloc;
input [3:0]S1_yloc;
input [3:0]S2_yloc;
input [3:0]S3_yloc;
always @(N_xloc or N_yloc or S1_yloc or S2_yloc or S3_yloc)
begin
    if(N_xloc == 2 && (N_yloc == S1_yloc || N_yloc == S2_yloc || N_yloc == S3_yloc))
        touch = 1'b1;
end
endmodule
