`timescale 1ns / 1ps

module MinHour(
    input clk_out_seconds, 
    input reset, 
    input enable_seconds,
    input Updown,  
    input count_hours,
    input count_min,
    output  [3:0] seconds_units, 
    output  [2:0] seconds_tens, 
    output  [3:0] minutes_units, 
    output  [2:0] minutes_tens,
    output  [3:0] hours_units,
    output  [1:0] hours_tens
    );
    
 
 wire[5:0] countsec;
 wire[5:0] countMin;
 wire[4:0] counthours;
 Binary_Counter #(6,60) Seconds( clk_out_seconds, reset, enable_seconds, Updown, countsec);
 Binary_Counter #(6,60) Minutes( clk_out_seconds, reset, enable_seconds ? (countsec == 59): count_min, Updown,countMin);
 Binary_Counter # (5, 24) Hours( clk_out_seconds, reset, enable_seconds ? (countMin == 59 & countsec == 59):count_hours , Updown, counthours);
 
 assign seconds_units = countsec % 10;
 assign seconds_tens = countsec  / 10;
 assign minutes_units = countMin % 10;
 assign minutes_tens = countMin / 10;
 assign hours_units = counthours % 10;
 assign hours_tens = counthours / 10;
 

endmodule
