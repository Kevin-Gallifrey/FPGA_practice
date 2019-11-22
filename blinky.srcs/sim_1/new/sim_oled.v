`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/10 15:35:10
// Design Name: 
// Module Name: sim_oled
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


module sim_oled();
    reg clk;
    wire scl,sda;
    
    oled oled_sim(
        .clk(clk),
        .scl(scl),
        .sda(sda)
    );
    initial
    begin
    clk=0;
    #20 $stop;
    end
    
    always #1 clk=~clk;
  
endmodule
