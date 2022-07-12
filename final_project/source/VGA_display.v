module VGA_display(pclk, clk, rst, start, hsync, vsync, vga_r, vga_g, vga_b, N_fruit_x, N_fruit_y, fruit, snake_y_i, snake_x_i, I_fruit_x, I_fruit_y, poison_x, poison_y, state, flag);
input   clk, flag, pclk;
input   rst;
input   start, fruit;
input   [2:0] state;
input   [3:0] N_fruit_x, N_fruit_y, I_fruit_y, I_fruit_x, poison_x, poison_y;
input   [39:0]snake_y_i, snake_x_i; 
output  hsync,vsync;
output  [3:0] vga_r, vga_g, vga_b;
wire     [3:0]snake_y[9:0], snake_x[9:0];
assign {{snake_x[9]},{snake_x[8]},{snake_x[7]},{snake_x[6]},{snake_x[5]},{snake_x[4]},{snake_x[3]},{snake_x[2]},{snake_x[1]},{snake_x[0]}} = snake_x_i; 
assign {{snake_y[9]},{snake_y[8]},{snake_y[7]},{snake_y[6]},{snake_y[5]},{snake_y[4]},{snake_y[3]},{snake_y[2]},{snake_y[1]},{snake_y[0]}} = snake_y_i;

wire    valid;
wire [9:0] h_cnt,v_cnt;
reg [11:0] vga_data;
wire [11:0] N_fruit_rom_dout_5, N_fruit_rom_dout_10, I_fruit_rom_dout, poison_rom_dout, barrier_rom_dout_1, barrier_rom_dout_2, barrier_rom_dout_3, barrier_rom_dout_4;
reg [11:0] N_fruit_rom_addr_5, N_fruit_rom_addr_10, I_fruit_rom_addr, poison_rom_addr, barrier_rom_addr_1, barrier_rom_addr_2, barrier_rom_addr_3, barrier_rom_addr_4;
wire [9:0] N_fruit_x_pixel, N_fruit_y_pixel, I_fruit_x_pixel, I_fruit_y_pixel, poison_x_pixel, poison_y_pixel;
wire snake_area[9:0], N_fruit_area_5, N_fruit_area_10, I_fruit_area, poison_area, barrier_area[3:0], edge_area;
wire [9:0] snake_x_pixel[9:0], snake_y_pixel[9:0];

parameter [9:0] barrier_x1 = 10'd220, barrier_x2 = 10'd270, barrier_x3 = 10'd320, barrier_x4 = 10'd370, barrier_y = 10'd140;
parameter [9:0] logo_length=10'd50;
parameter [9:0] logo_height=10'd50;
parameter [9:0] center_x=10'd62, center_y=10'd32;

assign snake_x_pixel[9] = snake_x[9]*50+8+center_x; 
assign snake_y_pixel[9] = snake_y[9]*50+8+center_y; 
assign snake_x_pixel[8] = snake_x[8]*50+8+center_x; 
assign snake_y_pixel[8] = snake_y[8]*50+8+center_y; 
assign snake_x_pixel[7] = snake_x[7]*50+8+center_x; 
assign snake_y_pixel[7] = snake_y[7]*50+8+center_y; 
assign snake_x_pixel[6] = snake_x[6]*50+8+center_x; 
assign snake_y_pixel[6] = snake_y[6]*50+8+center_y; 
assign snake_x_pixel[5] = snake_x[5]*50+8+center_x; 
assign snake_y_pixel[5] = snake_y[5]*50+8+center_y; 
assign snake_x_pixel[4] = snake_x[4]*50+8+center_x; 
assign snake_y_pixel[4] = snake_y[4]*50+8+center_y; 
assign snake_x_pixel[3] = snake_x[3]*50+8+center_x; 
assign snake_y_pixel[3] = snake_y[3]*50+8+center_y; 
assign snake_x_pixel[2] = snake_x[2]*50+8+center_x; 
assign snake_y_pixel[2] = snake_y[2]*50+8+center_y; 
assign snake_x_pixel[1] = snake_x[1]*50+8+center_x; 
assign snake_y_pixel[1] = snake_y[1]*50+8+center_y; 
assign snake_x_pixel[0] = snake_x[0]*50+8+center_x; 
assign snake_y_pixel[0] = snake_y[0]*50+8+center_y;
assign N_fruit_x_pixel = N_fruit_x*50+8+center_x; 
assign N_fruit_y_pixel = N_fruit_y*50+8+center_y;
assign I_fruit_x_pixel = I_fruit_x*50+8+center_x;
assign I_fruit_y_pixel = I_fruit_y*50+8+center_y;
assign poison_x_pixel = poison_x*50+8+center_x;
assign poison_y_pixel = poison_y*50+8+center_y;




N_fruit_rom_5 u1 (
      .clka(pclk),    
      .addra(N_fruit_rom_addr_5),  
      .douta(N_fruit_rom_dout_5)  
    );
N_fruit_rom_10 u2 (
      .clka(pclk),    
      .addra(N_fruit_rom_addr_10),  
      .douta(N_fruit_rom_dout_10)  
    );

I_fruit_rom u3 (
      .clka(pclk),    
      .addra(I_fruit_rom_addr),  
      .douta(I_fruit_rom_dout)  
    );
    
barrier_rom u00 (
      .clka(pclk),    
      .addra(barrier_rom_addr_1),  
      .douta(barrier_rom_dout_1)  
    );
barrier_rom u01 (
      .clka(pclk),    
      .addra(barrier_rom_addr_2),  
      .douta(barrier_rom_dout_2)  
    );
barrier_rom u02 (
      .clka(pclk),    
      .addra(barrier_rom_addr_3),  
      .douta(barrier_rom_dout_3)  
    );
barrier_rom u03 (
      .clka(pclk),    
      .addra(barrier_rom_addr_4),  
      .douta(barrier_rom_dout_4)  
    );

poison_rom u4 (
      .clka(pclk),    
      .addra(poison_rom_addr),  
      .douta(poison_rom_dout)  
    );

SyncGeneration_D2 u5 (
        .pclk(pclk),
        .reset(rst),
        .hSync(hsync),
        .vSync(vsync),
        .dataValid(valid),
        .hDataCnt(h_cnt),
        .vDataCnt(v_cnt)
    );

assign snake_area[9] = ((v_cnt >= snake_y_pixel[9]) & (v_cnt <= snake_y_pixel[9] + logo_height - 1) & (h_cnt >= snake_x_pixel[9]) & (h_cnt <= snake_x_pixel[9] + logo_length - 1));
assign snake_area[8] = ((v_cnt >= snake_y_pixel[8]) & (v_cnt <= snake_y_pixel[8] + logo_height - 1) & (h_cnt >= snake_x_pixel[8]) & (h_cnt <= snake_x_pixel[8] + logo_length - 1));
assign snake_area[7] = ((v_cnt >= snake_y_pixel[7]) & (v_cnt <= snake_y_pixel[7] + logo_height - 1) & (h_cnt >= snake_x_pixel[7]) & (h_cnt <= snake_x_pixel[7] + logo_length - 1));
assign snake_area[6] = ((v_cnt >= snake_y_pixel[6]) & (v_cnt <= snake_y_pixel[6] + logo_height - 1) & (h_cnt >= snake_x_pixel[6]) & (h_cnt <= snake_x_pixel[6] + logo_length - 1));
assign snake_area[5] = ((v_cnt >= snake_y_pixel[5]) & (v_cnt <= snake_y_pixel[5] + logo_height - 1) & (h_cnt >= snake_x_pixel[5]) & (h_cnt <= snake_x_pixel[5] + logo_length - 1));
assign snake_area[4] = ((v_cnt >= snake_y_pixel[4]) & (v_cnt <= snake_y_pixel[4] + logo_height - 1) & (h_cnt >= snake_x_pixel[4]) & (h_cnt <= snake_x_pixel[4] + logo_length - 1));
assign snake_area[3] = ((v_cnt >= snake_y_pixel[3]) & (v_cnt <= snake_y_pixel[3] + logo_height - 1) & (h_cnt >= snake_x_pixel[3]) & (h_cnt <= snake_x_pixel[3] + logo_length - 1));
assign snake_area[2] = ((v_cnt >= snake_y_pixel[2]) & (v_cnt <= snake_y_pixel[2] + logo_height - 1) & (h_cnt >= snake_x_pixel[2]) & (h_cnt <= snake_x_pixel[2] + logo_length - 1));
assign snake_area[1] = ((v_cnt >= snake_y_pixel[1]) & (v_cnt <= snake_y_pixel[1] + logo_height - 1) & (h_cnt >= snake_x_pixel[1]) & (h_cnt <= snake_x_pixel[1] + logo_length - 1));
assign snake_area[0] = ((v_cnt >= snake_y_pixel[0]) & (v_cnt <= snake_y_pixel[0] + logo_height - 1) & (h_cnt >= snake_x_pixel[0]) & (h_cnt <= snake_x_pixel[0] + logo_length - 1));
assign N_fruit_area_5 = ((v_cnt >= N_fruit_y_pixel) & (v_cnt <= N_fruit_y_pixel + logo_height - 1) & (h_cnt >= N_fruit_x_pixel) & (h_cnt <= N_fruit_x_pixel + logo_length - 1));
assign N_fruit_area_10 = ((v_cnt >= N_fruit_y_pixel) & (v_cnt <= N_fruit_y_pixel + logo_height - 1) & (h_cnt >= N_fruit_x_pixel) & (h_cnt <= N_fruit_x_pixel + logo_length - 1));
assign poison_area = ((v_cnt >= poison_y_pixel) & (v_cnt <= poison_y_pixel + logo_height - 1) & (h_cnt >= poison_x_pixel) & (h_cnt <= poison_x_pixel + logo_length - 1));
assign edge_area = ((h_cnt < 70 & h_cnt >= 62 & v_cnt >= 32 & v_cnt < 448) | (h_cnt < 578 & h_cnt >= 62 & v_cnt >= 440 & v_cnt < 448) | (h_cnt >= 570 & h_cnt < 578 & v_cnt < 448 & v_cnt >= 32) | (h_cnt >= 62 & h_cnt < 578 & v_cnt >= 32 & v_cnt < 40));
assign black_area = ((h_cnt < 62) | (h_cnt >= 578) |(v_cnt < 32) |(v_cnt >= 448));
assign I_fruit_area = ((v_cnt >= I_fruit_y_pixel) & (v_cnt <= I_fruit_y_pixel + logo_height - 1) & (h_cnt >= I_fruit_x_pixel) & (h_cnt <= I_fruit_x_pixel + logo_length - 1));
assign barrier_area[3] = ((v_cnt >= barrier_y) & (v_cnt <= barrier_y + logo_height - 1) & (h_cnt >= barrier_x1) & (h_cnt <= barrier_x1 + logo_length - 1));
assign barrier_area[2] = ((v_cnt >= barrier_y) & (v_cnt <= barrier_y + logo_height - 1) & (h_cnt >= barrier_x2) & (h_cnt <= barrier_x2 + logo_length - 1));
assign barrier_area[1] = ((v_cnt >= barrier_y) & (v_cnt <= barrier_y + logo_height - 1) & (h_cnt >= barrier_x3) & (h_cnt <= barrier_x3 + logo_length - 1));
assign barrier_area[0] = ((v_cnt >= barrier_y) & (v_cnt <= barrier_y + logo_height - 1) & (h_cnt >= barrier_x4) & (h_cnt <= barrier_x4 + logo_length - 1));


always @(posedge pclk or negedge rst)
begin: logo_display
    if (!rst) begin
         N_fruit_rom_addr_5<=12'd0;
         N_fruit_rom_addr_10<=12'd0;
         I_fruit_rom_addr<=12'd0;
         poison_rom_addr<=12'd0;
         barrier_rom_addr_1<=12'd0;
         barrier_rom_addr_2<=12'd0;
         barrier_rom_addr_3<=12'd0;
         barrier_rom_addr_4<=12'd0;
         vga_data <= 12'd0;
    end
    else
    begin
        if(valid == 1'b1)
        begin
            if (snake_area[9] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[8] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[7] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[6] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[5] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[4] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[3] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[2] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[1] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if (snake_area[0] == 1'b1 && (flag || state != 3'b010))
            begin
               vga_data <= 12'hf80;
            end
            else if(N_fruit_area_5 == 1'b1 && !fruit)
            begin
               N_fruit_rom_addr_5 <= N_fruit_rom_addr_5 + 12'd1;
               vga_data <= N_fruit_rom_dout_5;
            end
            else if(N_fruit_area_10 == 1'b1 && fruit)
            begin
               N_fruit_rom_addr_10 <= N_fruit_rom_addr_10 + 12'd1;
               vga_data <= N_fruit_rom_dout_10;
            end
            else if(I_fruit_area == 1'b1)
            begin
               I_fruit_rom_addr <= I_fruit_rom_addr + 12'd1;
               vga_data <= I_fruit_rom_dout;
            end
            else if(barrier_area[3] == 1'b1)
            begin
                barrier_rom_addr_1 <= barrier_rom_addr_1 + 12'd1;
                vga_data <= barrier_rom_dout_1;
            end
            else if(barrier_area[2] == 1'b1)
            begin
                barrier_rom_addr_2 <= barrier_rom_addr_2 + 12'd1;
                vga_data <= barrier_rom_dout_2;
            end
            else if(barrier_area[1] == 1'b1)
            begin
                barrier_rom_addr_3 <= barrier_rom_addr_3 + 12'd1;
                vga_data <= barrier_rom_dout_3;
            end
            else if(barrier_area[0] == 1'b1)
            begin
                barrier_rom_addr_4 <= barrier_rom_addr_4 + 12'd1;
                vga_data <= barrier_rom_dout_4;
            end
            else if(poison_area == 1'b1)
            begin
                poison_rom_addr <= poison_rom_addr + 12'd1;
                vga_data <= poison_rom_dout;
            end
            else if(edge_area == 1'b1)
            begin
                vga_data <= 12'h00f;
            end
            else if(black_area == 1'b1)
            begin
                vga_data <= 12'h000;
            end
            else
            begin
                N_fruit_rom_addr_5<=N_fruit_rom_addr_5;
                N_fruit_rom_addr_10<=N_fruit_rom_addr_10;
                I_fruit_rom_addr<=I_fruit_rom_addr;
                poison_rom_addr<=poison_rom_addr;
                barrier_rom_addr_1<=barrier_rom_addr_1;
                barrier_rom_addr_2<=barrier_rom_addr_2;
                barrier_rom_addr_3<=barrier_rom_addr_3;
                barrier_rom_addr_4<=barrier_rom_addr_4;
                vga_data <= 12'hfff;
            end
        end
        else begin
            vga_data <= 12'h000;
            if (v_cnt == 0)
            begin
                N_fruit_rom_addr_5<=12'd0;
                N_fruit_rom_addr_10<=12'd0;
                I_fruit_rom_addr<=12'd0;
                poison_rom_addr<=12'd0;
                barrier_rom_addr_1<=12'd0;
                barrier_rom_addr_2<=12'd0;
                barrier_rom_addr_3<=12'd0;
                barrier_rom_addr_4<=12'd0;
            end
            else
            begin
                N_fruit_rom_addr_5<=N_fruit_rom_addr_5;
                N_fruit_rom_addr_10<=N_fruit_rom_addr_10;
                I_fruit_rom_addr<=I_fruit_rom_addr;
                poison_rom_addr<=poison_rom_addr;
                barrier_rom_addr_1<=barrier_rom_addr_1;
                barrier_rom_addr_2<=barrier_rom_addr_2;
                barrier_rom_addr_3<=barrier_rom_addr_3;
                barrier_rom_addr_4<=barrier_rom_addr_4;
            end
        end
    end
end

assign {vga_r,vga_g,vga_b} = vga_data;

endmodule
