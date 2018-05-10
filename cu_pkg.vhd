library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package cu_pkg is
    type cu_in is record
  	OpCode: std_logic_vector(4 downto 0);
 	 Flag: std_logic_vector(3 downto 0);
 	 Interrupt : std_logic;
 	 Reseti : std_logic;
  	Stall :  std_logic;
    end record cu_in;

    type cu_out is record
	PC_Src :  std_logic_vector( 1 downto 0);
  	WB_Src :  std_logic_vector( 1 downto 0);
	IV_Src :  std_logic;
  	Alu_Src :  std_logic;
 	Mem_Stack :  std_logic;
  	Outport :  std_logic;
  	Memory_Write :  std_logic;
  	Memory_Read :  std_logic;
  	Reg_Write :  std_logic;		--di hya al write_enable ali da5la lel decode mn al buffer4
  	Stack_Pointer :  std_logic;
  	Write_En_Buffer1 :  std_logic; 			
  	Pop_Sig :  std_logic; 
	Push_Sig:   std_logic;
  	Call_Sig :  std_logic;
  	Ret_Sig :  std_logic; -- 5araga mn CU lma yegy ret aw reti
  	Reti_Sig :  std_logic;
	ResetSignal:  std_logic;
	RegTwoOp  : std_logic;
	intBit	: std_logic;
	jmpSuccess : std_logic;
	addSub_stack : std_logic;
    end record cu_out;

end package cu_pkg;
