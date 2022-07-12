module State(NS, S1, S2, S3, S4, reset, clk, drink);
input S1, S2, S3, S4, reset, clk;
input [7:0]drink;
output reg [1:0]NS;
reg [1:0]CS;
parameter Init = 2'b00, Select = 2'b01, Pay = 2'b10, Done = 2'b11;
parameter C = 8'h21;
parameter S = 8'h1B;
parameter F = 8'h2B;
parameter P = 8'h4D;
always @(posedge clk or posedge reset) begin: SEQ
    if (!reset)
        CS <= Init;
    else
        CS <= NS;
    end
always @(*) begin: COMB
    NS = Init;
    case (CS)
        Init: begin
            if(drink == C || drink == S || drink == F || drink == P)
                NS = Select;
            else
                NS = Init;
        end
        Select: begin
            if (S2 || S3 || S4)
                NS = Pay;
            else
                NS = Select;
        end
        Pay: begin
            if (S1)
                NS = Done;
            else
                NS = Pay;
        end
        Done: begin
                NS = Done;
        end
    endcase
end
endmodule
