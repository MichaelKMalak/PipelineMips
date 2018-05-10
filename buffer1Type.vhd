library ieee;
use ieee.std_logic_1164.all;
use work.buffers_pkg.all;

entity buffer1Type is
  port(clk, rst, we : in std_logic;
        d: in buffer1_in;
        q: out buffer1_in
        );
  end buffer1Type;
  
architecture buffer1Type_a of buffer1Type is 
	signal zeros:buffer1_in;
  begin 
	zeros.Instruction<="0000000000000000";
	zeros.PC_fetch_Out<="0000000000000000";
    process (clk, rst) 
      begin
        if rst = '1' then
          q<=zeros;
        elsif rising_edge(clk) then
          if (we='1') then
          q<=d;
          end if;
          end if;
      end process;
  end buffer1Type_a;
  
