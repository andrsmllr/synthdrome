// Synthdrome v0.1 2019

module add #(
  parameter N = 2,
  parameter W = 32,
  parameter IREG = 1,
  parameter OREG = 1
) (
  input  wire         clk_i,
  input  wire         ce_i,
  input  wire [W-1:0] op_i [N-1:0],
  output reg  [W-1:0] sum_o
);

reg [W-1:0] sum;
reg [W-1:0] op [N-1:0];
integer i;

if (IREG == 0)
  always @ (*)
    for (i = 0; i < N; i = i + 1) begin op[i] <= op_i[i]; end
else
  always @ (posedge clk_i)
    if (ce_i == 1'b1) begin
      for ( i = 0; i < N; i = i + 1) begin op[i] <= op_i[i]; end
    end

always @ (*)
begin
  sum = 0;
  for (i = 0; i < N; i = i + 1) begin
    sum = sum + op[i];
  end
end

if (OREG == 0) begin
  always @ (*)
    sum_o <= sum;
end else begin
  always @ (posedge clk_i)
    if (ce_i == 1'b1) begin
      sum_o <= sum;
    end
end

endmodule
