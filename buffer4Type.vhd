
library ieee;
use ieee.std_logic_1164.all;
use work.buffers_pkg.all;

entity buffer4Type is
  port(clk, rst, we : in std_logic;
        d: in buffer4_in;
        q: out buffer4_in
        );
  end buffer4Type;
  
architecture buffer4Type_a of buffer4Type is 
	signal zeros:buffer4_in;
  begin 

	zeros.PC_Out<="0000000000000000";
	zeros.Instruction<="0000000000000000";
	zeros.immediate<="0000000000000000";
	zeros.operand2 <="0000000000000000";
	zeros.PC_Src<="00";
  	zeros.WB_Src <="00";
  	zeros.Outport <='0';
	zeros.Memory_Write<='0';
  	zeros.Memory_Read <='0';
  	zeros.Reg_Write <='0';
	zeros.Push_Sig <='0';
  	zeros.Call_Sig <='0';
  	zeros.Ret_Sig <='0';
  	zeros.Reti_Sig <='0';
	zeros.ResetSignal<='0';
	zeros.intBit	<='0';
	zeros.AluData<="0000000000000000";
	zeros.memData<="0000000000000000";

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
  end buffer4Type_a;
  