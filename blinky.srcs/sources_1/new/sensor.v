`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/03 15:29:47
// Design Name: 
// Module Name: sensor
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


module sensor(
    input jd,
    input clk,
    output led6_r,led6_g
    );
    reg [24:0] count = 0;
    reg [1:0] light;
    always @(posedge clk)   count <= count + 1;
    always @(posedge count[24])
    begin
        if(jd)
            light=2'b01;
        else light=2'b10;
    end
    assign {led6_r,led6_g}=light;
endmodule
