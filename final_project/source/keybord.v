module keyboard(
input   clk_in,
input   RESET,
input   key_clk,
input   key_data,
output	reg w,
output	reg a,
output	reg s,
output	reg d,
output  reg q,
output  reg key_state
);
    reg	key_clk_r0 = 1'b1,key_clk_r1 = 1'b1; 
    reg	key_data_r0 = 1'b1,key_data_r1 = 1'b1;
    
    always @ (posedge clk_in or negedge RESET) begin
        if(!RESET) begin
            key_clk_r0 <= 1'b1;
            key_clk_r1 <= 1'b1;
            key_data_r0 <= 1'b1;
            key_data_r1 <= 1'b1;
        end 
        else begin
            key_clk_r0 <= key_clk;
            key_clk_r1 <= key_clk_r0;
            key_data_r0 <= key_data;
            key_data_r1 <= key_data_r0;
        end
    end
 
    wire	key_clk_neg = key_clk_r1 & (~key_clk_r0); 
    reg	[3:0]cnt; 
    reg	[7:0]temp_data;
    
    always @ (posedge clk_in or negedge RESET) begin
        if(!RESET) begin
            cnt <= 4'd0;
            temp_data <= 8'd0;
        end 
        else if(key_clk_neg) begin 
            if(cnt >= 4'd10) 
              cnt <= 4'd0;
            else 
              cnt <= cnt + 1'b1;
        case (cnt)
            4'd0: ;
            4'd1: temp_data[0] <= key_data_r1;
            4'd2: temp_data[1] <= key_data_r1;
            4'd3: temp_data[2] <= key_data_r1;
            4'd4: temp_data[3] <= key_data_r1;
            4'd5: temp_data[4] <= key_data_r1;
            4'd6: temp_data[5] <= key_data_r1;
            4'd7: temp_data[6] <= key_data_r1;
            4'd8: temp_data[7] <= key_data_r1;
            4'd9: ;
            4'd10:;
            default: ;
        endcase
        end
    end
 
    reg key_break = 1'b0;   
    reg	[7:0] key_byte = 1'b0;

    always @ (posedge clk_in or negedge RESET) begin 
        if(!RESET) begin
            key_break <= 1'b0;
            key_state <= 1'b0;
            key_byte <= 1'b0;
        end 
	    else if(cnt==4'd10 && key_clk_neg)
            begin 
                if(temp_data == 8'hf0)
                    key_break <= 1'b1;
                else if(!key_break) begin
                    key_state <= 1'b1;
                    key_byte <= temp_data; 
                end 
                else begin
                    key_state <= 1'b0;
                    key_break <= 1'b0;
            end
        end
    end

   always @ (key_byte) begin
       case (key_byte)
          8'h1D: begin
                 w = 1'b1;a = 0;s = 0;d = 0;q =0;
                 end  //W
          8'h1C: begin 
                 w = 0;a = 1'b1;s = 0;d = 0;q =0;
                 end  //A
          8'h1B: begin
                 w = 0;a = 0;s = 1'b1;d = 0;q =0;
                 end  //S
          8'h23: begin
                 w = 0;a = 0;s = 0;d = 1'b1;q =0;
                 end  //D
          8'h15: begin
                 w = 0;a = 0;s = 0;d = 0;q = 1'b1;
                 end  //Q
          default: begin w = 0;a = 0;s = 0;d = 0;q =0; end
       endcase
    end
endmodule