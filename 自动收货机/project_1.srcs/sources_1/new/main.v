`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/29 17:07:14
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input [4:0]swt,
    input ok,
    input cancel,
    input getChange,
    output led16_B,led16_G,led16_R,
    output  [7:0] wire_disp_place,
    output  [6:0] wire_disp_number,
    output [4:0]led
    );
    
    
    reg [2:0]led16;
    reg [4:0] rled=0;
    assign led = rled;
    
    reg [10:0]count=0;
    reg [4:0]state=1;   //idle
    reg [7:0]id=0;      //商品16种
    reg [1:0]num=0;     //数量1-3
    reg [3:0]goods=0;        //商品种类
    reg [7:0]money=0;    //投入的钱
    reg [7:0]total=0;    //总价
    reg [7:0]rchange=0;  //找零
    reg [1:0]id_done=0;
  //  reg rIsInput=0; 
    
    
    wire [4:0]data_out;  //读取按键数据
    wire isInput;
    reg rst;
    
    wire [2:0] button;
    reg [2:0] button_temp;
    reg  [2:0] button_r=0;
    
    //for display
    reg [3:0]num_BCD=0;     //1-3
    reg [3:0] blank_BCD  = 4'b1111;	//illegal  number 
   // reg [3:0] num_BCD;
    reg [7:0]id_BCD=0;        //0~99
    reg [7:0]money_BCD=0;    //0~99
    reg [7:0]total_BCD=0;    //0~99
    reg [7:0]rchange_BCD=0;  //0~99
    reg [1:0]display_flag=0;
    always@(posedge clk)
    begin
    	id_BCD[3:0] <= id[3:0];
    	id_BCD[7:4] <= id[7:4];
    	num_BCD <= num;
    	if(money/100>0) money_BCD <= 8'b10011001;
    	else begin
    		money_BCD[7:4] <= money/10;
    		money_BCD[3:0] <= money%10;    		
    	end
    	
    	if(total/100>0) total_BCD <= 8'b10011001;
    	else begin
    		total_BCD[7:4] <= total/10;
    		total_BCD[3:0] <= total%10;    		
    	end
    	
    	if(rchange/100>0) rchange_BCD <= 8'b10011001;
    	else begin
    		rchange_BCD[7:4] <= rchange/10;
    		rchange_BCD[3:0] <= rchange%10;    		
    	end    	
    end 
    
    wire [31:0] all_number;
    reg [31:0] all_number_r=32'h12345678;
    assign all_number = all_number_r;
   	always@(posedge clk)
   	begin
   		if(display_flag==0)
   		all_number_r <= {rchange_BCD,total_BCD,num_BCD,blank_BCD,id_BCD}; 
   		else if(display_flag==1)
   		all_number_r <= {rchange_BCD,total_BCD,blank_BCD,blank_BCD,money_BCD}; 
   		else
   		all_number_r <= {rchange_BCD,total_BCD,num_BCD,blank_BCD,id_BCD}; 
   		//all_number_r <= {rchange_BCD,money_BCD,blank_BCD,num_BCD,id_BCD};  // 2+2+1+1+2=8
   	end
    
    parameter idle=5'b00001,            //five states
               selectGoods=5'b00010,
               chooseNum=5'b00100,
                pay=5'b01000,
                change=5'b10000;
    
    always@(posedge clk) count<=count+1;    //分频 100M/(2^11)
    
    reg [2:0] button_flag=0;
    always@(posedge clk)
    begin
            if(button!=3'b000)
            button_r <= button; 
            else if(button_flag!=3'b000)
            button_r <= 0;
            else
            button_r <= button_r;
    end
    
    always@(posedge count[10])
    begin
        button_flag = 0;
        rst = 0; 
        case(state)
        idle: begin
            led16<=3'b110;   // Red + Green = Yellow
            id<=8'b1111_1111;  
            num<=0;
            money<=8'd0;
            rchange<=8'd0;
            goods <= 0;
            total<=0;  
            rled<=0; 
            id_done<=0;      
            display_flag<=0;        
            if(isInput) state <= selectGoods;
            else state <= idle;
        end
        selectGoods: begin     
        	     
            led16=3'b001;   //blue
            if(button_r[1]) begin state <= idle; button_flag<=3'b010; end
            else begin
                if(id_done==0&&isInput==1) 
                    begin                    
                    case(data_out[3:0])             //读id第一位
                        4'b0001: begin id[7:4] <= 4'b0001; rled[4:0] <= 5'b00001; end 
                        4'b0010: begin id[7:4] <= 4'b0010; rled[4:0] <= 5'b00001; end
                        4'b0100: begin id[7:4] <= 4'b0011; rled[4:0] <= 5'b00001; end 
                        4'b1000: begin id[7:4] <= 4'b0100; rled[4:0] <= 5'b00001; end 
                        default: begin
                            id[7:4] <= 4'b0000;
                            id_done = id_done -1;                    
                            rled[4:0] <= 5'b01001;                
                        end
                    endcase
                    id_done <= id_done +1;
                    rst <= 1;
                    //rIsInput <=0;
                    end
               
                else if(id_done==1&&isInput==1) begin
                    case(data_out[3:0])             //读id第二位
                        4'b0001: begin id[3:0] <= 4'b0001; rled[4:0] <= 5'b00011; end 
                        4'b0010: begin id[3:0] <= 4'b0010; rled[4:0] <= 5'b00011; end 
                        4'b0100: begin id[3:0] <= 4'b0011; rled[4:0] <= 5'b00011; end 
                        4'b1000: begin id[3:0] <= 4'b0100; rled[4:0] <= 5'b00011; end 
                        default: begin
                            id[3:0] <= 4'b0000;
                            id_done = id_done -1;
                            rled[4:0] <= 5'b10011;
                        end
                    endcase
                    id_done <= id_done +1;
                    rst <= 1;                   
                end
                
                else if( id_done==2 && button_r[0] ) begin
                    state <= chooseNum;
                    id_done <= 0;       
                    button_flag<=3'b001;            
                end
                else state <= selectGoods;
            end
        
        end
    /*    chooseNum: 
        begin
            led16=3'b010;     //Green
            if(button_r[1]) 
            	begin			//cancel is pressed
                	id <= 0;
                	num<=0;
                	state <= selectGoods;
                	button_flag<=3'b010;
            	end
           	else 
           		begin
           		if(!num) begin          		
						case(data_out[2:0])        //读num
							3'b001: num <=1;
							3'b010: num <=2;
							3'b100: num <=3;
							default: num <=0;
						endcase
                	end
                else num <=num;	
               	if( num && button_r[0] ) 
               		begin		//                if( num && ok ) begin 
               			rst <= 1;              	
                    	case(id)
                        	4'h0: total<=total+3*num;    //A11
                        	4'h1: total<=total+4*num;    //A12
                        	4'h2: total<=total+6*num;    //A13
							4'h3: total<=total+3*num;    //A14
							4'h4: total<=total+10*num;   //A21
							4'h5: total<=total+8*num;    //A22
							4'h6: total<=total+9*num;    //A23
							4'h7: total<=total+7*num;    //A24
							4'h8: total<=total+4*num;    //A31
							4'h9: total<=total+6*num;    //A32
							4'ha: total<=total+15*num;   //A33
							4'hb: total<=total+8*num;    //A34
							4'hc: total<=total+9*num;    //A41
							4'hd: total<=total+4*num;    //A42
							4'he: total<=total+5*num;    //A43
							4'hf: total<=total+5*num;    //A44                   
							default: total<=total+0;
                    	endcase  
                    	goods <= goods+1; 
                    	num <= 0;            
                	end
            	else 
            		state <= chooseNum;  
            	if(goods>=2 || (button_r[0]&&goods==1)) begin  state <= pay;  button_flag <= 3'b001; end
            	else if(isInput && goods==1) state <= selectGoods;
            	else state <= chooseNum;         
       end
       end
        */
        chooseNum: 
        begin
            led16=3'b010;   //Green
            rst <=0;
            button_flag<=3'b000;
            if(button_r[1]) begin
                id <= 0;
                state <= selectGoods;
                button_flag<=3'b010;
           	end
            
            else 
            begin
                if(goods==1 && isInput  && id==0)
                    state <= selectGoods;                    
                else if(num && button_r[0])
                begin
                    case(id)
                    8'h11: total<=total+3*num;    //A11
                    8'h12: total<=total+4*num;    //A12
                    8'h13: total<=total+6*num;    //A13
                    8'h14: total<=total+3*num;    //A14
                    8'h21: total<=total+10*num;   //A21
                    8'h22: total<=total+8*num;    //A22
                    8'h23: total<=total+9*num;    //A23
                    8'h24: total<=total+7*num;    //A24
                    8'h31: total<=total+4*num;    //A31
                    8'h32: total<=total+6*num;    //A32
                    8'h33: total<=total+15*num;   //A33
                    8'h34: total<=total+8*num;    //A34
                    8'h41: total<=total+9*num;    //A41
                    8'h42: total<=total+4*num;    //A42
                    8'h43: total<=total+5*num;    //A43
                    8'h44: total<=total+5*num;    //A44                   
                    default: total<=total+0;
               	endcase 
               		num<=0;                
                    goods = goods +1;
                    id <= 0;
                    button_flag <= 3'b001;
                end
                else if(goods==1 && button_r[0])
                begin
                    state <= pay;
                    button_flag <= 3'b001;
                end
                else if(goods==2)
                state<= pay;
                
                else if(isInput)
                begin
                     case(data_out[2:0])        //读num
                     3'b001: num <=1;
                     3'b010: num <=2;
                     3'b100: num <=3;
                      default: num <=0;
                     endcase 
                     rst<=1;                  
                end
                else state <= chooseNum;
            end
        end
        
        pay: begin
            led16=3'b100;		//Red
            display_flag<=1;
            rst = 0;
            button_flag =0;
            if(button_r[1]) begin //cancel is pressed
                    button_flag <= 3'b010;
                    rchange <= money;
                    state <= change;
                 end
             else if(isInput)
             begin
				case(data_out[4:0])
					5'b00001: money <= money +1;
					5'b00010: money <= money +5;
					5'b00100: money <= money +10;
					5'b01000: money <= money +20;
					5'b10000: money <= money +50;
					default: money <= money +0;
				endcase
				rst <= 1;
           	end
            else if(money<total) state <= pay;
            else begin 
                rchange <= money-total;               
                state <= change;                 
            end     
        end
        change: begin
        	button_flag=0;
            led16=3'b011;		//light blue        
            if(rchange==0) state <= idle;  
            else begin
                if(button_r[2]) begin rchange <= rchange -1;  button_flag<=3'b100; end
                else rchange <= rchange;
                state <= change;
            end
        end
        default: state<=idle;
        endcase       
       
    end
    
    assign {led16_R,led16_G,led16_B}=led16;
    
    key u1(
    .clk(clk),
    .rst(rst),
    .swt(swt),
    .isInput(isInput),
    .data(data_out)
    //.led(led)
    );
    
    key_delay u2(
    .clk(clk),
    .ok(ok),
    .cancel(cancel),
    .getChange(getChange),
    .button_out(button)
    );
    
    display u3(
    .all_number(all_number),
    .clk(clk),
    .wire_disp_place(wire_disp_place),
    .wire_disp_number(wire_disp_number)
    );
endmodule
