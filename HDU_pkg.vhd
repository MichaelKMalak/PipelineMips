library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package hdu_pkg is
    type hdu_in is record
  	Next_Stage_Reg : std_logic_vector( 2 downto 0);
	Src_Reg: std_logic_vector(2 downto 0);
 	Des_Reg: std_logic_vector(2 downto 0);
 	Reg_Used : std_logic; -- 1 hast3ml 2 reg ...0 hast3ml wa7ed... gaya mn alcontrol unit
  	Mem_Read : std_logic;
	Int_Sig : std_logic;
  	Pop_Sig : std_logic; -- 5araga mn CU
  	Call_Sig : std_logic; -- 5araga mn CU
  	Ret_Sig : std_logic; -- 5araga mn CU lma yegy ret aw reti
  	Jump_Success : std_logic; 
	Reset : std_logic;
    end record hdu_in;

    type hdu_out is record
	Flush : std_logic;
  	Flush_Mem : std_logic; -- alfar2 mabeno w maben alflush al3adyy da byflush 2 buffers 
  	Stall : std_logic;
    end record hdu_out;

end package hdu_pkg;
