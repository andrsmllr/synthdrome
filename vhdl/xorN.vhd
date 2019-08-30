-- Synthdrome v0.1 2019

library ieee;
    use ieee.std_logic_1164.all;

entity xorN is
  generic (
    N : integer := 02; -- Number of operands.
    W : integer := 32;  -- Width of operands.
    IREG : boolean := TRUE;
    OREG : boolean := TRUE
  );
  port (
    clk_i : in  std_logic;
    ce_i  : in  std_logic;
    op_i  : in  std_logic_vector(N*W-1 downto 0);
    res_o : out std_logic_vector(W-1 downto 0)
  );
end entity xorN;

architecture rtl of xorN is
  signal op  : std_logic_vector(N*W-1 downto 0);
  signal res : std_logic_vector(W-1 downto 0);
begin

  ireg_gen: if IREG generate
    process (clk_i) is
    begin
      if rising_edge(clk_i) and ce_i = '1' then
        op <= op_i;
      end if;
    end process;
  end generate ireg_gen;

  no_ireg_gen: if not IREG generate
    op <= op_i;
  end generate no_ireg_gen;

  process (op) is
    variable res_tmp : std_logic_vector(W-1 downto 0);
  begin
    res_tmp := (others => '0');
    for i in 0 to N-1 loop
      res_tmp := res_tmp xor op_i((i+1)*W-1 downto i*W);
    end loop;
    res <= res_tmp;
  end process;

  oreg_gen: if OREG generate
    process (clk_i) is
    begin
      if rising_edge(clk_i) and ce_i = '1' then
        res_o <= res;
      end if;
    end process;
  end generate oreg_gen;

  no_oreg_gen: if not OREG generate
    res_o <= res;
  end generate no_oreg_gen;

end architecture rtl;
