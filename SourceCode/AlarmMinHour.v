`timescale 1ns / 1ps


module AlarmMinHour(
    input clk_out_seconds, 
    input reset, 
    input Updown,  
    input alarm_count_hours,
    input alarm_count_min, 
    output  [3:0] alarm_minutes_units, 
    output  [2:0] alarm_minutes_tens,
    output  [3:0] alarm_hours_units,
    output  [1:0] alarm_hours_tens
    );
    
 
 wire[5:0] countMin;
 wire[4:0] counthours;
 Binary_Counter #(6,60) Minutes( clk_out_seconds, reset, alarm_count_min, Updown,countMin);
 Binary_Counter # (5, 24) Hours( clk_out_seconds, reset, alarm_count_hours , Updown, counthours);
 
 assign alarm_minutes_units = countMin % 10;
 assign alarm_minutes_tens = countMin / 10;
 assign alarm_hours_units = counthours % 10;
 assign alarm_hours_tens = counthours / 10;
 
 
endmodule
