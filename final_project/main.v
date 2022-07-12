module topmod(clk, rst, hsync, vsync, vga_r, vga_g, vga_b,s4,s3,s2,s1,s0,segdis1,segdis0,key_clk,key_data,Enable,led,switch);
    input rst,clk,s4,s3,s2,s1,s0,key_clk,key_data,switch;
    output hsync,vsync,segdis1,segdis0,vga_r,vga_g,vga_b,Enable,led;
    wire rst,clk,s4,s3,s2,s1,s0,key_clk,key_data,valid;
    reg [3:0]vga_r,vga_g,vga_b;
    wire [1:0]switch;
    reg [11:0]vga_data;
    reg [6:0]segdis1,segdis0;
    reg [7:0]Enable;
    reg [15:0]led;
    reg hsync,vsync;
    wire hsync_0, vsync_0, hsync_1, vsync_1;
    wire [6:0] segdis1_0, segdis0_0, segdis1_1,segdis0_1;
    wire [3:0] vga_r_0, vga_g_0, vga_b_0, vga_r_1, vga_g_1, vga_b_1;
    wire [7:0] Enable_0, Enable_1;
    wire [15:0] led_0, led_1;
    code u0(clk, rst, hsync_0, vsync_0, vga_r_0, vga_g_0, vga_b_0,s4,s3,s2,s1,s0,segdis1_0,segdis0_0,key_clk,key_data,Enable_0,led_0,switch,pclk);
    D2_top u1(hsync_1, vsync_1, vga_r_1, vga_g_1, vga_b_1, led_1, segdis1_1, segdis0_1, Enable_1, key_clk, key_data, s2, clk, rst, pclk);

    always @(*)begin 
        if(switch[1]==0)begin 
            hsync = hsync_0;
            vsync = vsync_0;
            segdis1 = segdis1_0;
            segdis0 = segdis0_0;
            vga_r = vga_r_0;
            vga_g = vga_g_0;
            vga_b = vga_b_0;
            Enable = Enable_0;
            led = led_0;
        end
        else begin 
            hsync = hsync_1;
            vsync = vsync_1;
            segdis1 = segdis1_1;
            segdis0 = segdis0_1;
            vga_r = vga_r_1;
            vga_g = vga_g_1;
            vga_b = vga_b_1;
            Enable = Enable_1;
            led = led_1; 
        end
    end
    dcm_25M u2 ( 
        .clk_in1(clk),      
        .clk_out1(pclk),     
        .resetn(rst)
    );
endmodule


module code(clk, rst, hsync, vsync, vga_r, vga_g, vga_b,s4,s3,s2,s1,s0,segdis1,segdis0,key_clk,key_data,Enable,led,switch,pclk);
    input rst,clk,s4,s3,s2,s1,s0,key_clk,key_data,switch,pclk;
    output hsync,vsync,segdis1,segdis0,vga_r,vga_g,vga_b,Enable,led;
    wire pclk,s4,s3,s2,s1,s0,valid;
    wire [9:0] h_cnt, v_cnt;
    wire [3:0]vga_r,vga_g,vga_b;
    wire [1:0]switch;
    reg [11:0]vga_data;
    reg [6:0]segdis;
    reg [7:0]Enable;
    reg [15:0]led;
    wire [11:0] barrierrom_dout;
    reg [11:0] barrierrom_addr;
    
    wire [11:0] fruit1rom_dout;
    reg [11:0] fruit1rom_addr;
    
    wire [11:0] fruit2rom_dout;
    reg [11:0] fruit2rom_addr;
    
    wire [11:0] fruit3rom_dout;
    reg [11:0] fruit3rom_addr;
    
    wire [11:0] poisonrom_dout;
    reg [11:0] poisonrom_addr;

    parameter initi=3'b000,basic=3'b001,invisible=3'b010,win=3'b011,dead=3'b100;

    SyncGeneration u1 (.pclk(pclk),.reset(rst),.hSync(hsync),.vSync(vsync),.dataValid(valid),.hDataCnt(h_cnt),.vDataCnt(v_cnt));
    barrier_rom u2 (.clka(pclk),.addra(barrierrom_addr),.douta(barrierrom_dout));
    fruit1_rom u3 (.clka(pclk),.addra(fruit1rom_addr),.douta(fruit1rom_dout));
    fruit2_rom u4 (.clka(pclk),.addra(fruit2rom_addr),.douta(fruit2rom_dout));
    fruit1_rom u5 (.clka(pclk),.addra(fruit3rom_addr),.douta(fruit3rom_dout));
    poison_rom u6 (.clka(pclk),.addra(poisonrom_addr),.douta(poisonrom_dout));
    clkdiv u7(clk,move_clk,led_clk,seg_clk);
    debounce dbs0(s0,pclk,s0_db);
    debounce dbs1(s1,pclk,s1_db);
    debounce dbs2(s2,pclk,s2_db);
    debounce dbs3(s3,pclk,s3_db);
    debounce dbs4(s4,pclk,s4_db);
    
    assign {vga_r,vga_g,vga_b} = vga_data;
    reg [2:0]state;
    reg [1:0]counter;
    reg [4:0]countedown;
    reg [6:0]segdis1,segdis0;
    reg [9:0]segnum1,segnum0;
    wire [6:0]seg1_2,seg1_1,seg1_0,seg0_0;
    reg [3:0]score_ones,score_Tens,score_Hundreds;
    seg u9(score_ones,seg1_0);
    seg u10(score_Tens,seg1_1);
    seg u11(score_Hundreds,seg1_2);
    always @(posedge seg_clk or negedge  rst) 
    begin :seg_con
        if (!rst) begin
            counter <= 0;
            segdis1 <= 0;
            segdis0 <= 0;
            Enable <= 0;
        end
        else begin
            counter <= counter+1'b1;
            if (counter[1:0]==2'b00) begin 
                segdis1<=7'b0000000;
                segdis0<=7'b0000000;
                Enable<=8'b1000_1000;
            end
            else if (counter[1:0]==2'b01) begin 
                segdis1<=seg1_2;//score Hundreds
                segdis0<=7'b0000000;
                Enable<=8'b0100_0100;
            end
            else if (counter[1:0]==2'b10) begin 
                segdis1<=seg1_1;//score Tens
                segdis0<=7'b0000000;
                Enable<=8'b0010_0010;
            end
            else if (counter[1:0]==2'b11) begin 
                segdis1<=seg1_0;//score ones
                segdis0<=seg0_0;//countdown
                Enable<=8'b0001_0001;
            end
        end
    end
    reg [9:0]tem_x,tem_y;
    reg [9:0]snakehead_x,snakehead_y,snakebody2_x,snakebody2_y,snakebody3_x,snakebody3_y;
    reg [1:0]direct;
    reg have_sel;
    parameter  goright=2'b00,godown=2'b01,goleft=2'b10,goup=2'b11;
    always @(posedge pclk or negedge rst)
    begin: snakehead_direct
        if (!rst) begin
            direct <= goright;
            have_sel <= 0;
        end
        else begin
            tem_x <= snakehead_x;
            tem_y <= snakehead_y;
            if(state==basic) begin
                if(tem_x != snakehead_x || tem_y != snakehead_y)
                        have_sel<=1'b0;
                if(s0_db & direct!=goleft & !have_sel)begin 
                    direct<=goright;
                    have_sel<=1'b1;
                end
                else if(s1_db & direct!=goup & !have_sel)begin 
                    direct<=godown;
                    have_sel<=1'b1;
                end
                else if(s3_db & direct!=goright & !have_sel)begin
                    direct<=goleft;
                    have_sel<=1'b1;
                end
                else if(s4_db & direct!=godown & !have_sel)begin
                    direct<=goup;
                    have_sel<=1'b1;
                end
                else
                    direct<=direct;
            end
        end
    end

    reg bump,length;

    always @(posedge move_clk or negedge rst)
    begin: snake_move
        if (!rst) begin
            snakehead_x <= 61+8+50*2;
            snakehead_y <= 32+8+50*7;
            snakebody2_x <= 61+8+50*1;
            snakebody2_y <= 32+8+50*7;
            snakebody3_x <= 61+8+50*0;
            snakebody3_y <= 32+8+50*7;
            bump<=0;
            length <= 1;
        end
        else begin
            if(state==initi)
                if(switch[0])begin 
                    snakehead_x <= 61+8+50*2;
                    snakehead_y <= 32+8+50*7;
                    snakebody2_x <= 61+8+50*1;
                    snakebody2_y <= 32+8+50*7;
                    snakebody3_x <= 61+8+50*0;
                    snakebody3_y <= 32+8+50*7;
                    length <= 1;
                end
                else begin 
                    snakehead_x <= 61+8+50*1;
                    snakehead_y <= 32+8+50*7;
                    snakebody2_x <= 61+8+50*0;
                    snakebody2_y <= 32+8+50*7;
                    snakebody3_x <= 0;
                    snakebody3_y <= 0;
                    length <= 0;
                end
            else if(state==basic) begin
                if(direct==goright)
                    if(snakehead_x==61+8+50*9)
                        bump<=1;
                    else begin
                        snakehead_x <= snakehead_x+50;
                        snakehead_y <= snakehead_y;
                        snakebody2_x <= snakehead_x;
                        snakebody2_y <= snakehead_y;
                        snakebody3_x <= snakebody2_x;
                        snakebody3_y <= snakebody2_y;
                    end
                else if(direct==godown)
                    if(snakehead_y==32+8+50*7)
                        bump<=1;
                    else begin
                        snakehead_x <= snakehead_x;
                        snakehead_y <= snakehead_y+50;
                        snakebody2_x <= snakehead_x;
                        snakebody2_y <= snakehead_y;
                        snakebody3_x <= snakebody2_x;
                        snakebody3_y <= snakebody2_y;
                    end
                else if(direct==goleft)
                    if(snakehead_x==61+8)
                        bump<=1;
                    else begin
                        snakehead_x <= snakehead_x-50;
                        snakehead_y <= snakehead_y;
                        snakebody2_x <= snakehead_x;
                        snakebody2_y <= snakehead_y;
                        snakebody3_x <= snakebody2_x;
                        snakebody3_y <= snakebody2_y;
                    end
                else if(direct==goup)
                    if(snakehead_y==32+8)
                        bump<=1;
                    else begin
                        snakehead_x <= snakehead_x;
                        snakehead_y <= snakehead_y-50;
                        snakebody2_x <= snakehead_x;
                        snakebody2_y <= snakehead_y;
                        snakebody3_x <= snakebody2_x;
                        snakebody3_y <= snakebody2_y;
                    end
            end
        end
    end

    reg snakehead_area;
    always @(posedge pclk or negedge rst)
    begin: snakehead_ar
        if (!rst) begin
            snakehead_area <= 1'b0;
        end
        else begin
            if((h_cnt >= snakehead_x)&(h_cnt < snakehead_x+50) && (v_cnt >= snakehead_y)&(v_cnt < snakehead_y+50))
                snakehead_area <= 1'b1;
            else
                snakehead_area <=0;
        end
    end

    reg snakebody2_area;
    always @(posedge pclk or negedge rst)
    begin: snakebody2_ar
        if (!rst) begin
            snakebody2_area <= 1'b0;
        end
        else begin
            if((h_cnt >= snakebody2_x)&(h_cnt < snakebody2_x+50) && (v_cnt >= snakebody2_y)&(v_cnt < snakebody2_y+50))
                snakebody2_area <= 1'b1;
            else
                snakebody2_area <=0;
        end
    end

    reg snakebody3_area;
    always @(posedge pclk or negedge rst)
    begin: snakebody3_ar
        if (!rst) begin
            snakebody3_area <= 1'b0;
        end
        else begin
            if((h_cnt >= snakebody3_x)&(h_cnt < snakebody3_x+50) && (v_cnt >= snakebody3_y)&(v_cnt < snakebody3_y+50) && length)
                snakebody3_area <= 1'b1;
            else
                snakebody3_area <=0;
        end
    end

    reg bound_area;
    always @(posedge pclk or negedge rst)
    begin: bound_ar
        if (!rst) begin
            bound_area <= 1'b0;
        end
        else begin
            if(h_cnt >= 61 & h_cnt < 61+8 & v_cnt >= 32 & v_cnt < 448
            || v_cnt >= 32 & v_cnt < 32+8 & h_cnt >= 61 & h_cnt < 577
            || h_cnt >= 569 & h_cnt < 569+8 & v_cnt >= 32 & v_cnt < 448
            || v_cnt >= 440 & v_cnt < 440+8 & h_cnt >= 61 & h_cnt < 577)
                bound_area <= 1'b1;
            else
                bound_area <=1'b0;
        end
    end

    reg poison_area;
    parameter poison_x=61+8+50*5,poison_y=32+8+50*3;
    always @(posedge pclk or negedge rst)
    begin: poison_ar
        if (!rst) begin
            poison_area <= 1'b0;
        end
        else begin
            if((h_cnt >= poison_x)&(h_cnt < poison_x+50) && (v_cnt >= poison_y)&(v_cnt < poison_y+50))
                poison_area <= 1'b1;
            else
                poison_area <=0;
        end
    end

    reg fruit1_area;
    reg [1:0]eat;//00為還沒吃 01為已經吃第一顆 10為已經吃第二顆 11為為已經吃第三顆
    parameter fruit1_x=61+8+50*5,fruit1_y=32+8+50*7;
    always @(posedge pclk or negedge rst)
    begin: furit1_ar
        if (!rst) begin
            fruit1_area <= 1'b0;
        end
        else begin
            if((h_cnt >= fruit1_x)&(h_cnt < fruit1_x+50) && (v_cnt >= fruit1_y)&(v_cnt < fruit1_y+50)&&(eat==2'b00))
                fruit1_area <= 1'b1;
            else
                fruit1_area <=0;
        end
    end

    reg fruit2_area;
    parameter fruit2_x=61+8+50*5,fruit2_y=32+8+50*1;
    always @(posedge pclk or negedge rst)
    begin: furit2_ar
        if (!rst) begin
            fruit2_area <= 1'b0;
        end
        else begin
            if((h_cnt >= fruit2_x)&(h_cnt < fruit2_x+50) && (v_cnt >= fruit2_y)&(v_cnt < fruit2_y+50)&&(eat==2'b01))
                fruit2_area <= 1'b1;
            else
                fruit2_area <=0;
        end
    end

    reg fruit3_area;
    parameter fruit3_x=61+8+50*3,fruit3_y=32+8+50*3;
    always @(posedge pclk or negedge rst)
    begin: furit3_ar
        if (!rst) begin
            fruit3_area <= 1'b0;
        end
        else begin
            if((h_cnt >= fruit3_x)&(h_cnt < fruit3_x+50) && (v_cnt >= fruit3_y)&(v_cnt < fruit3_y+50)&&(eat==2'b10))
                fruit3_area <= 1'b1;
            else
                fruit3_area <=0;
        end
    end

    always @(posedge pclk or negedge rst)
    begin: display_and_control
      if (!rst) begin
        barrierrom_addr <= 12'd0;
        fruit1rom_addr <= 12'd0;
        fruit2rom_addr <= 12'd0;
        fruit3rom_addr <= 12'd0;
        poisonrom_addr <= 12'd0;
        vga_data <= 12'd0;
        state <= initi;
        score_Hundreds <= 4'b1111;
        score_Tens <= 4'b1111;
        score_ones <= 4'b0000;
        eat <= 2'b00;
      end
      else 
      begin
         if (valid)
         begin
            if (bound_area == 1'b1)
               vga_data <= 12'h00f;
            else if (snakehead_area ==1'b1)
               vga_data <= 12'hf80;
            else if (snakebody2_area ==1'b1)
               vga_data <= 12'hf80;
            else if (snakebody3_area ==1'b1)
               vga_data <= 12'hf80;
            else if (fruit1_area ==1'b1) begin
               fruit1rom_addr <= fruit1rom_addr + 14'd1;
               vga_data <= fruit1rom_dout;
            end
            else if (fruit2_area ==1'b1) begin
               fruit2rom_addr <= fruit2rom_addr + 14'd1;
               vga_data <= fruit2rom_dout;
            end
            else if (fruit3_area ==1'b1) begin
               fruit3rom_addr <= fruit3rom_addr + 14'd1;
               vga_data <= fruit3rom_dout;
            end
            else if (poison_area ==1'b1) begin
               poisonrom_addr <= poisonrom_addr + 14'd1;
               vga_data <= poisonrom_dout;
            end
            else if(v_cnt>= 32 & v_cnt < 448 && h_cnt>= 67 & h_cnt < 578)
                vga_data <= 12'hFFF;
            else begin
               vga_data <= 12'h000;
            end
            
            case(state)
            initi:  if(s2_db==1) 
                        state<=basic;
            basic:  begin 
                    if((snakehead_x == poison_x)&(snakehead_y == poison_y) || bump) 
                        state<=dead;
                    else if((snakehead_x == fruit1_x)&(snakehead_y == fruit1_y) && eat==2'b00) begin 
                        eat<=2'b01;score_ones<=4'b0101;
                    end
                    else if((snakehead_x == fruit2_x)&(snakehead_y == fruit2_y) && eat==2'b01)begin 
                        eat<=2'b10;score_Tens<=4'b0001;score_ones<=4'b0101;
                    end
                    else if((snakehead_x == fruit3_x)&(snakehead_y == fruit3_y) && eat==2'b10)begin
                        eat<=2'b11;score_Tens<=4'b0010;score_ones<=4'b0000;
                    end
                    else if(eat==2'b11)
                        state<=win;
                    end
            invisible:;
            win:;   
            dead:;
            endcase
         end
         else begin
            vga_data <= 12'h000;
            if (v_cnt == 0) begin
               fruit1rom_addr <= 13'd0;
               fruit2rom_addr <= 13'd0;
               fruit3rom_addr <= 13'd0;
               poisonrom_addr <= 13'd0;
            end
            else begin
               fruit1rom_addr <= fruit1rom_addr;
               fruit2rom_addr <= fruit2rom_addr;
               fruit3rom_addr <= fruit3rom_addr;
               poisonrom_addr <= poisonrom_addr;
            end
         end
      end
   end
    reg [1:0]led_counter;
    reg win_start;
    always @(posedge led_clk or negedge rst) //led_clk 4hz
    begin :led_display
        if(!rst) begin
            led<=15'b0;
            win_start<=1;
        end
        else begin 
            led_counter <= led_counter+1'b1;
            if(state==dead) begin
                if(led_counter[1]==1)
                    led<=16'b1111_1111_1111_1111;
                else
                    led<=16'b0000_0000_0000_0000;
            end
            else if(state==win) begin 
                if(win_start==1)begin
                    led <= 16'b1000_0000_0000_0000;
                    win_start<=0;
                end
                else if(led != 16'b0000_0000_0000_0000) begin
                    led <= led>>1;
                end
            end
        end
    end
endmodule

module SyncGeneration(pclk, reset, hSync, vSync, dataValid, hDataCnt, vDataCnt);
   input        pclk;
   input        reset;
   output       hSync;
   output       vSync;
   output       dataValid;
   output [9:0] hDataCnt;
   output [9:0] vDataCnt ;
 
   parameter    H_SP_END = 96;
   parameter    H_BP_END = 144;
   parameter    H_FP_START = 785;
   parameter    H_TOTAL = 800;
   
   parameter    V_SP_END = 2;
   parameter    V_BP_END = 35;
   parameter    V_FP_START = 516;
   parameter    V_TOTAL = 525;

   reg [9:0]    x_cnt,y_cnt;
   wire         h_valid,v_valid;
     
   always @(negedge reset or posedge pclk) begin
      if (!reset)
         x_cnt <= 10'd1;
      else begin
         if (x_cnt == H_TOTAL)
            x_cnt <= 10'd1;
         else
            x_cnt <= x_cnt + 1'b1;
      end
   end

   always @(posedge pclk or negedge reset) begin
      if (!reset)
         y_cnt <= 10'd1;
      else begin
         if (y_cnt == V_TOTAL & x_cnt == H_TOTAL)
            y_cnt <= 1;
         else if (x_cnt == H_TOTAL)
            y_cnt <= y_cnt + 1;
         else y_cnt<=y_cnt;
      end
   end

   assign hSync = ((x_cnt > H_SP_END)) ? 1'b1 : 1'b0;
   assign vSync = ((y_cnt > V_SP_END)) ? 1'b1 : 1'b0;
   
   // Check P7 for horizontal timing   
   assign h_valid = ((x_cnt > H_BP_END) & (x_cnt <= H_FP_START)) ? 1'b1 : 1'b0;
   // Check P9 for vertical timing
   assign v_valid = ((y_cnt > V_BP_END) & (y_cnt <= V_FP_START)) ? 1'b1 : 1'b0;
   
   assign dataValid = ((h_valid == 1'b1) & (v_valid == 1'b1)) ? 1'b1 :  1'b0;
   
   // hDataCnt from 1 if h_valid==1
   assign hDataCnt = ((h_valid == 1'b1)) ? x_cnt - H_BP_END : 10'b0;
   // vDataCnt from 1 if v_valid==1
   assign vDataCnt = ((v_valid == 1'b1)) ? y_cnt - V_BP_END : 10'b0; 
            
endmodule

module clkdiv(clk,move_clk,led_clk,seg_clk);
    input clk;
    output move_clk,led_clk,seg_clk;
    reg [27:0]counter;
    reg move_clk,led_clk,seg_clk;
    initial begin
        counter=28'b0;
    end

    always @(posedge clk)
    begin
        counter <= counter+1'b1;
        move_clk <= counter[25];
        led_clk <= counter[24];
        seg_clk <= counter[16];
    end
endmodule

module seg(
    input wire [3:0]num,
    output reg [6:0]dis
    );
    always @(*)begin
        dis = 7'b0000_0000;
        case(num)
            4'b0000: begin dis = 7'b0111_111; end 
            4'b0001: begin dis = 7'b0000_110; end 
            4'b0010: begin dis = 7'b1011_011; end 
            4'b0011: begin dis = 7'b1001_111; end 
            4'b0100: begin dis = 7'b1100_110; end 
            4'b0101: begin dis = 7'b1101_101; end 
            4'b0110: begin dis = 7'b1111_101; end 
            4'b0111: begin dis = 7'b0000_111; end 
            4'b1000: begin dis = 7'b1111_111; end
            4'b1001: begin dis = 7'b1101_111; end
            default: begin dis = 7'b000_0000; end 
        endcase
    end
endmodule

module debounce(input pb_1,db_clk,output pb_out);
    wire Q1,Q2,Q2_bar,Q0;
    dff db0(db_clk,pb_1,Q0);
    dff db1(db_clk,Q0,Q1);
    dff db2(db_clk,Q1,Q2);
    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;
endmodule

module dff(input dff_clk, D, output reg Q);
    always @ (posedge dff_clk) begin
        Q <= D;
    end
endmodule

module D2_top(hsync, vsync, vga_r, vga_g, vga_b, LedOut, L_SevenSegOut, R_SevenSegOut, Enable, key_clk, key_data, S2, clk, reset, pclk);
output  hsync,vsync;
output  [7:0] Enable;
output  [3:0] vga_r, vga_g, vga_b;
output  [15:0] LedOut;
output  [6:0] L_SevenSegOut, R_SevenSegOut;
input   clk, reset, S2, key_clk, key_data, pclk;
wire f_clk, Led_clk, i_clk, snake_clk, SevenSeg_clk, c_clk, touch, touchPoison, Touch_I_Fruit, Touch_N_Fruit, fruit, Long_enough;
wire [3:0] poison_x, poison_y, I_fruit_x, I_fruit_y, N_fruit_x, N_fruit_y;
wire [39:0] snake_x, snake_y; 
wire [2:0] NS, countDown;
wire [3:0] score100, score10, score1;
wire [1:0] direct;
wire [3:0] enable;
wire up, down, left, right, Q, start, key_state, flag;
assign Enable = {enable,enable};
clkDivider u0(f_clk, Led_clk, i_clk, snake_clk, c_clk, SevenSeg_clk, clk, reset);
state u1 (NS, reset, clk, start, Long_enough, touch, touchPoison, Touch_I_Fruit, countDown);
TouchPoison u3(touchPoison, snake_x[39:36], snake_y[39:36], NS, poison_x, poison_y);
TouchFruit u5(Touch_N_Fruit, Touch_I_Fruit, N_fruit_x, I_fruit_x, I_fruit_y, N_fruit_y, snake_x[39:36], snake_y[39:36]);
SnakeMove u6(flag, touch, direct, snake_x, snake_y, NS, up, down, left, right, N_fruit_x, N_fruit_y, snake_clk, clk, reset, key_state);
I_fruit u7(I_fruit_x, I_fruit_y, NS, snake_x, snake_y, poison_x, poison_y, N_fruit_x, N_fruit_y, Q, Touch_I_Fruit, clk, f_clk, reset, key_state);
N_fruit u8(fruit, N_fruit_x, N_fruit_y, I_fruit_x, I_fruit_y, Touch_N_Fruit, snake_x, snake_y, poison_x, poison_y, clk, f_clk, reset);
poison u9(poison_x, poison_y, NS, touchPoison, clk, reset);
VGA_display u10(pclk, clk, reset, start, hsync, vsync, vga_r, vga_g, vga_b, N_fruit_x, N_fruit_y, fruit, snake_y, snake_x, I_fruit_x, I_fruit_y, poison_x, poison_y, NS, flag);
CountDown u11(countDown, NS, c_clk, reset);
Score u12(score100, score10, score1, Touch_N_Fruit, NS, clk, reset);
SevenSegShow u13(L_SevenSegOut, R_SevenSegOut, enable, countDown, score100, score10, score1, NS, SevenSeg_clk, reset);
LedShow u14(LedOut, NS, Led_clk, reset);
Size u15(Long_enough, snake_x, snake_y);
keyboard u17(clk,reset,key_clk,key_data,up, left,down,right,Q,key_state);
debounce_D2 u18(S2, clk,reset, start);
endmodule

module clkDivider(f_clk, Led_clk, i_clk, snake_clk, c_clk, SevenSeg_clk, clk, reset);
input clk, reset;
output reg Led_clk, i_clk, snake_clk, SevenSeg_clk, c_clk, f_clk;
reg [26:0] Hz1;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        Hz1 <= 0;
    end
    else
    begin
        Hz1 <= Hz1 + 27'b1;
        c_clk <= Hz1[26];
        snake_clk <= Hz1[25];
        i_clk <= Hz1[25];
        SevenSeg_clk <= Hz1[16];
        Led_clk <= Hz1[24];
        f_clk <= Hz1[6];
    end
end
endmodule

module state(NS, reset, clk, start, Long_enough, touch, touchPoison, Touch_I_Fruit, countDown);
input reset, clk, start, Long_enough, touch, touchPoison, Touch_I_Fruit;
input [2:0] countDown;
output reg [2:0]NS;
reg [2:0]CS;
parameter Init = 3'b000, Basic = 3'b001, Invincible = 3'b010, Dead = 3'b011, Win = 3'b100;
always @(posedge clk or posedge reset) begin
    if (!reset)
        CS <= Init;
    else
        CS <= NS;
end
always @(posedge  clk or negedge reset) begin
    if(!reset)
        NS <= Init;
    else
    begin
        case (CS)
            Init: begin
                if(start)
                    NS <= Basic;
                else 
                    NS <= CS;
            end
            Basic: begin
                if(touchPoison || touch)
                    NS <= Dead;
                else if(Touch_I_Fruit)
                    NS <= Invincible;
                else if(Long_enough)
                    NS <= Win;
                else
                    NS <= CS;
            end
            Invincible: begin
                if(Long_enough)
                    NS <= Win;
                if(countDown == 0)
                begin
                    NS <= Basic;
                end
                else if(touch)
                    NS <= Dead;
                else
                    NS <= CS;
            end
            Dead: begin
                    NS <= Dead;
            end
            Win: begin
                    NS <= Win;
            end
            default: begin
                    NS <= CS;
            end
        endcase
    end
end
endmodule

module TouchPoison(touch, snake_head_x, snake_head_y, state, poison_x, poison_y);
output reg touch;
input [2:0] state;
input [3:0] snake_head_x, snake_head_y, poison_x, poison_y;
always @(*)
begin
    if(snake_head_x == poison_x && snake_head_y == poison_y)
        touch = 1;
    else 
        touch = 0;
end
endmodule

module TouchSelf(touch, snake_x_i, snake_y_i);
output reg touch;
input [39:0]snake_x_i, snake_y_i;
wire [3:0] snake_x[9:0], snake_y[9:0];
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(*)
begin
    if(snake_x[9] == snake_x[5] && snake_y[9] == snake_y[5])
        touch = 1;
    else if(snake_x[9] == snake_x[4] && snake_y[9] == snake_y[4])
        touch = 1;
    else if(snake_x[9] == snake_x[3] && snake_y[9] == snake_y[3])
        touch = 1;
    else if(snake_x[9] == snake_x[2] && snake_y[9] == snake_y[2])
        touch = 1;
    else if(snake_x[9] == snake_x[1] && snake_y[9] == snake_y[1])
        touch = 1;
    else if(snake_x[9] == snake_x[0] && snake_y[9] == snake_y[0])
        touch = 1;
    else 
        touch = 0;
end
endmodule

module TouchFruit(Touch_N_Fruit, Touch_I_Fruit, N_fruit_x, I_fruit_x, I_fruit_y, N_fruit_y, snake_head_x, snake_head_y);
output reg Touch_I_Fruit, Touch_N_Fruit;
input [3:0]N_fruit_x, N_fruit_y, snake_head_x, snake_head_y, I_fruit_x, I_fruit_y;
always @(*)
begin
    if(N_fruit_x == snake_head_x && N_fruit_y == snake_head_y)
        Touch_N_Fruit = 1;
    else if(snake_head_x == I_fruit_x && snake_head_y == I_fruit_y)
        Touch_I_Fruit = 1;
    else 
    begin
        Touch_I_Fruit = 0;
        Touch_N_Fruit = 0;
    end
end
endmodule

module SnakeMove(flag, touch , direct, snake_x_out, snake_y_out, state, up, down, left, right, N_fruit_x, N_fruit_y, s_clk, clk, reset, key_state);
output [39:0] snake_x_out, snake_y_out;
output reg touch, flag;
output reg [1:0] direct;
input [2:0] state;
input s_clk, clk, reset, up, left, right, down, key_state;
input [3:0] N_fruit_x, N_fruit_y;
reg [3:0] snake_x[9:0], snake_y[9:0];
assign snake_x_out = {{snake_x[9]},{snake_x[8]},{snake_x[7]},{snake_x[6]},{snake_x[5]},{snake_x[4]},{snake_x[3]},{snake_x[2]},{snake_x[1]},{snake_x[0]}};
assign snake_y_out = {{snake_y[9]},{snake_y[8]},{snake_y[7]},{snake_y[6]},{snake_y[5]},{snake_y[4]},{snake_y[3]},{snake_y[2]},{snake_y[1]},{snake_y[0]}};
reg [1:0]prev_direct;

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        direct <= 2'b00;
    end
    else
    begin
        if(right && prev_direct != 2'b10 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b00;
        else if(up && prev_direct != 2'b11 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b01;
        else if(left && prev_direct != 2'b00 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b10;
        else if(down && prev_direct != 2'b01 && (state == 3'b001 || state == 3'b010) && key_state)
            direct <= 2'b11;
        else
            direct <= direct;
    end
end

reg counter, times;
always @(posedge s_clk or negedge reset)
begin
    if(!reset)
    begin
        snake_x[9] <= 4'd2;
        snake_x[8] <= 4'd1;
        snake_x[7] <= 4'd0;
        snake_x[6] <= 4'd13;
        snake_x[5] <= 4'd13;
        snake_x[4] <= 4'd13;
        snake_x[3] <= 4'd13;
        snake_x[2] <= 4'd13;
        snake_x[1] <= 4'd13;
        snake_x[0] <= 4'd13;
        snake_y[9] <= 4'd7;
        snake_y[8] <= 4'd7;
        snake_y[7] <= 4'd7;
        snake_y[6] <= 4'd13;
        snake_y[5] <= 4'd13;
        snake_y[4] <= 4'd13;
        snake_y[3] <= 4'd13;
        snake_y[2] <= 4'd13;
        snake_y[1] <= 4'd13;
        snake_y[0] <= 4'd13;
        touch <= 0;
        prev_direct <= 2'b00;
        flag <= 0;
        times <= 0;
        counter <= 0;
    end
    else
    begin
        if(state == 3'b001 || state == 3'b010)
        begin 
            if(state == 3'b010 && counter && times)
                flag <= ~flag;
            if(state == 3'b010)
            begin
                times <= 1;
                counter <= ~counter;
            end
            prev_direct <= direct;
            if(snake_x[9] != 4'd13 && snake_y[9] != 4'd13)
            begin
                case(direct)
                2'b00:  begin
                    snake_x[9] <= snake_x[9] + 1;
                    snake_y[9] <= snake_y[9];    
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[9] <= snake_x[9];
                        touch <= 1;
                    end 
                end
                2'b01:  begin
                    snake_x[9] <= snake_x[9];
                    snake_y[9] <= snake_y[9] - 1;
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_y[9] <= snake_y[9];
                        touch <= 1;
                    end 
                end
                2'b10: begin
                    snake_x[9] <= snake_x[9] - 1;
                    snake_y[9] <= snake_y[9];
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[9] <= snake_x[9];
                        touch <= 1;
                    end 
                end
                2'b11:  begin
                    snake_x[9] <= snake_x[9];
                    snake_y[9] <= snake_y[9] + 1;
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_y[9] <= snake_y[9];
                        touch <= 1;
                    end
                end
                endcase
            end
            else
            begin
                snake_x[9] <= snake_x[9];
                snake_y[9] <= snake_y[9];
            end
            if(snake_x[8] != 4'd13 && snake_y[8] != 4'd13)
            begin
                snake_x[8] <= snake_x[9];
                snake_y[8] <= snake_y[9];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end     
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[8] <= snake_x[8];
                        snake_y[8] <= snake_y[8];
                    end  
                end
                endcase
            end
            else
            begin
                snake_x[8] <= snake_x[8];
                snake_y[8] <= snake_y[8];
            end
            if(snake_x[7] != 4'd13 && snake_y[7] != 4'd13)
            begin
                snake_x[7] <= snake_x[8];
                snake_y[7] <= snake_y[8];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                2'b11:  begin
                     if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[7] <= snake_x[7];
                        snake_y[7] <= snake_y[7];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[7] <= snake_x[7];
                snake_y[7] <= snake_y[7];
            end
            if(snake_x[6] != 4'd13 && snake_y[6] != 4'd13)
            begin
                snake_x[6] <= snake_x[7];
                snake_y[6] <= snake_y[7];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                2'b11:  begin
                   if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[6] <= snake_x[6]; 
                        snake_y[6] <= snake_y[6];
                    end
                end
                endcase
            end
            else
            begin
                snake_x[6] <= snake_x[6];
                snake_y[6] <= snake_y[6];
            end
            if(snake_x[5] != 4'd13 && snake_y[5] != 4'd13)
            begin
                snake_x[5] <= snake_x[6];
                snake_y[5] <= snake_y[6];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[5] <= snake_x[5]; 
                        snake_y[5] <= snake_y[5];
                    end
                end
                endcase
            end
            else
            begin
                snake_x[5] <= snake_x[5];
                snake_y[5] <= snake_y[5];
            end
            if(snake_x[4] != 4'd13 && snake_y[4] != 4'd13)
            begin
                snake_x[4] <= snake_x[5];
                snake_y[4] <= snake_y[5];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[4] <= snake_x[4];
                        snake_y[4] <= snake_y[4];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[4] <= snake_x[4];
                snake_y[4] <= snake_y[4];
            end
            if(snake_x[3] != 4'd13 && snake_y[3] != 4'd13)
            begin
                snake_x[3] <= snake_x[4];
                snake_y[3] <= snake_y[4];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[3] <= snake_x[3];
                        snake_y[3] <= snake_y[3];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[3] <= snake_x[3];
                snake_y[3] <= snake_y[3];
            end
            if(snake_x[2] != 4'd13 && snake_y[2] != 4'd13)
            begin
                snake_x[2] <= snake_x[3];
                snake_y[2] <= snake_y[3];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[2] <= snake_x[2];
                        snake_y[2] <= snake_y[2];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[2] <= snake_x[2];
                snake_y[2] <= snake_y[2];
            end
            if(snake_x[1] != 4'd13 && snake_y[1] != 4'd13)
            begin
                snake_x[1] <= snake_x[2];
                snake_y[1] <= snake_y[2];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[1] <= snake_x[1];
                        snake_y[1] <= snake_y[1];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[1] <= snake_x[1];
                snake_y[1] <= snake_y[1];
            end
            if(snake_x[0] != 4'd13 && snake_y[0] != 4'd13)
            begin
                snake_x[0] <= snake_x[1];
                snake_y[0] <= snake_y[1];
                case(direct)
                2'b00:  begin
                    if(snake_x[9] == 4'd9 || (snake_x[9]== 4'd2 && snake_y[9] == 4'd2) ||
                    (snake_x[9]+1 == snake_x[6] && snake_y[9] == snake_y[6]) || (snake_x[9]+1 == snake_x[5] && snake_y[9] == snake_y[5])
                     || (snake_x[9]+1 == snake_x[4] && snake_y[9] == snake_y[4]) || (snake_x[9]+1 == snake_x[3] && snake_y[9] == snake_y[3])
                      || (snake_x[9]+1 == snake_x[2] && snake_y[9] == snake_y[2]) || (snake_x[9]+1 == snake_x[1] && snake_y[9] == snake_y[1])
                       || (snake_x[9]+1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b01:  begin
                    if(snake_y[9] == 4'd0 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd3) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd3) || (snake_x[9]== 4'd6 && snake_y[9] == 4'd3)
                      || (snake_x[9] == snake_x[6] && snake_y[9]-1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]-1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]-1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]-1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]-1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]-1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]-1 == snake_y[0]))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b10: begin
                    if(snake_x[9] == 4'd0 || (snake_x[9]== 4'd7 && snake_y[9] == 4'd2) || (snake_x[9]-1 == snake_x[6] && snake_y[9] == snake_y[6])
                     || (snake_x[9]-1 == snake_x[5] && snake_y[9] == snake_y[5]) || (snake_x[9]-1 == snake_x[4] && snake_y[9] == snake_y[4])
                      || (snake_x[9]-1 == snake_x[3] && snake_y[9] == snake_y[3]) || (snake_x[9]-1 == snake_x[2] && snake_y[9] == snake_y[2])
                       || (snake_x[9]-1 == snake_x[1] && snake_y[9] == snake_y[1]) || (snake_x[9]-1 == snake_x[0] && snake_y[9] == snake_y[0]))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                2'b11:  begin
                    if(snake_y[9] == 4'd7 || (snake_x[9]== 4'd3 && snake_y[9] == 4'd1) ||
                     (snake_x[9]== 4'd4 && snake_y[9] == 4'd1) || (snake_x[9]== 4'd5 && snake_y[9] == 4'd1)|| (snake_x[9]== 4'd6 && snake_y[9] == 4'd1)
                      || (snake_x[9] == snake_x[6] && snake_y[9]+1 == snake_y[6]) || (snake_x[9] == snake_x[5] && snake_y[9]+1 == snake_y[5])
                       || (snake_x[9] == snake_x[4] && snake_y[9]+1 == snake_y[4]) || (snake_x[9] == snake_x[3] && snake_y[9]+1 == snake_y[3])
                        || (snake_x[9] == snake_x[2] && snake_y[9]+1 == snake_y[2]) || (snake_x[9] == snake_x[1] && snake_y[9]+1 == snake_y[1])
                         || (snake_x[9] == snake_x[0] && snake_y[9]+1 == snake_y[0]))
                    begin
                        snake_x[0] <= snake_x[0];
                        snake_y[0] <= snake_y[0];
                    end 
                end
                endcase
            end
            else
            begin
                snake_x[0] <= snake_x[0];
                snake_y[0] <= snake_y[0];
            end
            if((direct == 2'b00 && (snake_x[9] + 1) == N_fruit_x && (snake_y[9]) == N_fruit_y) || 
            (direct == 2'b01 &&(snake_x[9]) == N_fruit_x && (snake_y[9] - 1) == N_fruit_y) || 
            (direct == 2'b10 && (snake_x[9] - 1) == N_fruit_x && (snake_y[9]) == N_fruit_y) || 
            (direct == 2'b11 && (snake_x[9]) == N_fruit_x && (snake_y[9] + 1) == N_fruit_y))
            begin
               if(snake_x[6] == 4'd13 && snake_y[6] == 4'd13)
               begin
                   snake_x[6] <= snake_x[7];
                   snake_y[6] <= snake_y[7];
               end 
               else if(snake_x[5] == 4'd13 && snake_y[5] == 4'd13)
               begin
                   snake_x[5] <= snake_x[6];
                   snake_y[5] <= snake_y[6];
               end
               else if(snake_x[4] == 4'd13 && snake_y[4] == 4'd13)
               begin
                   snake_x[4] <= snake_x[5];
                   snake_y[4] <= snake_y[5];
               end
               else if(snake_x[3] == 4'd13 && snake_y[3] == 4'd13)
               begin
                   snake_x[3] <= snake_x[4];
                   snake_y[3] <= snake_y[4];
               end
               else if(snake_x[2] == 4'd13 && snake_y[2] == 4'd13)
               begin
                   snake_x[2] <= snake_x[3];
                   snake_y[2] <= snake_y[3];
               end
               else if(snake_x[1] == 4'd13 && snake_y[1] == 4'd13)
               begin
                   snake_x[1] <= snake_x[2];
                   snake_y[1] <= snake_y[2];
               end
               else if(snake_x[0] == 4'd13 && snake_y[0] == 4'd13)
               begin
                   snake_x[0] <= snake_x[1];
                   snake_y[0] <= snake_y[1];
               end
            end
        end
    end
end
endmodule

module I_fruit(I_fruit_x, I_fruit_y, state, snake_x_i, snake_y_i, poison_x, poison_y, N_fruit_x, N_fruit_y, Q, Touch_I_fruit, clk, f_clk, reset, key_state);
output reg [3:0] I_fruit_x, I_fruit_y;
input [2:0] state;
input [39:0] snake_y_i, snake_x_i;
input [3:0] poison_x, poison_y, N_fruit_x, N_fruit_y;
input reset, clk, Q, Touch_I_fruit, f_clk, key_state;
reg valid;
reg [3:0] allow_x, allow_y;
wire [3:0] snake_x[9:0], snake_y[9:0];
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(posedge f_clk or negedge reset)
begin
    if(!reset)
    begin
        I_fruit_x <= 4'd13;
        I_fruit_y <= 4'd13;
        valid <= 0;
    end
    else
    begin
        if(state == 3'b001 && Q && key_state)
        begin
            begin
                if(!valid)
                begin
                    I_fruit_x <= allow_x;
                    I_fruit_y <= allow_y;
                    valid <= 1;
                end
                if(Touch_I_fruit)
                begin
                    I_fruit_x <= 4'd13;
                    I_fruit_y <= 4'd13;
                end
            end
        end
        else if(state == 3'b010)
        begin
            I_fruit_x <= 4'd13;
            I_fruit_y <= 4'd13;
        end
        else
        begin
            I_fruit_x <= I_fruit_x;
            I_fruit_y <= I_fruit_y;
        end
    end
end

reg [3:0] x, y;
reg [3:0] prev_N_fruit_x, prev_N_fruit_y;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        x <= 0;
        y <= 0;
    end
    else
    begin
        x <= x + 1;
        if(x == 4'd9)
        begin
            y <= y + 1;
            x <= 4'd0; 
        end
        if(y == 4'd7 && x == 4'd9)
        begin
            y <= 0;
            x <= 0;
        end
    end
end

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        allow_y <= 0;
        allow_x <= 0; 
        prev_N_fruit_x <= 0;
        prev_N_fruit_y <= 0;
    end
    else
    begin
        prev_N_fruit_x <= N_fruit_x;
        prev_N_fruit_y <= N_fruit_y;
        if((x != poison_x || y != poison_y) && (x != N_fruit_x || y != N_fruit_y) &&
        !((prev_N_fruit_x == N_fruit_x) && (prev_N_fruit_y == N_fruit_y)) &&
        !(x == snake_x[9] && y == snake_y[9]) && !(x == snake_x[8] && y == snake_y[8]) && 
        !(x == snake_x[7] && y == snake_y[7]) && !(x == snake_x[6] && y == snake_y[6]) && 
        !(x == snake_x[5] && y == snake_y[5]) && !(x == snake_x[4] && y == snake_y[4]) && 
        !(x == snake_x[3] && y == snake_y[3]) && !(x == snake_x[2] && y == snake_y[2]) && 
        !(x == snake_x[1] && y == snake_y[1]) && !(x == snake_x[0] && y == snake_y[0]))
        begin
            allow_x <= x;
            allow_y <= y;
        end
    end
end
endmodule

module N_fruit(fruit, N_fruit_x, N_fruit_y, I_fruit_x, I_fruit_y, Touch_N_Fruit, snake_x_i, snake_y_i, poison_x, poison_y, clk, f_clk, reset);
output reg [3:0] N_fruit_x, N_fruit_y;
output reg fruit;
input [39:0] snake_y_i, snake_x_i;
input [3:0] poison_x, poison_y, I_fruit_x, I_fruit_y;
input Touch_N_Fruit, clk, reset,f_clk;
wire [3:0] snake_x[9:0], snake_y[9:0];
reg [3:0] allow_x, allow_y;
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(posedge f_clk or negedge reset)
begin
    if(!reset)
    begin
        N_fruit_x <= 4'd5;
        N_fruit_y <= 4'd7;
        fruit <= 0;
    end
    else
    begin
        if(Touch_N_Fruit)
        begin
            N_fruit_x <= allow_x;
            N_fruit_y <= allow_y;
            fruit <= ~fruit;
        end
        else
        begin
            N_fruit_x <= N_fruit_x;
            N_fruit_y <= N_fruit_y;
        end
    end
end
reg [3:0] x, y;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        x <= 0;
        y <= 0;
    end
    else
    begin
        x <= x + 1;
        if(x == 4'd9)
        begin
            y <= y + 1;
            x <= 4'd0; 
        end
        if(y == 4'd7 && x == 4'd9)
        begin
            y <= 0;
            x <= 0;
        end
    end
end

integer i;

always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        allow_y <= 0;
        allow_x <= 0; 
    end
    else
    begin
        if((x != poison_x || y != poison_y) && (x != I_fruit_x || y != I_fruit_y) && 
        !(x == snake_x[9] && y == snake_y[9]) && !(x == snake_x[8] && y == snake_y[8]) && 
        !(x == snake_x[7] && y == snake_y[7]) && !(x == snake_x[6] && y == snake_y[6]) && 
        !(x == snake_x[5] && y == snake_y[5]) && !(x == snake_x[4] && y == snake_y[4]) && 
        !(x == snake_x[3] && y == snake_y[3]) && !(x == snake_x[2] && y == snake_y[2]) && 
        !(x == snake_x[1] && y == snake_y[1]) && !(x == snake_x[0] && y == snake_y[0]))
        begin
            allow_x <= x;
            allow_y <= y;
        end
    end
end
endmodule

module poison(poison_x, poison_y, state, TouchPoison, clk, reset);
output reg [3:0] poison_x, poison_y;
input [2:0] state;
input TouchPoison, clk ,reset;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        poison_x <= 4'd5;
        poison_y <= 4'd3;
    end
    else
    begin
        if(state == 3'b010 && TouchPoison)
        begin
            poison_x <= 4'd13;
            poison_y <= 4'd13;
        end
        else 
        begin
            poison_x <= poison_x;
            poison_y <= poison_y;
        end
    end
end
endmodule

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
wire snake_area[9:0], N_fruit_area_5, N_fruit_area_10, I_fruit_area, poison_area, barrier_area[3:0], edge_area, black_area;
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

module CountDown(out_num, state, c_clk, reset);
output reg [2:0]out_num;
input [2:0]state;
input c_clk, reset;
always @(posedge c_clk or negedge reset)
begin
    if(!reset)
        out_num <= 3'd5;
    else
    begin
        if(state == 3'b010)
            out_num <= out_num - 1;
    end
end
endmodule

module Score(score100, score10, score1, Touch_N_Fruit, state, clk, reset);
output reg [3:0] score100, score10, score1;
input Touch_N_Fruit, clk, reset;
input [2:0] state;
reg flag, valid;
always @(posedge clk or negedge reset)
begin
    if(!reset)
    begin
        score100 <= 4'd10;
        score10 <= 4'd10;
        score1 <= 4'd0;
        flag <= 0;
        valid <= 0;
    end
    else 
    begin
        if(Touch_N_Fruit && !valid)
        begin
            if(state == 3'b010)
            begin
                if(!flag)
                begin
                    if(score10 == 4'd9)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 1;
                        if(score10 == 4'd10)
                            score10 <= 4'd1;
                    end
                end
                else
                begin
                    if(score10 == 4'd8)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 4'd2;
                        if(score10 == 4'd10)
                            score10 <= 4'd2;
                    end
                end
            end
            else
            begin
                if(!flag)
                begin
                    if(score1 == 4'd5)
                    begin
                        if(score10 == 4'd9)
                        begin
                            score100 <= score100 + 4'd1;
                            score10 <= 4'd0;
                            score1 <= 4'd0;
                        end
                        else
                        begin
                            score10 <= score10 + 4'd1;
                            score1 <= 4'd0;
                        end
                    end
                    else
                    begin
                        score1 <= score1 + 4'd5;
                        if(score1 == 4'd10)
                            score1 <= 4'd5;
                    end
                end
                else
                begin
                    if(score10 == 4'd9)
                    begin
                        score100 <= score100 + 4'd1;
                        score10 <= 4'd0;
                    end
                    else
                    begin
                        score10 <= score10 + 1;
                        if(score10 == 4'd10)
                            score10 <= 4'd1;
                    end
                end
            end
            flag <= ~flag;
            valid <= 1;
        end
        else if(valid && !Touch_N_Fruit)
        begin
            valid <= 0;
        end
    end
end
endmodule

module SevenSegShow(L_SevenSegOut, R_SevenSegOut, enable, countDown, score100, score10, score1, state, SevenSeg_clk, reset);
output [6:0] L_SevenSegOut, R_SevenSegOut;
output reg [3:0] enable;
input [3:0] score100, score10, score1;
input [2:0] countDown;
input [2:0] state;
input SevenSeg_clk, reset;
reg [3:0] score, num;
SevenSegMap u0(L_SevenSegOut, score);
SevenSegMap u1(R_SevenSegOut, num);
reg [1:0]flag;
always @(posedge SevenSeg_clk or negedge reset)
begin
    if(!reset)
    begin
        score <= 4'd10;
        num <= 4'd10;
        flag <= 2'd0;
    end
    else
    begin
        if(state == 3'b010)
        begin
            case(flag)
                2'b00: begin
                    score <= score1;
                    num <= {1'b0,countDown};
                    enable <= 4'b0001;
                end
                2'b01: begin
                    score <= score10;
                    num <= 4'd10;
                    enable <= 4'b0010;
                end
                2'b10: begin
                    score <= score100;
                    num <= 4'd10;
                    enable <= 4'b0100;
                end
                2'b11: begin
                    score <= 4'd10;
                    num <= 4'd10;
                    enable <= 4'b1000;
                end
            endcase
        end
        else
        begin
            case(flag)
                2'b00: begin
                    score <= score1;
                    num <= 4'd10;
                    enable <= 4'b0001;
                end
                2'b01: begin
                    score <= score10;
                    num <= 4'd10;
                    enable <= 4'b0010;
                end
                2'b10: begin
                    score <= score100;
                    num <= 4'd10;
                    enable <= 4'b0100;
                end
                2'b11: begin
                    score <= 4'd10;
                    num <= 4'd10;
                    enable <= 4'b1000;
                end
            endcase
        end
        flag <= flag + 1'b1 ;
    end
end
endmodule

module LedShow(LedOut, state, Led_clk, reset);
output reg [15:0] LedOut;
input [2:0] state;
input Led_clk, reset;
reg flag; 
reg [1:0]counter;
reg [15:0]pos;
always @(posedge Led_clk or negedge reset)
begin
    if(!reset)
    begin
        LedOut <= 16'b0;
        flag <= 0;
        counter <= 0;
        pos <= 16'h8000;
    end
    else
    begin
        if(state == 3'b011)
        begin
            if(!counter[1] && !flag)
                LedOut <= 16'hffff;
            else
                LedOut <= 16'h0000;
            flag <= ~flag;
            counter <= counter + 1;
        end
        else if(state == 3'b100)
        begin
            if(!flag)
            begin
                LedOut <= pos;
                pos <= pos >> 1;
            end
            if(pos == 16'h0000)
            begin
                LedOut <= 16'h0000;
                flag <= 1;
            end
        end
    end
end
endmodule

module Size(Long_enough, snake_x_i, snake_y_i);
output reg Long_enough;
input [39:0] snake_x_i, snake_y_i;
wire [3:0] snake_x[9:0], snake_y[9:0];
assign {snake_x[9],snake_x[8],snake_x[7],snake_x[6],snake_x[5],snake_x[4],snake_x[3],snake_x[2],snake_x[1],snake_x[0]} = snake_x_i; 
assign {snake_y[9],snake_y[8],snake_y[7],snake_y[6],snake_y[5],snake_y[4],snake_y[3],snake_y[2],snake_y[1],snake_y[0]} = snake_y_i; 
always @(*)
begin
    if(snake_x[0] != 4'd13 && snake_y[0] != 4'd13)
        Long_enough = 1;
    else 
        Long_enough = 0;
end
endmodule


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

module SyncGeneration_D2(pclk, reset, hSync, vSync, dataValid, hDataCnt, vDataCnt);
  
   input        pclk;
   input        reset;
   output       hSync;
   output       vSync;
   output       dataValid;
   output [9:0] hDataCnt;
   output [9:0] vDataCnt ;
 

   parameter    H_SP_END = 96;
   parameter    H_BP_END = 144;
   parameter    H_FP_START = 785;
   parameter    H_TOTAL = 800;
   
   parameter    V_SP_END = 2;
   parameter    V_BP_END = 35;
   parameter    V_FP_START = 516;
   parameter    V_TOTAL = 525;

   reg [9:0]    x_cnt,y_cnt;
   wire         h_valid,v_valid;
     
   always @(negedge reset or posedge pclk) begin
      if (!reset)
         x_cnt <= 10'd1;
      else begin
         if (x_cnt == H_TOTAL)
            x_cnt <= 10'd1;
         else
            x_cnt <= x_cnt + 1;
      end
   end
   
   always @(posedge pclk or negedge reset) begin
      if (!reset)
         y_cnt <= 10'd1;
      else begin
         if (y_cnt == V_TOTAL & x_cnt == H_TOTAL)
            y_cnt <= 1;
         else if (x_cnt == H_TOTAL)
            y_cnt <= y_cnt + 1;
         else y_cnt<=y_cnt;
      end
   end
   
   assign hSync = ((x_cnt > H_SP_END)) ? 1'b1 : 1'b0;
   assign vSync = ((y_cnt > V_SP_END)) ? 1'b1 : 1'b0;
   
   // Check P7 for horizontal timing   
   assign h_valid = ((x_cnt > H_BP_END) & (x_cnt <= H_FP_START)) ? 1'b1 : 1'b0;
   // Check P9 for vertical timing
   assign v_valid = ((y_cnt > V_BP_END) & (y_cnt <= V_FP_START)) ? 1'b1 : 1'b0;
   
   assign dataValid = ((h_valid == 1'b1) & (v_valid == 1'b1)) ? 1'b1 :  1'b0;
   
   // hDataCnt from 1 if h_valid==1
   assign hDataCnt = ((h_valid == 1'b1)) ? x_cnt - H_BP_END : 10'b0;
   // vDataCnt from 1 if v_valid==1
   assign vDataCnt = ((v_valid == 1'b1)) ? y_cnt - V_BP_END : 10'b0; 
            
   
endmodule

module SevenSegMap(Out, now);
input [3:0]now;
output reg [6:0]Out;
always @(*)
begin
    case(now)
        4'd0:   begin
            Out = 7'b0111111;
        end
        4'd1:   begin
            Out = 7'b0000110;
        end
        4'd2:   begin
            Out = 7'b1011011;
        end
        4'd3:   begin
            Out = 7'b1001111;
        end
        4'd4:   begin
            Out = 7'b1100110;
        end
        4'd5:   begin
            Out = 7'b1101101;
        end
        4'd6:   begin
            Out = 7'b1111101;
        end
        4'd7:   begin
            Out = 7'b0000111;
        end
        4'd8:   begin
            Out = 7'b1111111;
        end
        4'd9:   begin
            Out = 7'b1101111;
        end
        default
            Out = 7'b0000000;
    endcase
end
endmodule
