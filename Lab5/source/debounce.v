module debounce(clk, sig_in, sig_out, reset);
output reg sig_out;
input sig_in, clk, reset;
reg [20:0] counter;
reg [2:0] Wait;
reg flag;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        sig_out <= 1'b0;
        Wait <= 7'd0;
        counter <= 21'b0;
        flag <= 1'b0;
    end
    else
    begin
        if(sig_in && !flag)
        begin
            counter <= counter + 1;
            if(counter[20])
            begin
                Wait <= Wait + 1;
                if(Wait == 3'd5)
                begin
                    sig_out <= sig_in;
                end
                counter <= 21'b0;
            end
        end    
        if(sig_out)
        begin
            sig_out <= 0;
            flag <= 1'b1;
        end
        if(!sig_in)
            flag <= 0;
    end       
end
endmodule
