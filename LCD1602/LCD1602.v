// RS (ouput)- 0 direction, 1 data
// R/W (output) - 0 write, 1 read
// E (output) - 1 read, 1->0 execute
// DB[7:0] - data
//
// Address (7bit, DB[7] == 1):
//    00 .. 0F
//    40 .. 4F
 
//lcd1602控制模块,在液晶上显示两行，第一行为"Welcome to QC!",第二行为"LCD DISPLAY"
//从CGROM中取出数据显示
//E：1-使能有效，0-使能无效
//RW:1-读操作，0-写操作  RS:1-输入数据，0-输入指令
module LCD1602
(
		clock_in,
		reset_in,//时钟，复位信号输入
		lcd_data,//lcd数据总线
		lcd_e,
		lcd_rw,
		lcd_rs//lcd控制信号
		

);
input clock_in,reset_in;
output [7:0] lcd_data;
output lcd_e,lcd_rw,lcd_rs;

reg [7:0] lcd_data;
reg lcd_e,lcd_rw,lcd_rs;
	  
reg [7:0] counter;

task execute;
input rs;
input [7:0] dat;
inout [7:0] state;
begin
	counter <= counter + 1;
	if (counter <= 2) begin
		lcd_rs <= rs;
		lcd_rw <= 0;
		lcd_e <= 1;
	end else if (counter <= 4)
		lcd_data <= dat;
	else if (counter <= 6)  
		lcd_e <= 0;
	else if (counter >= 100) begin
		counter <= 0;
		state <= state + 1;
	end
end
endtask

reg clk_div;
reg [31:0] acumm;

always @ (negedge reset_in, posedge clock_in) begin
	if (!reset_in) begin
		acumm <= 0;
		clk_div <= 0;
	end else if (acumm >= 240) begin
		clk_div <= !clk_div;
		acumm <= 0;
	end else begin
		acumm <= acumm + 1;
	end
end

reg [8:0] state;

always @ (negedge reset_in or posedge clk_div)
	if (!reset_in)	begin
		state <= 1;
		counter <= 0;
		lcd_e <= 0;
	end else
		case (state)
			1: execute(0, 8'h01, state);
			2: execute(0, 8'h38, state);		
			3: execute(0, 8'h06, state);
			4: execute(0, 8'h0C, state);
			5: execute(0, 8'h81, state);
			6: execute(1, 8'b01000001, state);
			7: execute(1, 8'b01000010, state);
			default:;				
		endcase
endmodule
