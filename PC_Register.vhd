library ieee;
use ieee.std_logic_1164.all;

entity indep_register is
  generic (n:integer :=16);
  port(clk, rst, we : in std_logic;
        d: in std_logic_vector(n-1 downto 0);
        q: out std_logic_vector(n-1 downto 0)
        );
  end indep_register;
  
architecture indep_register_a of indep_register is 
  begin 
    process (clk, rst) 
	variable PC_reg: std_logic_vector(n-1 downto 0) := (others=>'0');
      begin
	 q <= PC_reg;
        if rst = '1' then
          PC_reg:=(others=>'0');
        elsif falling_edge(clk) then
          if (we='1') then
          PC_reg:=d;
          end if;
          end if;
      end process;
  end indep_register_a;
  
