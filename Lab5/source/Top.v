module Top(hsync, vsync, vga_r, vga_g, vga_b, LedOut, SevenSegOut, enable, S1, S0, S3, S4, clk, reset);
output  hsync,vsync;
output  [3:0] enable;
output  [3:0] vga_r, vga_g, vga_b;
output  [15:0] LedOut;
output  [6:0] SevenSegOut;
input S1, S0, S3, S4, clk, reset;
wire S1_D, S0_D, S3_D, S4_D, L_clk, S_clk, g_clk;
reg TouchFruit, TouchGhost;
wire [1:0] State;
wire [2:0] PacMan_x, PacMan_y, ghost_x, ghost_y;
parameter fruit_x = 3'd7, fruit_y = 3'd0;
debounce S1_Debounce(clk, S1, S1_D, reset);
debounce S0_Debounce(clk, S0, S0_D, reset);
debounce S3_Debounce(clk, S3, S3_D, reset);
debounce S4_Debounce(clk, S4, S4_D, reset);
state U0(State, reset, clk, TouchFruit, TouchGhost);
PacMan_move U1(PacMan_x, PacMan_y, S1_D, S0_D, S3_D, S4_D, clk, reset, State);
clkCounter U2(L_clk, S_clk, g_clk, clk, reset);
ghost_move U3(ghost_x, ghost_y, g_clk, reset, State);
ScoreAndStep U4(SevenSegOut, enable, PacMan_x, PacMan_y, TouchFruit, S_clk, clk, reset);
LedMap U5(LedOut, State, L_clk, reset);
VGA_display U6(clk, reset, hsync, vsync, vga_r, vga_g, vga_b, PacMan_x, PacMan_y, ghost_x, ghost_y);
always @(PacMan_x or PacMan_y or ghost_x or ghost_y) begin
    if(PacMan_x == ghost_x && PacMan_y == ghost_y)
        TouchGhost = 1'b1;
    else
        TouchGhost = 1'b0;
    if(PacMan_x == fruit_x && PacMan_y == fruit_y)
        TouchFruit = 1'b1;
    else
        TouchFruit = 1'b0;
end

endmodule
