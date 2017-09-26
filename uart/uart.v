module uart(clock,reset,led,led1,led2,tx);

input clock,reset;
output tx,led,led1,led2;

reg [31:0] delay;
reg active;

always @ (negedge reset, posedge clock) begin
	if (!reset) begin
		delay <= 0;
		active <= 0;
	end else begin
		if (delay == 24000000) begin
			delay <= 0;
			active <= !active;
		end else begin
			delay <= delay + 1;
		end
	end
end

reg [6:0] index;
reg [1:0] status;
reg [31:0] baudrate;
reg [31:0] cursor;
reg [7:0] data;
reg [31:0] idle;
reg out;

wire [7:0] message [0:11];

assign message[0] = 104;
assign message[1] = 101;
assign message[2] = 108;
assign message[3] = 108;
assign message[4] = 111;
assign message[5] = 32;
assign message[6] = 119;
assign message[7] = 111;
assign message[8] = 114;
assign message[9] = 108;
assign message[10] = 100;
assign message[11] = 33;

always @ (posedge active, posedge clock) begin
	if (active) begin
		baudrate <= 0;
		index <= 0;
		cursor <= 0;
		status <= 2'b01;
		idle <= 0;
	end else begin
		if (baudrate == 5000) begin
			baudrate <= 0;
			case (status)
				2'b01: begin out <= 0; status <= 2'b11; end
				2'b10: begin
					out <= 1;
					if (cursor == 0) begin
						status <= 2'b00;
					end else begin
						status <= 2'b01;
					end
				end
				2'b11: begin
//					case (cursor)
//						0 : data = 104;
//						1 : data = 101;
//						2 : data = 108;
//						3 : data = 108;
//						4 : data = 111;
//						5 : data = 32;
//						6 : data = 119;
//						7 : data = 111;
//						8 : data = 114;
//						9 : data = 108;
//						10: data = 100;
//						11: data = 33;
//						default: data = 63;
//					endcase
//					out <= data[index];
					out <= message[cursor][index];
					if (index == 7) begin
						index <= 0;
						status <= 4'b10;
						if (cursor == 11) begin
							cursor <= 0;
						end else begin
							cursor <= cursor + 1;
						end
					end else begin
						status <= 4'b11;
						index <= index + 1;
					end
				end
				default: begin out <= 1; status <= 4'b00; end
			endcase
		end else begin
			baudrate <= baudrate + 1;
		end
	end
end

assign tx = out;

endmodule