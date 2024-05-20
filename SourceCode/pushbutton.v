`timescale 1ns / 1ps
module pushbutton(input clk, input reset, input in, output out );
    wire d_out;
    wire s_out;
    
    debouncer d( .clk(clk), .rst(rst), .in(in),  .out(d_out));
    sync s(.clk(clk), .rst(rst), .sig(d_out), .sig1(s_out));
    rising_edge rs(.clk(clk), .rst(rst), .w(s_out), .z(out));
    
endmodule
