module led_test(clock,reset,num,com);

input clock,reset;
output [7:0] num;
output [3:0] com;

//show_number N1 (.clock(clock),.reset(reset),.num(num),.com(com));
show_number2 N2 (.clock(clock),.reset(reset),.num(num),.com(com));

endmodule