`timescale 1ns / 1ps

module Binary_Counter # (parameter x =3, n=6)(input clk, reset, en, updown, output [x-1:0] count);
reg [x-1:0] count;
always @ (posedge clk, posedge reset)
begin 
    if(reset == 1)
        count <= 0;
    else
    if (en == 1)
        if(updown)
            if (count== n-1) 
                count <=0;
            else 
                count <=count+1;
        else
             if (count== 0) 
                count <=n-1;
            else 
                count <=count-1;           
    else
        count <= count;
    
end 
endmodule
