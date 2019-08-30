// Synthdrome v0.1 2019

`include "util.vh"

module mux #(
  parameter N = 2,    // Number of operands.
  parameter W = 32,   // Width of operands.
  parameter IREG = 1, // Enable input registers.
  parameter OREG = 1  // Enable output registers.
) (
  input wire         clk_i,
  input wire         ce_i,
  input wire [W-1:0] op_i [N-1:0],
  input wire [N-1:0] sel_i, // Using N instead of clog2(N) due to tool limitations.
  output reg [W-1:0] res_o
);

reg [W-1:0] op [N-1:0];
reg [N-1:0] sel;
reg [W-1:0] res;
integer i;

if (IREG == 0) begin
  always @ (*)
  begin
    for (i = 0; i < N; i = i + 1) begin
        op[i] <= op_i[i];
        sel <= sel_i;
    end
  end
end else begin
  always @ (posedge clk_i)
    if (ce_i == 1'b1) begin
      for (i = 0; i < N; i = i + 1) begin
        op[i] <= op_i[i];
        sel <= sel_i;
    end
    end
end

always @ (*)
begin
  res <= op[sel];
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
