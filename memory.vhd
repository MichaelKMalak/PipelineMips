----------- instruction memory------------------
--		we put we=0 always

----------- memory and stack ------------------
--		no need to read_enable !!!

--=============================================
-- 1 KB =8000 bits and 1 word access, 10 bits address.
-- Asynchronous read since the buffer afterwards is synchronous write
-- Write enable doesn't work if it's a rising edge with the rising edge of the clock at the same time
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity instMem is 
Generic (n : integer := 10; m : integer := 16);
	port (	clk: in std_logic;
		we: in std_logic; --writeEnable
		address: in std_logic_vector(n-1 downto 0);
		dataIn: in std_logic_vector(m-1 downto 0);
		dataOut: out std_logic_vector(m-1 downto 0)
		);
end entity instMem;

architecture instMem_arch of instMem is
type ram_type is array (0 to  (2**n)-1) of std_logic_vector(m-1 downto 0);
signal ram: ram_type;
begin
    -- asynchronous read
dataOut<= ram(to_integer(unsigned(address)));
	process(clk, we) is --synchronous
	begin
	if we = '1' then
		ram(to_integer(unsigned(address)))<= dataIn;
	end if;
				
		end process;
	
end architecture instMem_arch;
