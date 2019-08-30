// Synthdrome v0.1 2019

module cntr #(
  parameter CW = 128,
  parameter IW = 1
) (
  input  wire          clk_i,
  input  wire          rst_i,
  input  wire          ce_i,
  input  wire [IW-1:0] inc_i,
  output wire [CW-1:0] cnt_o
);

reg [CW-1:0] cnt;

always @ (posedge clk_i)
begin
  if (rst_i == 1'b1) begin
    cnt <= 'd0;
  end else if (ce_i == 1'b1) begin
    cnt <= cnt + inc_i;
  end
end

assign cnt_o = cnt;

endmodule
