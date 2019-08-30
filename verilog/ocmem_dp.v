// Synthdrome v0.1 2019

module ocmem_dp #(
    parameter MEM_WIDTH  = 32, // Width of on-chip memory.
    parameter ADDR_WIDTH = 10, // Address width of on-chip memory.
    parameter MEM_DEPTH  = 1024,  // Depth of on-chip memory.
    parameter WRITE_THRU = 1,
    parameter DEBUG_LEVEL= 0
) (
  input  wire                  clka_i,
  input  wire                  cea_i,
  input  wire [ADDR_WIDTH-1:0] addra_i,
  input  wire                  wea_i,
  input  wire [MEM_WIDTH-1:0]  da_i,
  output reg  [MEM_WIDTH-1:0]  qa_o,
  input  wire                  clkb_i,
  input  wire                  ceb_i,
  input  wire [ADDR_WIDTH-1:0] addrb_i,
  input  wire                  web_i,
  input  wire [MEM_WIDTH-1:0]  db_i,
  output reg  [MEM_WIDTH-1:0]  qb_o
);

initial begin
  // Sanity check memory parameters.
  $assert(2**ADDR_WIDTH >= MEM_DEPTH);
end

if (DEBUG_LEVEL > 0) begin : assert_gen
  always @ (cea_i, wea_i, ceb_i, web_i)
  begin
    // While one port is writing the other shall not access the same memory location.
    if ((cea_i && wea_i && ceb_i) || (ceb_i && web_i && cea_i)) begin
      $assert(addra_i != addrb_i);
    end
  end
end

reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

always @ (posedge clka_i)
begin
  if (cea_i == 1'b1) begin
    if (wea_i == 1'b1) begin
      mem[addra_i] <= da_i;
      if (WRITE_THRU != 0) begin
        qa_o <= da_i;
      end
    end else begin
      qa_o <= mem[addra_i];
    end
  end
end

always @ (posedge clkb_i)
begin
  if (ceb_i == 1'b1) begin
    if (web_i == 1'b1) begin
      mem[addrb_i] <= db_i;
      if (WRITE_THRU != 0) begin
        qb_o <= db_i;
      end
    end else begin
      qb_o <= mem[addrb_i];
    end
  end
end

endmodule
