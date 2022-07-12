module VGA_display(clk, rst, hsync, vsync, vga_r, vga_g, vga_b);
input           clk;
input           rst;

output          hsync,vsync;
output [3:0]    vga_r, vga_g, vga_b;


wire            pclk;
wire            valid;
wire [9:0]      h_cnt,v_cnt;
reg [11:0]      vga_data;
wire [11:0]     PacMan_rom_dout, fruit_rom_dout, ghost_rom_dout;
reg [12:0]      PacMan_rom_addr, fruit_rom_addr, ghost_rom_addr;  //2^14=16384
reg [9:0]       PacMan_y = 10'd406, PacMan_x = 10'd6, fruit_x = 10'd561, fruit_y = 10'd6, ghost_x = 10'd241, ghost_y = 10'd321;


parameter [6:0] logo_length=7'd70;
parameter [6:0] logo_height=7'd70; //169*78=13182<16384

wire ctrlclk;

dcm_25M u0 ( 
        // Clock in ports
        .clk_in1(clk),      // input clk_in1
        // Clock out ports
        .clk_out1(ctrlclk),     // output clk_out1
        .resetn(rst)
    );


PacMan_rom u1 (
      .clka(ctrlclk),    // input wire clka
      .addra(PacMan_rom_addr),  // input wire [13 : 0] addra
      .douta(PacMan_rom_dout)  // output wire [11 : 0] douta
    );

fruit_rom u2 (
      .clka(ctrlclk),    // input wire clka
      .addra(fruit_rom_addr),  // input wire [13 : 0] addra
      .douta(fruit_rom_dout)  // output wire [11 : 0] douta
    );
    
ghost_rom u3 (
      .clka(ctrlclk),    // input wire clka
      .addra(ghost_rom_addr),  // input wire [13 : 0] addra
      .douta(ghost_rom_dout)  // output wire [11 : 0] douta
    );

// module on p14.
SyncGeneration u4 (
        .pclk(ctrlclk),
        .reset(rst),
        .hSync(hsync),
        .vSync(vsync),
        .dataValid(valid),
        .hDataCnt(h_cnt),
        .vDataCnt(v_cnt)
    );

assign PacMan_area = ((v_cnt >= PacMan_y) & (v_cnt <= PacMan_y + logo_height - 1) & (h_cnt >= PacMan_x) & (h_cnt <= PacMan_x + logo_length - 1)) ? 1'b1 : 1'b0;
assign fruit_area = ((v_cnt >= fruit_y) & (v_cnt <= fruit_y + logo_height - 1) & (h_cnt >= fruit_x) & (h_cnt <= fruit_x + logo_length - 1)) ? 1'b1 : 1'b0;
assign ghost_area = ((v_cnt >= ghost_y) & (v_cnt <= ghost_y + logo_height - 1) & (h_cnt >= ghost_x) & (h_cnt <= ghost_x + logo_length - 1)) ? 1'b1 : 1'b0;
assign bricks_area= ((h_cnt>80)&(h_cnt<=240)&(v_cnt>80)&(v_cnt<=160)|
                    (h_cnt>5)&(h_cnt<=80)&(v_cnt>160)&(v_cnt<=320)|
                    (h_cnt>80)&(h_cnt<=240)&(v_cnt>320)&(v_cnt<=400)|                               
                    (h_cnt>320)&(h_cnt<=480)&(v_cnt>240)&(v_cnt<=320)|
                    (h_cnt>320)&(h_cnt<=480)&(v_cnt>80)&(v_cnt<=160)|
                    (h_cnt>560)&(h_cnt<=640)&(v_cnt>160)&(v_cnt<=320)|
                    (h_cnt>0)&(h_cnt<=240)&(v_cnt>0)&(v_cnt<=5)|
                    (h_cnt>320)&(h_cnt<=640)&(v_cnt>0)&(v_cnt<=5)|
                    (h_cnt>0)&(h_cnt<=5)&(v_cnt>5)&(v_cnt<=480)|
                    (h_cnt>635)&(h_cnt<=640)&(v_cnt>5)&(v_cnt<=480)|
                    (h_cnt>5)&(h_cnt<=240)&(v_cnt>475)&(v_cnt<=480)|
                    (h_cnt>320)&(h_cnt<=635)&(v_cnt>475)&(v_cnt<=480)
                    );

always @(posedge ctrlclk or negedge rst)
begin: logo_display
    if (!rst) begin
         PacMan_rom_addr<=13'd0;
         fruit_rom_addr<=13'd0;
         ghost_rom_addr<=13'd0;
         vga_data <= 12'd0;
    end
    else
    begin
        if (valid == 1'b1)
        begin
            if (PacMan_area == 1'b1)
            begin
               PacMan_rom_addr <= PacMan_rom_addr + 13'd1;
               vga_data <= PacMan_rom_dout;
            end
            else if(fruit_area == 1'b1)
            begin
               fruit_rom_addr <= fruit_rom_addr + 13'd1;
               vga_data <= fruit_rom_dout;
            end
            else if(ghost_area == 1'b1)
            begin
                ghost_rom_addr <= ghost_rom_addr + 13'd1;
                vga_data <= ghost_rom_dout;
            end
            else if(bricks_area == 1'b1)
            begin
                vga_data <= 12'b000000001111;
            end
            else
            begin
               ghost_rom_addr <= ghost_rom_addr;
               PacMan_rom_addr <= PacMan_rom_addr;
               fruit_rom_addr <= fruit_rom_addr;
               vga_data <= 12'hfff;
            end
        end
        else begin
            vga_data <= 12'h000;
            if (v_cnt == 0)
            begin
               ghost_rom_addr <= 13'b0;
               PacMan_rom_addr <= 13'b0;
               fruit_rom_addr <= 13'b0;
            end
            else
            begin
               ghost_rom_addr <= ghost_rom_addr;
               PacMan_rom_addr <= PacMan_rom_addr;
               fruit_rom_addr <= fruit_rom_addr;
            end
        end
    end
end

assign {vga_r,vga_g,vga_b} = vga_data;

endmodule
