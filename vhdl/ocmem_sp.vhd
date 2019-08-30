-- Synthdrome v0.1 2019

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity ocmem_sp is
  generic (
    MEM_WIDTH  : integer := 08;   -- Width of on-chip memory.
    ADDR_WIDTH : integer := 10;   -- Address width of on-chip memory.
    MEM_DEPTH  : integer := 1024; -- Depth of on-chip memory.
    WRITE_THRU : boolean := TRUE
  );
  port (
    clk_i  : in  std_logic;
    ce_i   : in  std_logic;
    addr_i : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    we_i   : in  std_logic;
    d_i    : in  std_logic_vector(MEM_WIDTH-1 downto 0);
    q_o    : out std_logic_vector(MEM_WIDTH-1 downto 0)
  );
begin
  assert 2**ADDR_WIDTH >= MEM_DEPTH report "Invalid parameters!" severity ERROR;
end entity ocmem_sp;

architecture rtl of ocmem_sp is
  type mem_t is array (integer range <>) of std_logic_vector(MEM_WIDTH-1 downto 0);
  signal mem : mem_t(MEM_DEPTH-1 downto 0);
begin
  process (clk_i) is
  begin
    if (rising_edge(clk_i) and ce_i = '1') then
      if (we_i = '1') then
        mem(to_integer(unsigned(addr_i))) <= d_i;
        if WRITE_THRU then
          q_o <= d_i;
        end if;
      else
        q_o <= mem(to_integer(unsigned(addr_i)));
      end if;
    end if;
  end process;
end architecture rtl;
