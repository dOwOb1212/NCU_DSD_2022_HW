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