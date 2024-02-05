`timescale 1 ns / 10 ps
module gsc #(parameter DELAY_RISE = 1, DELAY_FALL = 1)
(
    input reset_n,
    input counter_in,

    input clk,

    // 7-segment led
    output [6:0] led_0,
    output [6:0] led_1,
    output [6:0] led_2,

    // spi slave
    input spi_cs,
    input spi_clk,
    input spi_mosi,
    input [1:0] spi_a,

    output gen

);

wire [15:0] arr;
wire [15:0] ctrl;
wire spi_gen_cs = spi_cs | ~(spi_a == 2'b00);
wire spi_ctrl_cs = spi_cs | ~(spi_a == 2'b01);
reg  [15:0] cnt = 16'b0;
reg gen_r = 1'b0;

// generator spi
spi_rx16 spi_gen(.spi_cs(spi_gen_cs), .spi_clk(spi_clk), .spi_mosi(spi_mosi), .spi_data(arr), .reset_n(reset));
// control spi
spi_rx16 spi_ctrl(.spi_cs(spi_ctrl_cs), .spi_clk(spi_clk), .spi_mosi(spi_mosi), .spi_data(ctrl), .reset_n(reset));

reg [3:0] div = 4'b0;
always @(negedge clk ) begin
	div <= div + 1;
end

always @(negedge div[3] ) begin
	if(cnt == arr) begin
		gen_r = ~gen_r;
		cnt <= 16'b0;
	end else begin
		cnt <= cnt + 1;
	end
end

assign gen = gen_r;


wire [3:0] cnt_led_0;
wire [3:0] cnt_led_1;
wire [3:0] cnt_led_2;
wire carry0;
wire carry1;

wire couter_input = (ctrl[0])?(gen):(counter_in);

wire s = (reset_n)?(couter_input):(reset_n^counter_in);

bcd_cnt bcd0(.counter(couter_input), .reset_n(reset_n), .carry(carry0), .d(cnt_led_0));
bcd_cnt bcd1(.counter(carry0 & reset_n),     .reset_n(reset_n), .carry(carry1), .d(cnt_led_1));
bcd_cnt bcd2(.counter(carry1 & reset_n),     .reset_n(reset_n),                 .d(cnt_led_2));

seg7 led0(.D(cnt_led_0), .Q(led_0));
seg7 led1(.D(cnt_led_1), .Q(led_1));
seg7 led2(.D(cnt_led_2), .Q(led_2));

endmodule
