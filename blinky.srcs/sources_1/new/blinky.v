`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/19 15:42:29
// Design Name: 
// Module Name: blinky
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blinky(
    input clk,
    input [1:0] sw,
    output [3:0]led
    );
    reg [24:0] count = 0;
    integer i;
    reg [3:0] rLed;
    
    always @(posedge clk)   count <= count + 1;
    
    always @(posedge count[24]) 
    begin
        case(sw)
        2'b00: rLed <= 4'b0000;
        2'b01:
            begin
            if(i==3)
                begin
                rLed[i]=0;
                i=0;
                rLed[i]=1;
                end
            else
                begin
                rLed[i]=0;
                i=i+1;
                rLed[i]=1;
                end
            end
        2'b10:
            begin
            if(i==0)
                begin
                rLed[i]=0;
                i=3;
                rLed[i]=1;
                end
            else
                begin
                rLed[i]=0;
                i=i-1;
                rLed[i]=1;
                end
            end
        2'b11: rLed=4'b1111;
        endcase    
    end
    assign led=rLed;
    
endmodule
