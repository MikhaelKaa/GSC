`timescale 1 ns / 10 ps

module bcd_cnt_tb;

// DUT inputs
reg counter = 1'b0;
reg reset_n = 1'b0;

// DUT outputs
wire [3:0] d;
wire carry;

// DUT
bcd_cnt dut(
    .counter(counter),
    .reset_n(reset_n),
    .carry(carry),
    .d(d)
);

integer cnt = 0;

initial begin
    $dumpfile("bcd_cnt_tb.vcd");
    $dumpvars;
    #1 
    reset_n <= 1'b0;
    #1 
    reset_n <= 1'b1;

    for(cnt = 0; cnt < 12; cnt = cnt  + 1) begin
        #1 counter = ~counter;
    end

    #1 reset_n <= 1'b0;
    #1 counter = ~counter;
    #1 counter = ~counter;
    #1 reset_n <= 1'b1;

    for(cnt = 0; cnt < 12; cnt = cnt  + 1) begin
        #1 counter = ~counter;
    end

    #1 reset_n <= 1'b0;
    #1 counter = ~counter;
    #1 counter = ~counter;
    #1 reset_n <= 1'b1;

    for(cnt = 0; cnt < 50; cnt = cnt  + 1) begin
        #1 counter = ~counter;
    end

    $finish;
end

endmodule