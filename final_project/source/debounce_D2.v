module debounce_D2(input pb_1,db_clk,reset,output reg pb_out);
reg flag;
always @(posedge  db_clk or negedge reset)
begin
    if(!reset)
    begin
       flag <= 0;
       pb_out <= 0;
    end
    else 
        if(!flag && pb_1)
        begin
            pb_out <= 1;
            flag <= 1;
        end
end
endmodule

