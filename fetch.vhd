Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fetch_pkg.all;
use work.common_pkg.all;

entity Fetch is
  port( Clk : in std_logic;
   	fetch_d : in fetch_in; 
	fetch_q : out fetch_out
);
end entity Fetch;
Architecture a_Fetch of Fetch is

component instMem is
  Generic (n : integer := 10; m : integer := 16);
	port (	clk: in std_logic;
		we: in std_logic; --writeEnable
		address: in std_logic_vector(n-1 downto 0);
		dataIn: in std_logic_vector(m-1 downto 0);
		dataOut: out std_logic_vector(m-1 downto 0)
		);
  end component;
component indep_register is
  generic (n:integer :=16);
  port(clk, rst, we : in std_logic;
        d: in std_logic_vector(n-1 downto 0);
        q: out std_logic_vector(n-1 downto 0)
        );
  end component;
constant ZERO: std_logic_vector (word'range) := (others=>'0');
signal Ins_Next : word;
signal Pc_Out: word;
  begin

  reg0: instMem generic map(n=>10, m=>16) port map (clk=>Clk, we=>'0', address=>PC_Out(9 downto 0) , dataIn=>ZERO, dataOut=>fetch_q.Instruction ); 
  reg1: indep_register generic map(n=>16) port map (clk=>Clk, rst=>'0', we=>'1', d=>Ins_Next, q=>PC_Out ); 
  Ins_Next <= std_logic_vector(unsigned(PC_Out) + 1) when (fetch_d.PC_Src = "00" or fetch_d.PC_Src = "10")  and fetch_d.Pc_Src_WB /= "10" 
  else std_logic_vector(unsigned(PC_Out) - 1) when fetch_d.Pc_Src = "01" and fetch_d.Pc_Src_WB /= "10"
  else fetch_d.WB_Out when fetch_d.Pc_Src_WB = "10" 
  else ZERO;

  fetch_q.PC_fetch_Out<= PC_Out;
end Architecture a_Fetch;