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

integer cnt = 0;

always
  #(42/2) clk = ~clk;

initial
begin
    $dumpfile("gsc_tb.vcd");
    $dumpvars;

    #2 reset_n = 0;
    #2 reset_n = 1;

    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;

    #1 reset_n = 0;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 reset_n = 1;

    for(cnt = 0; cnt < 250; cnt = cnt  + 1) begin
        #1 counter_in <= ~counter_in;
    end

    #1 reset_n = 0;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 reset_n = 1;

    for(cnt = 0; cnt < 240; cnt = cnt  + 1) begin
        #1 counter_in <= ~counter_in;
    end

    #1 reset_n = 0;
    #1 counter_in <= ~counter_in;
    #1 counter_in <= ~counter_in;
    #1 reset_n = 1;

    for(cnt = 0; cnt < 4096; cnt = cnt  + 1) begin
        #1 counter_in <= ~counter_in;
    end

    $finish;
end

endmodule