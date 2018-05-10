----------- FU ------------------
--found in Decode stage.
-- Buffers are as follows: IF/ID -> ID/EX -> EX/MEM -> MEM/WB

--Check page 307, at the part of !=0 3ashan msh fahmo -> REGISTER 0 WON'T FORWARD.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fu_pkg.all;

Entity FU is 
	port (  fu_d : in fu_in; 
		fu_q : out fu_out
		);
end entity FU;

architecture FU_arch of FU is
signal EX_Hazard_A : std_logic := '0';
signal MEM_Hazard_A : std_logic := '0';
signal EX_Hazard_B : std_logic := '0';
signal MEM_Hazard_B : std_logic := '0';
begin
	EX_Hazard_A <= '1' when fu_d.RegWrite_ExMem='1' and  fu_d.RegDst_ExMem = fu_d.RegDst_Id
			else '0';
	MEM_Hazard_A <= '1' when fu_d.RegWrite_MemWb='1' and ( fu_d.RegDst_MemWb = fu_d.RegDst_Id ) and (EX_Hazard_A='0')
			else '0';
	EX_Hazard_B <= '1' when fu_d.RegSelect='1' and fu_d.RegWrite_ExMem='1' and  fu_d.RegDst_ExMem=fu_d.RegSrc_Id
			else '0';
	MEM_Hazard_B <= '1' when fu_d.RegSelect='1' and fu_d.RegWrite_MemWb='1' and ( fu_d.RegDst_MemWb = fu_d.RegSrc_Id ) and (EX_Hazard_B='0')
			else '0';

   	fu_q.ForwardA <= "10" when EX_Hazard_A='1' else 
        	"01" when MEM_Hazard_A='1'  else 
        	"00";
   	fu_q.ForwardB <= "10" when EX_Hazard_B='1' else 
        	"01" when MEM_Hazard_B='1' else         	
		"00";
end architecture FU_arch;
