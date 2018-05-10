Library ieee;
use ieee.std_logic_1164.all;
use work.hdu_pkg.all;
use work.common_pkg.all;

entity HDU is
  port(HDU_d : in hdu_in; 
	HDU_q : out hdu_out
);
end entity HDU;
Architecture a_HDU of HDU is
signal stall : std_logic;
  begin
   
  stall <= '1' when (HDU_d.Mem_Read = '1' or HDU_d.Pop_Sig = '1') and ((HDU_d.Reg_Used = '0' and HDU_d.Des_Reg = HDU_d.Next_Stage_Reg) or (HDU_d.Reg_Used = '1' and (HDU_d.Des_Reg = HDU_d.Next_Stage_Reg or HDU_d.Src_Reg = HDU_d.Next_Stage_Reg) ) ) 
  else '0';

 HDU_q.Stall<=stall;

  HDU_q.Flush <= '1' when HDU_d.Jump_Success = '1' or HDU_d.Call_Sig = '1' or stall='1'
  else '0';

  HDU_q.Flush_Mem <= '1' when HDU_d.Ret_Sig = '1' or HDU_d.Reset = '1' or HDU_d.Int_Sig = '1'
  else '0';
  
end Architecture a_HDU;