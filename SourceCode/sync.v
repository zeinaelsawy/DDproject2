`timescale 1ns / 1ps
module sync(input clk, input rst, input sig, output sig1);
reg [1:0] meta; 

always @ (posedge clk) begin
if(rst) begin
meta[0] <= 0;
meta[1] <= 0; 
end
else begin
meta[0] <=  sig; 
meta[1] <= meta[0];
end
end
assign sig1 = meta[1];
endmodule
