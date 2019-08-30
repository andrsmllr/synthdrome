-- Synthdrome v0.1 2019

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity add is
  generic (
    N : integer := 2; -- Number of operands.
    W : integer := 32; -- Operand width.
    IREG : boolean := TRUE;
    OREG : boolean := TRUE
  );
  port (
    clk_i : in  std_logic;
    ce_i  : in  std_logic;
    op_i  : in  std_logic_vector(N*W-1 downto 0);
    sum_o : out std_logic_vector(W-1 downto 0)
  );
end entity add;

architecture rtl of add is
  signal op  : std_logic_vector(N*W-1 downto 0);
  signal sum : std_logic_vector(W-1 downto 0);
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

  process (op_i) is
    variable sum : unsigned(W-1 downto 0);
  begin
    sum := (others => '0');
    for i in 0 to N-1 loop
      sum := sum + unsigned(op_i((i+1)*W-1 downto i*W));
    end loop;
    sum_o <= std_logic_vector(sum);
  end process;

  oreg_gen: if OREG generate
    process (clk_i) is
    begin
      if rising_edge(clk_i) and ce_i = '1' then
        sum_o <= sum;
      end if;
    end process;
  end generate oreg_gen;

  no_oreg_gen: if not OREG generate
    sum_o <= sum;
  end generate no_oreg_gen;

end architecture rtl;
