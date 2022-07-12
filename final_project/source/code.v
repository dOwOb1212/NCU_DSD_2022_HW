`timescale 1ns / 1ps

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
        counter=26'b0;
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