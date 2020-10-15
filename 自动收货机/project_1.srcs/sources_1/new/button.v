`timescale 1ns / 1ps

/*
module main(
    input [7:0] swt, 
    output [7:0] led,[0:6] disp_number,[0:7] disp_place
    );
    
    assign led[0] = ~swt[0];
    assign led[1] = swt[1] & ~swt[2];
    assign led[3] = swt[2] & swt[3];
    assign led[2] = led[1] | led[3];
    
    assign led[7:4] = swt[7:4];
    
    assign disp_place[0] = 1;
    assign disp_place[1] = 0;
    assign disp_number[0] = swt[0];
    assign disp_number[1] = swt[1];
    assign disp_number[2] = swt[2];
    assign disp_number[3] = swt[3];
    assign disp_number[4] = swt[4];
    assign disp_number[5] = swt[5];
    assign disp_number[6] = swt[6];
    
endmodule
*/

/*
module display(
    //input [0:7] display_place,
    //input [31:0] all_number, //4位BCD
    input clk,
    output  [7:0] wire_disp_place,
    output  [6:0] wire_disp_number
);
    reg [7:0] disp_place;
    assign wire_disp_place = disp_place;
    reg [6:0] disp_number;
    assign wire_disp_number = disp_number;
    reg [19:0] times;  
    reg [3:0] n;
    reg [6:0] number[7:0];
    initial times = 0; 
    
    reg [19:0] count = 19'b0;
     reg  clk_1k = 1'b0;
     //1K时钟
     always @ (posedge clk)  
         begin  
             if(count == 100000)  
                 begin
                     count <= 19'b0;
                     clk_1k <= ~clk_1k;
                 end
             else 
                 count <= count + 19'b1;
         end
     
    
    reg [31:0] all_number=32'h12345678; //4位BCD
    always @ (posedge clk)  
        begin  
            if(times == 800000)  
                times = 20'b0;
            else 
                times = times + 20'b1;
        end
    
    reg [3:0] i;
    reg [3:0] temp;
   always @ (posedge clk)
        begin
            for(i=0;i<8;i=i+1)
            begin
                case(i)
                    0: temp = all_number[3:0];
                    1: temp = all_number[7:4];
                    2: temp = all_number[11:8];
                    3: temp = all_number[15:12];
                    4: temp = all_number[19:16];
                    5: temp = all_number[23:20];
                    6: temp = all_number[27:24];
                    7: temp = all_number[31:28];                    
                endcase
                case(temp)
                    4'b0000: number[i] <= 7'b1000000; //0
                    4'b0001: number[i] <= 7'b1111001  ;
                    4'b0010: number[i] <= 7'b0100100  ;
                    4'b0011: number[i] <= 7'b0110000  ;
                    4'b0100: number[i] <= 7'b0011001  ; //4
                    4'b0101: number[i] <= 7'b0010010  ;
                    4'b0110: number[i] <= 7'b0000010  ;
                    4'b0111: number[i] <= 7'b1111000  ; 
                    4'b1000: number[i] <= 7'b0000000  ;
                    4'b1001: number[i] <= 7'b0010000  ; //9
                    default: number[i] <= 7'b111_1111; //非法码 不亮                                      
                endcase 
            end
        end
        
        
    always@ (posedge clk)  
        begin
             n <= times / 100000;
            case(n)
                3'b000: 
                    begin
                        disp_place<=8'b1111_1110;
                        disp_number <= number[0]; //0
                    end
                3'b001: 
                    begin
                        disp_place<=8'b1111_1101;
                        disp_number <= number[1]; //0
                    end
                3'b010:
                    begin 
                        disp_place<=8'b1111_1011;
                        disp_number <= number[2]; //0
                    end
                3'b011: 
                    begin 
                        disp_place<=8'b1111_0111;
                        disp_number <= number[3]; //0
                    end
                3'b100: 
                    begin 
                        disp_place<=8'b1110_1111;
                        disp_number <= number[4]; //0
                     end
                3'b101: 
                     begin 
                        disp_place<=8'b1101_1111;
                        disp_number <= number[5]; //0
                     end               
                3'b110: 
                     begin 
                        disp_place<=8'b1011_1111;
                        disp_number <= number[6]; //0
                     end                   
                3'b111: 
                      begin 
                        disp_place<=8'b0111_1111;
                        disp_number <= number[7]; //0
                      end   
                 default:
                    begin
                        disp_place<=8'b1111_1111;
                        disp_number<=7'b111_1111;   
                    end                 
            endcase
        end

endmodule
*/
//2、按键消抖模块：
module key_delay(  
	input clk,
    input  ok,
    input cancel,
    input getChange,
    //output  [15:0] led,
    output [2:0] button_out
    );
	reg [19:0] delay_count;
	reg  [2:0] key_scan;
    reg [11:0]clk_slow=0;
    
    always@(posedge clk) clk_slow<=clk_slow+1;    //分频 100M/(2^12)
    
	always@(posedge clk)
	begin
	        begin
	            if(delay_count == 20'd999_999) //20ms
	                begin
	                    delay_count <= 20'd0;
	                    key_scan <= {getChange,cancel,ok};
	                end 
	            else 
	                delay_count <= delay_count + 20'd1;
	        end
	end
	reg [2:0] key_scan_r;
	always@(posedge clk)
		key_scan_r <= key_scan;
		
	wire [2:0]flag_key = key_scan_r&(~key_scan);
	//reg  [3:0]press_count=0;
	//reg [15:0] led_temp;
	reg [2:0] button_out_r=0;
	assign button_out = button_out_r;
	//assign led = led_temp;
	always @ (posedge clk) //检测时钟的上升沿和复位的下降沿
		begin 
		  if(flag_key[0])
		      button_out_r <= 3'b001;
		  else if(flag_key[1])
		      button_out_r <= 3'b010;
		  else if(flag_key[2])
		      button_out_r <= 3'b100;
		  else
		      button_out_r <= 3'b000;
		      /*
		  case(press_count)
		  1: led_temp <= 16'b 0000_0000_0000_0001;
		  2: led_temp <= 16'b 0000_0000_0000_0011;
		  3: led_temp <= 16'b 0000_0000_0000_0111;
		  4: led_temp <= 16'b 0000_0000_0000_1111;
		  5: led_temp <= 16'b 0000_0000_0001_1111;
          6: led_temp <= 16'b 0000_0000_0011_1111;
          7: led_temp <= 16'b 0000_0000_0111_1111;
          8: led_temp <= 16'b 0000_0000_1111_1111;
		  9: led_temp <= 16'b 0000_0001_1111_1111;
          10: led_temp <= 16'b 0000_0011_1111_1111;
          11: led_temp <= 16'b 0000_0111_1111_1111;
          12: led_temp <= 16'b 0000_1111_1111_1111;
          13: led_temp <= 16'b 0001_1111_1111_1111;
          14: led_temp <= 16'b 0011_1111_1111_1111;
          15: led_temp <= 16'b 0111_1111_1111_1111;

          0: led_temp <= 16'b 0000_0000_0000_0000;
          default: led_temp <= 16'b 0000_0000_0000_0000;
		  endcase
		  */
		end
endmodule


/*
module keyboard(
    input  [3:0] row,  //row
    input clk,
    output [3:0] col,   //col
    output [15:0] led
);
    reg [19:0] times = 19'b0;
    reg  clk_1k = 1'b0;
    //1K时钟
    always @ (posedge clk)  
        begin  
            if(times == 100000)  
                begin
                    times <= 19'b0;
                    clk_1k <= ~clk_1k;
                end
            else 
                times <= times + 19'b1;
        end
    
    
    reg [3:0] col;
    reg [3:0] key_value;
    reg [2:0] state; //标志位
    reg key_flag;
    reg [3:0] col_reg;  //寄存扫描列值;
    reg [3:0] row_reg;  //寄存扫描行值;
    reg [3:0] temp_col_reg;  //寄存扫描列值;
    reg [3:0] temp_row_reg;  //寄存扫描行值;
    reg [15:0] led;
    reg [15:0] debounce_count=0;
    reg key_in_flag;
    always @(posedge clk_1k)
        begin
        case(state)
           0:
                begin
                    col[3:0] <= 4'b0000;
                    key_flag <= 1'b0;
                   if(row[3:0]!=4'b1111)//有键按下
                   //if(key_in_flag)//有键按下
                        begin 
                            state <=1;
                            col[3:0]<= 4'b1110;
                        end
                    else    state<=0;
                end
            1:
                begin
                    if(row[3:0]!=4'b1111)//有键按下
                        state<=5;
                    else
                        begin state<=2;col[3:0]<=4'b1101;end
                end
             2:
                    begin
                        if(row[3:0]!=4'b1111)//有键按下
                            state<=5;
                        else
                            begin state<=3;col[3:0]<=4'b1011;end
                    end
              3:
                     begin
                         if(row[3:0]!=4'b1111)//有键按下
                             state<=5;
                         else
                             begin state<=4;col[3:0]<=4'b0111;end
                     end                            
               4:
                      begin
                          if(row[3:0]!=4'b1111)//有键按下
                              state<=5;
                          else
                             state<=0;
                      end       
                5:
                    begin
                    if(row[3:0]!=4'b1111) 
                        begin
                            col_reg<=col;  //保存扫描列值
                            row_reg<=row;  //保存扫描行值
                            state<=5;
                            key_flag<=1'b1;  //有键按下
                        end
                    else
                        state<=0;
                    end
                endcase
                end
    always @(clk_1k or col_reg or row_reg)
        begin
            if(key_flag)
                begin
                    case ({col_reg,row_reg})
                        8'b1110_1110:begin key_value<=0; led[15:0]=16'b0000_0000_0000_0001;end
                        8'b1110_1101:begin key_value<=0; led[15:0]=16'b0000_0000_0000_0010;end
                        8'b1110_1011:begin key_value<=0; led[15:0]=16'b0000_0000_0000_0100;end
                        8'b1110_0111:begin key_value<=0; led[15:0]=16'b0000_0000_0000_1000;end
                        
                        8'b1101_1110:begin key_value<=0; led[15:0]=16'b0000_0000_0001_0000;end
                        8'b1101_1101:begin key_value<=0; led[15:0]=16'b0000_0000_0010_0000;end
                        8'b1101_1011:begin key_value<=0; led[15:0]=16'b0000_0000_0100_0000;end
                        8'b1101_0111:begin key_value<=0; led[15:0]=16'b0000_0000_1000_0000;end
                        
                        8'b1011_1110:begin key_value<=0; led[15:0]=16'b0000_0001_0000_0000;end
                        8'b1011_1101:begin key_value<=0; led[15:0]=16'b0000_0010_0000_0000;end
                        8'b1011_1011:begin key_value<=0; led[15:0]=16'b0000_0100_0000_0000;end
                        8'b1011_0111:begin key_value<=0; led[15:0]=16'b0000_1000_0000_0000;end
                        
                        8'b0111_1110:begin key_value<=0; led[15:0]=16'b0001_0000_0000_0000;end
                        8'b0111_1101:begin key_value<=0; led[15:0]=16'b0010_0000_0000_0000;end
                        8'b0111_1011:begin key_value<=0; led[15:0]=16'b0100_0000_0000_0000;end
                        8'b0111_0111:begin key_value<=0; led[15:0]=16'b1000_0000_0000_0000;end
                    endcase 
                end
        end
endmodule
*/