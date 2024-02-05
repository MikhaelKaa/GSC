`timescale 1 ns / 10 ps

module seg7_tb;

// DUT inputs
reg [3:0] D = 4'b0;

// DUT outputs
wire [6:0] Q;

// DUT
seg7 dut(
    .D(D),
    .Q(Q)
);

reg [4:0] cnt = 0;

initial begin
    $dumpfile("seg7_tb.vcd");
    $dumpvars;

    for(cnt = 0; cnt < 17; cnt = cnt  + 1) begin
        #1 D <= cnt;
    end

    $finish;
end

endmodule