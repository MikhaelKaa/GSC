`timescale 1 ns / 10 ps

//`define TEST
`include "seg7.v"
`include "bcd_cnt.v"
`include "spi_rx16.v"

module gsc_tb;

// DUT inputs
reg reset_n = 1'b0;
reg counter_in = 1'b0;
reg clk = 1'b0;
reg spi_cs = 1'b0;
reg spi_clk = 1'b0;
reg spi_mosi = 1'b0;
reg [1:0] spi_a = 2'b0;

// DUT outputs
wire [6:0] led_0;
wire [6:0] led_1;
wire [6:0] led_2;
wire gen;

// DUT
gsc dut(
    .reset_n(reset_n),
    .counter_in(counter_in),
    .clk(clk),
    .spi_cs(spi_cs),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_a(spi_a),
    .led_0(led_0),
    .led_1(led_1),
    .led_2(led_2),
    .gen(gen)
);

integer i = 0;
reg [15:0] test_data[0:7];

always
  #(42/2) clk = ~clk;

initial
begin
    $dumpfile("gsc_tb.vcd");
    $dumpvars;

    test_data[0] = 16'h0000;
    test_data[1] = 16'h5555;
    test_data[2] = 16'h0002;
    test_data[3] = 16'h0004;
    test_data[4] = 16'h1000;
    test_data[5] = 16'h0001;
    test_data[6] = 16'h1001;
    test_data[7] = 16'h0001;

    #0 reset_n = 0;
    #200 reset_n = 1;

    #1  spi_a = 2'b01;
    #10 spi_clk = 1'b1;
    #10 spi_cs = 1'b0;
    for (i = 15; i != -1; i--) begin
        #42 spi_mosi = test_data[7][i];
        #42 spi_clk = 1'b0;
        #24 spi_clk = 1'b1;
    end
    #1 spi_cs = 1'b1;

    #1  spi_a = 2'b00;
    #10 spi_clk = 1'b1;
    #10 spi_cs = 1'b0;
    for (i = 15; i != -1; i--) begin
        #42 spi_mosi = test_data[2][i];
        #42 spi_clk = 1'b0;
        #24 spi_clk = 1'b1;
    end
    #1 spi_cs = 1'b1;

    #20000
    #0 reset_n = 0;
    #200 reset_n = 1;

    #10 spi_clk = 1'b1;
    #10 spi_cs = 1'b0;
    for (i = 15; i != -1; i--) begin
        #42 spi_mosi = test_data[3][i];
        #42 spi_clk = 1'b0;
        #24 spi_clk = 1'b1;
    end
    #1 spi_cs = 1'b1;

    #200000
    $finish;
end

endmodule