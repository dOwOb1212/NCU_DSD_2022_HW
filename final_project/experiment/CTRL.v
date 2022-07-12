module CTRL(hsync, vsync, vga_r, vga_g, vga_b, LedOut, L_SevenSegOut, R_SevenSegOut, Enable, clk, reset, key_clk, key_data, S2);
input clk, reset, key_clk, key_data, S2;
output hsync, vsync;
output [3:0]vga_r, vga_g, vga_b;
output [7:0]Enable;
output [15:0] LedOut;
output [6:0] L_SevenSegOut, R_SevenSegOut;
wire [3:0]enable;
wire up, down, left, right, Q;
assign Enable = {enable,enable};
D2_top u1(hsync, vsync, vga_r, vga_g, vga_b, LedOut, L_SevenSegOut, R_SevenSegOut, enable,key_clk, key_data, S2, clk, reset);
endmodule