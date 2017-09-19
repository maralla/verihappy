module show_number2(clock,reset,num,com);

input clock,reset;
output [7:0] num;
output [3:0] com;

`include "number.vh"

reg [7:0] num;
reg [3:0] com = 4'b1110;

reg trigger = 0;
reg [25:0] accum = 0;
reg [25:0] accum2 = 0;
wire pps = (accum == 0);
wire pps2 = (accum2 == 0);

always @(posedge clock) begin
    accum <= (pps ? 50000000 : accum) - 1;
	 accum2 <= (pps2 ? 20000 : accum2) - 1;

    if (pps2) begin
		trigger = !trigger;
    end
end

reg [1:0] cycle = 0;
reg [3:0] count = 0;
reg [3:0] n1 = 0;
reg [3:0] n2 = 0;
reg [3:0] n3 = 0;
reg [3:0] n4 = 0;

always @ (posedge trigger, negedge reset) begin
	if (!reset) begin
		n1 = 0;
		n2 = 0;
		n3 = 0;
		n4 = 0;
		count = 0;
		cycle = 0;
		com = 4'b1111;
	end else if (pps) begin
		if (count > 9) begin
			n2 = n2 + 1;
			if (n2 > 9) begin
				n2 = 0;
				n3 = n3 + 1;
				if (n3 > 9) begin
					n3 = 0;
					n4 = n4 + 1;
					if (n4 > 9) begin
						n4 = 0;
						n3 = 0;
						n2 = 0;
					end
				end
			end
			count = 0;
		end
		com = 4'b1110;
		num = to_number(count);
		n1 = count;
		count = count + 1;
	end else begin
	   case (cycle)
			0: begin com = 4'b1110; num = to_number(n1); cycle = 1; end
			1: begin com = 4'b1101; num = to_number(n2); cycle = 2; end
			2: begin com = 4'b1011; num = to_number(n3); cycle = 3; end
			3: begin com = 4'b0111; num = to_number(n4); cycle = 0; end
			default: cycle = 0;
		endcase
	end
end

endmodule