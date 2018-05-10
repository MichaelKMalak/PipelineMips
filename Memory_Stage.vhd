library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mem_pkg.all;
use work.common_pkg.all;

Entity memory_unit is
    Port (clk: in std_logic;	
	  mem_d : in  mem_in;
          mem_q : out mem_out);
End Entity memory_unit;

Architecture Behavior of memory_unit is

Component instMem is 
Generic (n : integer := 10; m : integer := 16);
	port (	clk: in std_logic;
		we: in std_logic; --writeEnable
		address: in std_logic_vector(n-1 downto 0);
		dataIn: in std_logic_vector(m-1 downto 0);
		dataOut: out std_logic_vector(m-1 downto 0)
		);
End Component instMem;
    signal memAddress    : address_size;
    signal writeData     : word;
    signal mainAddress   : address_size;
    signal dataOut 	 : word;
    signal PCandFlags  : word;
    signal writeEnable   : std_logic;

    constant ZERO: std_logic_vector (memAddress'range) := (others=>'0');
    constant ONE: std_logic_vector (memAddress'range) := ZERO(9 downto 1)&'1';
Begin -- architecture Behavior

PCandFlags<= mem_d.CCRflags&"00"&mem_d.PCaddr;   
memAddress<= 	ZERO when mem_d.ResetSignal='1' else
		ONE when mem_d.INTsignal='1' else
		mem_d.ImmAddr;
writeData<= 	PCandFlags when mem_d.INTsignal='1' else
		std_logic_vector(unsigned(ZERO(5 downto 0)&mem_d.PCaddr) + unsigned(ZERO(5 downto 0)&ONE)) when mem_d.CALLsignal='1' else
		mem_d.operand2;	--STR
Memory: instMem port map(clk, writeEnable, mainAddress, writeData, mem_q.memData );

process (clk)
begin
	--Write on half cycle
	if rising_edge(clk) then
		writeEnable<=mem_d.INTsignal OR mem_d.MEMwrite;
		if (mem_d.INTsignal='1' or mem_d.CALLsignal='1') then
			mainAddress<= mem_d.SPaddr; -- X[SP--]<-PC/PC+1
		else
			if (mem_d.MemStack='1') then
				mainAddress<= mem_d.SPaddr;
			else
				mainAddress<= memAddress;
			end if; 
		end if;

	else
	--Don't write again
		writeEnable<='0';
		if (mem_d.INTsignal='1') then
			mainAddress<= memAddress; -- read M[1]
		else
			if (mem_d.MemStack='1') then
				mainAddress<= mem_d.SPaddr;
			else
				mainAddress<= memAddress;
			end if; 
		end if;
	end if;
end process;

end architecture Behavior;