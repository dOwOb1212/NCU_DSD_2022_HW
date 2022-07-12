module elevator (E1_Y, E2_Y, E3_Y, clk, reset, state);
input clk, reset;
input [1:0] state;
output reg [3:0] E1_Y, E2_Y, E3_Y;

parameter Stop = 2'b00, Movement = 2'b01 , Elevation = 2'b10, Die = 2'b11;

 always @(posedge clk or posedge reset) begin
 	if (reset) begin
 		E1_Y <= 2;
 		E2_Y <= 6;
 		E3_Y <= 10;
 	end
 	else if (state == Movement || state == Elevation) begin
 		if (E1_Y == 11) begin
 			E1_Y <= 0;
 			E2_Y <= E2_Y + 1;
 			E3_Y <= E3_Y + 1;
 		end
 		else if (E2_Y == 11) begin
	 		E1_Y <= E1_Y + 1;
 			E2_Y <= 0;
 			E3_Y <= E3_Y + 1;
 		end
		else if (E3_Y == 11) begin
 			E1_Y <= E1_Y + 1;
	 		E2_Y <= E2_Y + 1;
 			E3_Y <= 0;
		end
 		else begin
 			E1_Y <= E1_Y + 1;
 			E2_Y <= E2_Y + 1;
 			E3_Y <= E3_Y + 1;
 		end
 	end
 end
 endmodule
