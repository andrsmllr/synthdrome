-- Synthdrome v0.1 2019

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

entity ocmem_dp is
  generic (
    MEM_WIDTH   : integer := 32;   -- Width of on-chip memory.
    ADDR_WIDTH  : integer := 10;   -- Address width of on-chip memory.
    MEM_DEPTH   : integer := 1024; -- Depth of on-chip memory.
    WRITE_THRU  : boolean := TRUE;
    DEBUG_LEVEL : integer := 0
  );
  port (
    clka_i  : in  std_logic;
    cea_i   : in  std_logic;
    addra_i : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    wea_i   : in  std_logic;
    da_i    : in  std_logic_vector(MEM_WIDTH-1 downto 0);
    qa_o    : out std_logic_vector(MEM_WIDTH-1 downto 0);
    clkb_i  : in  std_logic;
    ceb_i   : in  std_logic;
    addrb_i : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    web_i   : in  std_logic;
    db_i    : in  std_logic_vector(MEM_WIDTH-1 downto 0);
    qb_o    : out std_logic_vector(MEM_WIDTH-1 downto 0)
  );
begin
  assert 2**ADDR_WIDTH >= MEM_DEPTH report "Invalid parameters!" severity ERROR;
end entity ocmem_dp;

architecture rtl of ocmem_dp is
  type mem_t is array (integer range <>) of std_logic_vector(MEM_WIDTH-1 downto 0);
  signal mem : mem_t(MEM_DEPTH-1 downto 0);
begin
  assert_gen: if (DEBUG_LEVEL > 0) generate
    process (clka_i, clkb_i) is
    begin
      if ( (rising_edge(clka_i) and (cea_i and wea_i and ceb_i) = '1')
        or (rising_edge(clkb_i) and (ceb_i and web_i and cea_i) = '1') ) then
        assert (addra_i /= addrb_i) report "Memory access violation!" severity ERROR;
      end if;
    end process;
  end generate assert_gen;

  process (clka_i) is
  begin
    if (rising_edge(clka_i) and cea_i = '1') then
      if (wea_i = '1') then
        mem(to_integer(unsigned(addra_i))) <= da_i;
        if WRITE_THRU then
          qa_o <= da_i;
        end if;
      else
        qa_o <= mem(to_integer(unsigned(addra_i)));
      end if;
    end if;
  end process;
  
  process (clkb_i) is
  begin
    if (rising_edge(clkb_i) and ceb_i = '1') then
      if (web_i = '1') then
        mem(to_integer(unsigned(addrb_i))) <= db_i;
        if WRITE_THRU then
          qb_o <= db_i;
        end if;
      else
        qb_o <= mem(to_integer(unsigned(addrb_i)));
      end if;
    end if;
  end process;
end architecture rtl;
