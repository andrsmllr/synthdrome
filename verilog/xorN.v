// Synthdrome v0.1 2019

module xorN #(
  parameter N = 2,    // Number of operands.
  parameter W = 32,   // Width of operands.
  parameter IREG = 1, // Enable input registers.
  parameter OREG = 1  // Enable output registers.
) (
  input wire         clk_i,
  input wire         ce_i,
  input wire [W-1:0] op_i [N-1:0],
  output reg [W-1:0] res_o
);

reg [W-1:0] op [N-1:0];
reg [W-1:0] res;
integer i;

if (IREG == 0) begin
  always @ (*)
  begin
    for (i = 0; i < N; i = i + 1) begin op[i] <= op_i[i]; end
  end
end else begin
  always @ (posedge clk_i)
    if (ce_i == 1'b1) begin
      for ( i = 0; i < N; i = i + 1) begin op[i] <= op_i[i]; end
    end
end

always @ (*)
begin
  res = 0;
  for (i = 0; i < N; i = i + 1) begin
    res = res ^ op[i];
  end
end

if (OREG == 0) begin
  always @ (*)
    res_o <= res;
end else begin
  always @ (posedge clk_i)
    if (ce_i == 1'b1) begin
      res_o <= res;
    end
end

endmodule
