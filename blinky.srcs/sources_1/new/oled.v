`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/10 14:27:02
// Design Name: 
// Module Name: oled
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


module oled(
    input clk,
    output sda,
    output scl
    );
    
    reg scl_r = 0;
    always @ (posedge clk) scl_r <= ~scl_r;
    assign scl=scl_r;
    
endmodule
