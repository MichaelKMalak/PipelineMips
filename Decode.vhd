Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.decode_pkg.all;
use work.common_pkg.all;

entity Decode is
  port( Clk : in std_logic;
   	decode_d : in decode_in; 
	decode_q : out decode_out
);
end entity Decode;
Architecture a_Decode of Decode is

component register_block is
  port(
	clk	   : in std_logic;
	read_add_a : in std_logic_vector(2 downto 0);
	read_add_b : in std_logic_vector(2 downto 0);
	write_en   : in std_logic;
	write_val  : in std_logic_vector(15 downto 0);
	write_add  : in std_logic_vector(2 downto 0);
	write_stackVal: in std_logic_vector(15 downto 0);
	write_stackEn : in std_logic;
	rega, regb : out std_logic_vector(15 downto 0);
	read_STACK : out std_logic_vector(15 downto 0)
  );
  end component;
signal Reg_Src : regAddr;
signal Reg_Des : regAddr;
  begin
  Reg_Src <= decode_d.Instruction(7 downto 5) when decode_d.Instruction(15 downto 12) = "0111"
  else decode_d.Instruction(10 downto 8);
  Reg_Des <= decode_d.Instruction(10 downto 8) when decode_d.Instruction(15 downto 11) = "11011" or decode_d.Instruction(15 downto 12) = "0111" --STD or SHR or SHL
  else decode_d.Instruction(7 downto 5);
  
reg0: register_block port map (clk=>Clk , write_stackVal=>decode_d.Write_Stack_Val,write_stackEn=>decode_d.Write_Stack_Enable, read_add_a=> Reg_Src  , read_add_b=> Reg_Des , write_en=>decode_d.Write_Enable , write_val=>decode_d.Write_Val , write_add=>decode_d.Write_Address , rega=>decode_q.Data1 , regb=>decode_q.Data2 , read_STACK=>decode_q.Out_STACK ); 
  

end Architecture a_Decode;
