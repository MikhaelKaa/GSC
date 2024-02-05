module bcd_cnt #(parameter DELAY_RISE = 1, DELAY_FALL = 1)
(
    input counter,
    input reset_n,
    output carry,
    output [3:0] d
);

reg [3:0] cnt = 4'b0;
reg c = 1'b0;
always @(negedge counter) begin
    if(!reset_n) begin
        cnt <= 1'b0;
    end else begin
        if(cnt == 4'b1001) begin
            cnt <= 1'b0;
            c <= 0;
        end else begin 
            cnt <= cnt + 1'b1;
            c <= 1'b1;
        end
    end
end
assign d = cnt;
assign carry = c;
endmodule
