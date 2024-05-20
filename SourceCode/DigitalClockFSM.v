`timescale 1ns / 1ps

module DigitalClockFSM(
    input clk,
    input reset,
    input BTNC_b,  // Button for toggling between modes
    input BTNL_b,  // Button to cycle through parameters left
    input BTNR_b,  // Button to cycle through parameters right
    input BTNU_b,  // Button to increment current parameter
    input BTND_b,  // Button to decrement current parameter
    output [6:0] seg,  // 7-segment display segments
    output [3:0] an,  // 7-segment display anodes
    output reg LD0, LD12, LD13, LD14, LD15,  // LED outputs for state reflection
    output reg DP,
    output sound
);

// add v7 decimal point

wire BTNC, BTNL, BTNR, BTNU, BTND, clk_out;

pushbutton c(.in(BTNC_b), .clk(clk_out), .reset(reset), .out(BTNC));
pushbutton l(.in(BTNL_b), .clk(clk_out), .reset(reset), .out(BTNL));
pushbutton r(.in(BTNR_b), .clk(clk_out), .reset(reset), .out(BTNR));
pushbutton u(.in(BTNU_b), .clk(clk_out), .reset(reset), .out(BTNU));
pushbutton d(.in(BTND_b), .clk(clk_out), .reset(reset), .out(BTND));

// State definitions
parameter [2:0] CLOCK_ALARM = 2'b00,ADJUST_TIME_HOUR = 2'b01,ADJUST_TIME_MINUTE = 2'b10, ADJUST_ALARM_HOUR = 2'b11, ADJUST_ALARM_MINUTE = 3'b100, ALARM = 3'b101;

reg [2:0] state, next_state;
wire zflag;

reg blink;  // Blink signal for LED and decimal points
reg clockinput;
reg countHours;
reg countMIn;
reg alarm_count_hours;
reg alarm_count_min;
// Instantiate the digital clock module
wire [6:0] segments;
wire [3:0] anode_active;
reg enable =1'b1;
 reg Updown;
 reg clock_alarm_display;
digital_clock clock_inst(.clk_out_seconds(clockinput), .counthour(countHours), .countmin(countMIn),.clk_out_200(clk_out),.reset(reset), .display(clock_alarm_display), .alarm_count_min(alarm_count_min), .alarm_count_hours(alarm_count_hours),.segments(segments),.anode_active(anode_active),.en(enable),.updown(Updown),.zflag(zflag));
 ClockDivider #(250000)clock (.clk(clk),.rst(reset),.en(1'b1),.clk_out(clk_out));

ClockDivider #(50000000)secClk (.clk(clk), .rst(reset), .en(1'b1), .clk_out(clk1HZ));
 
// Process for state transitions
always @(posedge clk_out, posedge reset) begin
    if (reset) begin
        state <= CLOCK_ALARM;
    end else begin
        state <= next_state;
    end
end

// Determine next state and manage parameter adjustments
always @(*) begin
    next_state = state;  // Default to hold current state

    case(state)
        CLOCK_ALARM: 
        begin
        clock_alarm_display = 1'b0;
        
             
            if (zflag)begin
             next_state = ALARM;
             enable=1'b1;
             LD0 = clk1HZ; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
         
             clockinput = clk_out;
             Updown = 1'd1;
             countHours = 1'b0;
             countMIn = 1'b0;
             alarm_count_hours = 1'b0;
             alarm_count_min = 1'b0;
            end
            else if (BTNC) 
            begin
             next_state = ADJUST_TIME_HOUR;
             enable=1'b0;
             LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
             clockinput = clk_out;
             Updown = 1'd1;
             countHours = 1'b0;
             countMIn = 1'b0;
             alarm_count_hours = 1'b0;
             alarm_count_min = 1'b0;
             end
              else 
              begin
                  LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0; 
                  enable = 1'b1;
                  next_state = state;
                  Updown = 1'd1;
                  clockinput = clk1HZ;
                 countHours = 1'b0;
                 countMIn = 1'b0;
                 alarm_count_hours = 1'b0;
                 alarm_count_min = 1'b0;
               end
        end
        ADJUST_TIME_HOUR: 
        begin
        clock_alarm_display = 1'b0;
            if (BTNC) 
            begin
                next_state = CLOCK_ALARM;
                enable=1'b1;
                LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                Updown =1'b1;
                clockinput = clk1HZ;
                 countHours = 1'b0;
                 countMIn = 1'b0;
                 alarm_count_hours = 1'b0;
                 alarm_count_min = 1'b0;
             end
           else if (BTNR) 
           begin
                next_state = ADJUST_TIME_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 1; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                 countHours = 1'b0;
                 countMIn = 1'b0;
                 alarm_count_hours = 1'b0;
                 alarm_count_min = 1'b0;
            end
           else if (BTNL) 
           begin
                next_state = ADJUST_ALARM_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 1;
                enable=1'b0; 
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNU) 
           begin
                next_state = ADJUST_TIME_HOUR;
                LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b1;
                countMIn = 1'b0;  
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;              
            end
            else if (BTND) 
           begin
                next_state = ADJUST_TIME_HOUR;
                LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd0;
                clockinput = clk_out;
                countHours = 1'b1;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;                
            end
            else 
            begin
                LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
                enable = 1'b0;
                next_state = state;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;              
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
        end
        
        ADJUST_TIME_MINUTE: 
        begin
        clock_alarm_display = 1'b0;
            if (BTNC) 
            begin
                next_state = CLOCK_ALARM;
                enable=1'b1;
                LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                Updown =1'b1;
                clockinput = clk1HZ;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
             end
           else if (BTNR) 
           begin
                next_state = ADJUST_ALARM_HOUR;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 1; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNL) 
           begin
                next_state = ADJUST_TIME_HOUR;
                LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNU) 
           begin
                next_state = ADJUST_TIME_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 1; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b1;  
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;              
            end
            else if (BTND) 
           begin
                next_state = ADJUST_TIME_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 1; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd0;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b1;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;               
            end
            else 
            begin
                LD0 = 1; LD12 = 0; LD13 = 1; LD14 = 0; LD15 = 0;
                enable = 1'b0;
                next_state = state;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;                
                
            end
        end



        ADJUST_ALARM_HOUR: 
        begin
        clock_alarm_display = 1'b1;
            if (BTNC) 
            begin
                next_state = CLOCK_ALARM;
                enable=1'b1;
                LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                Updown =1'b1;
                clockinput = clk1HZ;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
             end
           else if (BTNR) 
           begin
                next_state = ADJUST_ALARM_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 1;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNL) 
           begin
                next_state = ADJUST_TIME_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 1; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNU) 
           begin
                next_state = ADJUST_ALARM_HOUR;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 1; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b1;
                alarm_count_min = 1'b0;              
            end
            else if (BTND) 
           begin
                next_state = ADJUST_ALARM_HOUR;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 1; LD15 = 0;
                enable=1'b0;
                Updown = 1'd0;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0; 
                alarm_count_hours = 1'b1;
                alarm_count_min = 1'b0;               
            end
            else 
            begin
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 1; LD15 = 0;
                enable = 1'b0;
                next_state = ADJUST_ALARM_HOUR;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;  
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;              
                
            end
        end
        
        ADJUST_ALARM_MINUTE: 
        begin
        clock_alarm_display = 1'b1;
            if (BTNC) 
            begin
                next_state = CLOCK_ALARM;
                enable=1'b1;
                LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                Updown =1'b1;
                clockinput = clk1HZ;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
             end
           else if (BTNR) 
           begin
                next_state = ADJUST_TIME_HOUR;
                LD0 = 1; LD12 = 1; LD13 = 0; LD14 = 0; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNL) 
           begin
                next_state = ADJUST_ALARM_HOUR;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 1; LD15 = 0;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;
            end
           else if (BTNU) 
           begin
                next_state = ADJUST_ALARM_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 1;
                enable=1'b0;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b1;           
            end
            else if (BTND) 
           begin
                next_state = ADJUST_ALARM_MINUTE;
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 1;
                enable=1'b0;
                Updown = 1'd0;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b1;                
            end
            else 
            begin
                LD0 = 1; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 1;
                enable = 1'b0;
                next_state = state;
                Updown = 1'd1;
                clockinput = clk_out;
                countHours = 1'b0;
                countMIn = 1'b0;
                alarm_count_hours = 1'b0;
                alarm_count_min = 1'b0;                
                
            end
        end
        ALARM:
        begin
        clock_alarm_display = 1'b0;
            if(BTNC | BTNU | BTND | BTNR | BTNL)begin
                 next_state = CLOCK_ALARM;
                 enable=1'b1;
                 LD0 = 0; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                 Updown =1'b1;
                 clockinput = clk1HZ;
                 countHours = 1'b0;
                 countMIn = 1'b0;
                 alarm_count_hours = 1'b0;
                 alarm_count_min = 1'b0;
                 end
            else begin
                 next_state = ALARM;
                 enable=1'b1;
                 LD0 = clk1HZ; LD12 = 0; LD13 = 0; LD14 = 0; LD15 = 0;
                 clockinput = clk1HZ;
                 Updown = 1'd1;
                 countHours = 1'b0;
                 countMIn = 1'b0;
                 alarm_count_hours = 1'b0;
                 alarm_count_min = 1'b0;
            end
        end
    endcase
end 

always@(anode_active) begin
if (reset)
      DP =1'b1;

else if(anode_active == 4'b1011 & clk1HZ& enable)
         DP =1'b0;
else
     DP = 1'b1;
end


assign sound = (state == ALARM) ? LD0 : 1'b0;
assign seg = segments;
assign an = anode_active;

endmodule
