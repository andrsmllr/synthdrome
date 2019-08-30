-- Synthdrome v0.1 2019

library ieee;
    use ieee.std_logic_1164.all;

entity shreg is
  generic (
    W : integer  := 32; -- Width of the shift register.
    S : positive :=  1  -- Shifted bits per shift operation.
  );
  port (
    clk_i : in  std_logic;
    ce_i  : in  std_logic;
    d_i   : in  std_logic_vector(S-1 downto 0);
    q_o   : out std_logic_vector(S-1 downto 0)
  );
end entity shreg;

architecture rtl of shreg is
  signal shreg : std_logic_vector(W-1 downto 0);
begin
  process (clk_i) is
  begin
    if (rising_edge(clk_i) and ce_i = '1') then
      shreg <= shreg(W-S-1 downto 0) & d_i(S-1 downto 0);
    end if;
  end process;
  q_o <= shreg(W-1 downto W-S);
end architecture rtl;
