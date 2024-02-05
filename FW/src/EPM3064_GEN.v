module EPM3064_GEN(
// Clock 48MHz
input clk,

// reset
input reset,

// spi slave
input spi_cs,
input spi_clk,
input spi_mosi,

output gen
);

wire [15:0] arr;
reg  [15:0] cnt = 16'b0;
reg gen_r = 1'b0;

spi_rx16 spi(.spi_cs(spi_cs), .spi_clk(spi_clk), .spi_mosi(spi_mosi), .spi_data(arr), .reset_n(reset));

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

endmodule
