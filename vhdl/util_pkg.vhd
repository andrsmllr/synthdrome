-- Synthdrome v0.1 2019

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

package util_pkg is
  pure function clog2(N : positive) return natural;
end package util_pkg;

package body util_pkg is
  pure function clog2(N : positive) return natural is
    variable k : natural := N;
    variable r : natural := 0;
  begin
    while k > 0 loop
      k := k / 2;
      r := r + 1;
    end loop;
    return r;
  end function clog2;
end package body util_pkg;
