module score(out[6:0], key, goal);
output [6:0]out;
input key, goal;
assign out = key*50 + goal*50;
endmodule
