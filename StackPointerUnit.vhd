 -- inputs:
--	the stack pointer 
--	memory/stack enable
--	+/- 

-- Outputs:
--	the stack pointer (should be saved back in the SP register)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPunit is
Generic (n : integer := 10); --should always be 10
  port(clk, en, addSub	: in std_logic; --when add: addSub='1' else addSub='0'
	SPin		: in std_logic_vector (n-1 downto 0);
	SPout		: out std_logic_vector (n-1 downto 0);
	SPout_prev	: out std_logic_vector (n-1 downto 0)
  );
end SPunit;

architecture SPunit_a of SPunit is
constant ZERO: std_logic_vector (SPin'range) := (others=>'0');
constant ONE: std_logic_vector (SPin'range) := ZERO(n-1 downto 1)&'1';
constant MAX: std_logic_vector (SPin'range) := (others=>'1');
begin
	SPout_prev<=SPin;
    process (clk) is
    begin 
        if rising_edge(clk) then
            if (en = '1') then
                if (addSub = '1') then
			if(SPin=MAX) then
				SPout<=SPin;
			else
				SPout<=std_logic_vector(unsigned(SPin) + unsigned(ONE));
			end if;
		else
			if(SPin=ZERO) then
				SPout<=SPin;
			else
				SPout<=std_logic_vector(unsigned(SPin) - unsigned(ONE));
			end if;
		end if;
            end if;
        end if;
    end process;

end architecture SPunit_a; 