// Synthdrome v0.1 2019

module shreg #(
  parameter W = 32, // Width of the shift register.
  parameter S =  1  // Shifted bits per shift operation.
) (
  input  wire         clk_i,
  input  wire         ce_i,
  input  wire [S-1:0] d_i,
  output wire [S-1:0] q_o
);

reg [W-1:0] shreg;
reg [S-1:0] q;

always @ (posedge clk_i)
begin
  if (ce_i == 1'b1) begin
    {q, shreg} <= {shreg, d_i};
  end
end

assign q_o = q;

endmodule
