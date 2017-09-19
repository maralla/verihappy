//module number();

function [7:0] to_number;
input [3:0] n;
begin
	case (n)
		0: to_number = 8'b00000011;
		1: to_number = 8'b10011111;
		2: to_number = 8'b00100101;
		3: to_number = 8'b00001101;
		4: to_number = 8'b10011001;
		5: to_number = 8'b01001001;
		6: to_number = 8'b01000001;
		7: to_number = 8'b00011111;
		8: to_number = 8'b00000001;
		9: to_number = 8'b00001001;
		default: to_number = 8'b11111111;
	endcase
end
endfunction

//endmodule