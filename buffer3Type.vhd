library ieee;
use ieee.std_logic_1164.all;
use work.buffers_pkg.all;

entity buffer3Type is
  port(clk, rst, we : in std_logic;
        d: in buffer3_in;
        q: out buffer3_in
        );
  end buffer3Type;
  
architecture buffer3Type_a of buffer3Type is 
	signal zeros:buffer3_in;
  begin 


zeros.PC_Out <="0000000000000000";
	zeros.Instruction<="0000000000000000";
	zeros.immediate<="0000000000000000";
	zeros.operand2 <="0000000000000000";
	zeros.PC_Src  <="00";
  	zeros.WB_Src <="00";
 	zeros.Mem_Stack <='0';
  	zeros.Outport <='0';
  	zeros.Memory_Write <='0';
  	zeros.Memory_Read<='0';
  	zeros.Reg_Write <='0';
	zeros.Push_Sig <='0';
  	zeros.Call_Sig <='0';
  	zeros.Ret_Sig<='0';
  	zeros.Reti_Sig<='0';
	zeros.ResetSignal<='0';
	zeros.intBit	<='0';
	zeros.CCRflags<="0000";
	zeros.SPaddr<="0000000000";
	zeros.AluData<="0000000000000000";

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
  end buffer3Type_a;
  