`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/30 13:50:40
// Design Name: 
// Module Name: key
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


module key(
    input clk,
    input rst,
    input [4:0] swt,
    output isInput,
    output [4:0]data
    //output [4:0]led
    );
    
    reg [19:0]count=0;
    reg [4:0]swt_last=0;
    reg [4:0]rdata=0;
    //reg [4:0]rled=0;
    reg isInput_reg=0;

   always@(posedge clk) count<=count+1;    //分频 100M/(2^20)
    
   always@(posedge count[19] or posedge rst)      //检测5个swt的上升沿
    begin
        if(rst) begin
            rdata <= 0; 
            isInput_reg <=0; 
            swt_last <= swt; 
        end
        else begin
        if(swt_last[0] == 0 && swt[0] == 1) begin
            rdata<=5'b00001;
           // rled[0]<=1;
            swt_last[0] <= swt[0];
            isInput_reg <= 1;         
        end
        
         else if(swt_last[1] == 0 && swt[1] == 1) begin
            rdata<=5'b00010;
            //rled[1]<=1;
            swt_last[1] <= swt[1];
            isInput_reg <= 1;          
        end
        
        else if(swt_last[2] == 0 && swt[2] == 1) begin
            rdata<=5'b00100;
            //rled[2]<=1;
            swt_last[2] <= swt[2];
            isInput_reg <= 1;         
        end
             
        else if(swt_last[3] == 0 && swt[3] == 1) begin
            rdata<=5'b01000;
           // rled[3]<=1;
            swt_last[3] <= swt[3];
            isInput_reg <= 1;    
        end
     
        else if(swt_last[4] == 0 && swt[4] == 1) begin
            rdata<=5'b10000;
           // rled[4]<=1;
            swt_last[4] <= swt[4];
            isInput_reg <= 1;          
        end         
                  
        else 
            begin
            isInput_reg <=0; 
            swt_last <= swt;             
            end 
         end             
    end
    
    assign data=rdata;
    assign isInput=isInput_reg;
    //assign led=rled;
       
endmodule

/*
module key(
    input clk,
    input [4:0] swt,
    output isInput,
    output [4:0]data
    );
    
    reg [15:0]count=0;
    reg [4:0]swt_last=0;
    reg [4:0]rdata=0;
    reg isInput_reg=0;
    
    always@(posedge clk) count<=count+1;    //分频 100M/(2^16)
    
    always@(posedge count[15])      //检测5个swt的上升沿
    begin
        if(swt_last[0] == 0 && swt[0] == 1) begin
            rdata[0]<=1;
            swt_last[0] <= swt[0];
            isInput_reg <= 1;
        end
        else begin
            rdata[0] <= 0;
            swt_last[0] <= swt[0];
            isInput_reg <= 0;
        end
        
        if(swt_last[1] == 0 && swt[1] == 1) begin
            rdata[1]<=1;
            swt_last[1] <= swt[1];
            isInput_reg <= 1;
        end
        else begin
            rdata[1] <= 0;
            swt_last[0] <= swt[0];
            isInput_reg <= 0;
        end
        
        if(swt_last[2] == 0 && swt[2] == 1) begin
            rdata[2]<=1;
            swt_last[2] <= swt[2];
            isInput_reg <= 1;
        end
        else begin
            rdata[2] <= 0;
            swt_last[2] <= swt[2];
            isInput_reg <= 0;
        end
        
        if(swt_last[3] == 0 && swt[3] == 1) begin
            rdata[3]<=1;
            swt_last[3] <= swt[3];
            isInput_reg <= 1;
        end
        else begin
            rdata[3] <= 0;
            swt_last[3] <= swt[3];
            isInput_reg <= 0;
        end
        
        if(swt_last[4] == 0 && swt[4] == 1) begin
            rdata[4]<=1;
            swt_last[4] <= swt[4];
            isInput_reg <= 1;
        end         
        else begin
            rdata[4] <= 0;
            swt_last[4] <= swt[4]; 
            isInput_reg <= 0;
        end                      
    end
    
    assign data=rdata;
    assign isInput=isInput_reg;
       
endmodule
*/