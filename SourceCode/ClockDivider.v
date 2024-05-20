`timescale 1ns / 1ps


module ClockDivider #(parameter n = 50000000)(input clk, rst, en, output reg clk_out);
wire[31:0] count;

Binary_Counter #(32,n) counterMod(.clk(clk),.reset(rst), .en(en),.updown(1'b1), .count(count));
always @ (posedge clk, posedge rst)
begin
    if (rst)
        clk_out<=0;
    else if(count == n-1)
        clk_out<=~clk_out;
end
endmodule
