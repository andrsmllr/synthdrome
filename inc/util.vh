
module util;

function automatic clog2;
  input integer i;
  integer k = i;
  integer c = 0;
begin
  $assert(i > 0);
  while (k >= 1) begin
    k = k / 2;
    c = c + 1;
  end
  clog2 = c;
end
endfunction

endmodule