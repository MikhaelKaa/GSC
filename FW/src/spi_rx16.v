module spi_rx16(
input reset_n,
// spi slave
input spi_cs,
input spi_clk,
input spi_mosi,

output [15:0] spi_data

);
    reg [15:0] data = 16'b0;
    reg [15:0] rx = 16'b0;
    always @(negedge spi_clk ) begin
        //if(reset_n == 1'b0) begin
            //rx <= 16'b0;
        //end else begin 
            if(spi_cs == 1'b0) begin
                rx <= rx << 1;
                rx[0] <= spi_mosi;
            end
        //end
    end

    always @(posedge spi_cs ) begin
        //if(reset_n == 1'b0) begin
            //data <= 16'b0;
        //end else begin 
            data <= rx;
        //end
    end
assign spi_data = data;
endmodule
