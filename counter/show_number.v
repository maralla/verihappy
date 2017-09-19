module show_number(clock,reset,num,com);

input clock,reset;
output [7:0] num;
output [3:0] com;

reg [7:0] num;
reg [3:0] com;
reg [1:0] index;

// 0111 thousands
// 1011 hundreds
// 1101 tens
// 1110 units
// 1111 all shut

reg freq;
reg [27:0] count;

always @ (negedge reset or posedge clock)
begin
if (!reset)
	begin
	count = 0;
	freq = 0;
	end
else
	begin
	count = count + 1;
	if (count >= 20000000)
		begin
		count = 0;
		freq = !freq;
		end
	end
end

always @ (posedge freq)
begin
   case(index)
		2'b11: begin com=4'b1110;num=8'b10011001;index=2'b00; end
		2'b10: begin com=4'b1101;num=8'b00001101;index=2'b11; end
		2'b01: begin com=4'b1011;num=8'b00100101;index=2'b10; end
		2'b00: begin com=4'b0111;num=8'b10011111;index=2'b01; end
		default: index=2'b00;
	endcase
end

endmodule