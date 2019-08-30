// Synthdrome v0.1 2019

module ocmem_sp #(
    parameter MEM_WIDTH  = 32, // Width of on-chip memory.
    parameter ADDR_WIDTH = 10, // Address width of on-chip memory.
    parameter MEM_DEPTH  = 1024,  // Depth of on-chip memory.
    parameter WRITE_THRU = 1
) (
  input  wire                  clk_i,
  input  wire                  ce_i,
  input  wire [ADDR_WIDTH-1:0] addr_i,
  input  wire                  we_i,
  input  wire [MEM_WIDTH-1:0]  d_i,
  output reg  [MEM_WIDTH-1:0]  q_o
);

initial begin
  // Sanity check memory parameters.
  $assert(2**ADDR_WIDTH >= MEM_DEPTH);
end

reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

always @ (posedge clk_i)
begin
  if (ce_i == 1'b1) begin
    if (we_i == 1'b1) begin
      mem[addr_i] <= d_i;
      if (WRITE_THRU != 0) begin
        q_o <= d_i;
      end
    end else begin
      q_o <= mem[addr_i];
    end
  end
end

endmodule
