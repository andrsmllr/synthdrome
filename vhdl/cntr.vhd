-- Synthdrome v0.1 2019

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity cntr is
  generic (
    CW : integer := 128; -- Counter width.
    IW : integer :=  1  -- Increment width.
  );
  port (
    clk_i : in  std_logic;
    rst_i : in  std_logic;
    ce_i  : in  std_logic;
    inc_i : in  std_logic_vector(IW-1 downto 0);
    cnt_o : out std_logic_vector(CW-1 downto 0)
  );
end entity cntr;

architecture rtl of cntr is
  signal cnt : unsigned(CW-1 downto 0);
begin
  process (clk_i) is
  begin
    if rising_edge(clk_i) then
      if (rst_i = '1') then
        cnt <= to_unsigned(0, CW);
      elsif (ce_i = '1') then
        cnt <= cnt + unsigned(inc_i);
      end if;
    end if;
  end process;
  cnt_o <= std_logic_vector(cnt);
end architecture rtl;
