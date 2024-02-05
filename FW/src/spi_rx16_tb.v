`define TBASSERT_METHOD(TB_NAME) reg [512:0] tbassertLastPassed = ""; task TB_NAME(input condition, input [512:0] s); if (condition === 1'bx) $display("-Failed === x value: %-s", s); else if (condition == 0) $display("-Failed: %-s", s); else if (s != tbassertLastPassed) begin $display("Passed: %-s", s); tbassertLastPassed = s; end endtask
`timescale 1 ns / 1 ns

module spi_rx16_tb;

`TBASSERT_METHOD(tbassert)

// DUT inputs
reg reset_n = 1'b0;
reg spi_cs = 1'b0;
reg spi_clk = 1'b0;
reg spi_mosi = 1'b0;

// DUT outputs
wire [15:0] spi_data;

// DUT
spi_rx16 dut(
    .reset_n(reset_n),
    .spi_cs(spi_cs),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_data(spi_data)
);

integer i = 0;
integer k = 0;

reg [15:0] test_data[0:7];



initial
begin

$dumpfile("spi_rx16_tb.vcd");
$dumpvars;

test_data[0] = 16'h0000;
test_data[1] = 16'h5555;
test_data[2] = 16'haaaa;
test_data[3] = 16'hffff;
test_data[4] = 16'h1000;
test_data[5] = 16'h0001;
test_data[6] = 16'h1001;
test_data[7] = 16'ha55a;



#1 reset_n = 1'b0;
#10
#1 reset_n = 1'b1;
#1 spi_cs = 1'b1;

for (k = 0; k != 8; k++) begin
    #1 spi_clk = 1'b1;
    #1 spi_cs = 1'b0;
    for (i = 15; i != -1; i--) begin
        #1 spi_mosi = test_data[k][i];
        #1 spi_clk = 1'b0;
        #1 spi_clk = 1'b1;
    end
    #1 spi_cs = 1'b1;
    #1 spi_cs = 1'b1;
    $display("spi_data == 0x%x", test_data[k]);
    tbassert(spi_data == test_data[k], "test_data");  
end

#1 reset_n = 1'b0;
#10
#1 reset_n = 1'b1;
#1 spi_cs = 1'b1;



$finish;
end

endmodule
