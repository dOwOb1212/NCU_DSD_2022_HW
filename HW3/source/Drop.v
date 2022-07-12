module Drop(drop, N_xloc[3:0], N_yloc[3:0], goRight, goLeft, E1_yloc[3:0], E2_yloc[3:0], E3_yloc[3:0]);
output reg drop = 1'b0;
input [3:0]N_xloc;
input [3:0]N_yloc;
input goRight, goLeft;
input [3:0]E1_yloc;
input [3:0]E2_yloc;
input [3:0]E3_yloc;
always @(N_xloc or N_yloc or goRight or goLeft)
begin
    if(N_xloc == 4'b0011 && goLeft && (N_yloc == E1_yloc || N_yloc == E2_yloc || N_yloc == E3_yloc) && N_yloc != 4'b0101)
    begin
        drop = 1'b1;
    end
    else if(N_xloc == 4'b0100 && goRight && N_yloc != 4'b000 && (N_yloc == E1_yloc || N_yloc == E2_yloc || N_yloc == E3_yloc))
    begin
        drop = 1'b1;
    end
    else if(N_xloc == 4'b0100 && goRight && N_yloc != 4'b1011 && (N_yloc == E1_yloc || N_yloc == E2_yloc || N_yloc == E3_yloc))
    begin
        drop = 1'b1;
    end
    else if(N_xloc == 4'b0101 && goLeft && (N_yloc != E1_yloc || N_yloc != E2_yloc ||N_yloc != E3_yloc))
    begin
        drop = 1'b1;
    end
    else if(N_xloc == 4'b0010 && goRight && (N_yloc != E1_yloc || N_yloc != E2_yloc ||N_yloc != E3_yloc))
    begin
        drop = 1'b1;
    end
    else if(N_xloc == 4'b0101 && goLeft && (N_yloc != E1_yloc || N_yloc != E2_yloc ||N_yloc != E3_yloc))
    begin
        drop = 1'b1;
    end
    else 
    begin
        drop = 1'b0;
    end
end
endmodule
