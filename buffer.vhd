library ieee;
use ieee.std_logic_1164.all;

entity nbuffer is
  generic (n:integer :=16);
  port(clk, rst, we : in std_logic;
        d: in std_logic_vector(n-1 downto 0);
        q: out std_logic_vector(n-1 downto 0)
        );
  end nbuffer;
  
architecture nbuffer_a of nbuffer is 
  begin 
    process (clk, rst) 
      begin
        if rst = '1' then
          q<=(others=>'0');
        elsif rising_edge(clk) then
          if (we='1') then
          q<=d;
          end if;
          end if;
      end process;
  end nbuffer_a;
  
