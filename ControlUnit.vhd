Library ieee;
use ieee.std_logic_1164.all;
use work.cu_pkg.all;
use work.Opcodes_pkg.all;

entity CU is
  port(cu_d : in cu_in; 
	cu_q : out cu_out
);
end entity CU;
Architecture a_CU of CU is
signal Jump_Success : std_logic;
signal jtype : std_logic;
signal Rtype : std_logic;
signal Itype : std_logic;
signal Memory_Read_sig : std_logic;
signal Memory_Write_sig : std_logic;
  begin
  jtype <= '1' when (cu_d.OpCode(4 downto 2) = "101") or (cu_d.OpCode(4 downto 1) = "1100") or (cu_d.OpCode = "11111") or (cu_d.OpCode = "00000")
  else '0' ;
  
  Rtype <= '1' when cu_d.OpCode(4) = '0' and jtype = '0'
  else '0' ;

  Itype <= '1' when ( cu_d.OpCode(4) = '1' and(jtype = '1' or cu_d.OpCode(4 downto 1) = "1001") )
  else '0';

  Jump_Success <= '1' when (cu_d.OpCode(4 downto 2) = "101") and ( cu_d.OpCode(1 downto 0) = "11" or (cu_d.Flag(0) = '1' and cu_d.OpCode(2 downto 0) = "011") or (cu_d.Flag(2) = '1' and cu_d.OpCode(2 downto 0) = "110") or (cu_d.Flag(1) = '1' and cu_d.OpCode(2 downto 0) = "101") );
  cu_q.Memory_Read <= Memory_Read_sig ;
  cu_q.Memory_Write <= Memory_Write_sig;

  cu_q.PC_Src <= "01" when cu_d.Stall = '1'
  else "10" when (Jump_Success = '1') or (cu_d.OpCode(4 downto 1) = "1100") or (cu_d.OpCode = "11111") or cu_d.Interrupt = '1' or cu_d.Reseti = '1'
  else "00" ;

  cu_q.IV_Src <= '1' when cu_d.OpCode = "10001"
  else '0' ;

  cu_q.Alu_Src <= '1' when (cu_d.OpCode = "11100") or (cu_d.OpCode(4 downto 1) = "0111") or (cu_d.OpCode(4 downto 1) = "1101") 
  else '0' ;
 
  cu_q.Write_En_Buffer1 <= '0' when (cu_d.OpCode = "11100") or (cu_d.OpCode(4 downto 1) = "0111") or (cu_d.OpCode(4 downto 1) = "1101") 
  else '1' ;

  --Mem_Stack is one we use stack not memory and vice versa
  cu_q.Mem_Stack <= '1' when ( (cu_d.OpCode(4 downto 2) = "111") and (cu_d.OpCode /= "11100") ) or (cu_d.Interrupt = '1') or (cu_d.OpCode (4 downto 1) = "1100")
  else '0' ;

  cu_q.Outport <= '1' when cu_d.OpCode = "10000"
  else '0' ;

  cu_q.WB_Src <= "01" when cu_d.OpCode = "11100"
  else "10" when Memory_Read_sig = '1'
  else "11" when (Jump_Success = '1') or (cu_d.OpCode = "11111") or (cu_d.OpCode = "10000")
  else "00" ;

  Memory_Write_sig <= '1' when  (( ( cu_d.OpCode(4) = '1' and(jtype = '1' or cu_d.OpCode(4 downto 1) = "1001")) and (cu_d.OpCode(2 downto 0) = "011" or cu_d.OpCode(2 downto 0) = "110")) or cu_d.OpCode(4 downto 0) = "11111") 
  else '0' ;

  Memory_Read_sig <= '1' when (jtype = '1' and cu_d.OpCode(3 downto 2) = "10") or (( cu_d.OpCode(4) = '1' and(jtype = '1' or cu_d.OpCode(4 downto 1) = "1001"))and cu_d.OpCode(3 downto 1) = "110" ) 
  else '0' ;
  
  cu_q.Reg_Write <= '1' when (jtype = '0') or ( Rtype = '1' ) or (  Itype = '1' and Memory_Write_sig = '0' and cu_d.OpCode(2 downto 0) = "000" )
  else '0' ;

  cu_q.Stack_Pointer <= '1' when cu_d.OpCode(4 downto 1) = "1111" -- if it's 1 then sp--
  else '0' ;
 

  cu_q.Pop_Sig  <= '1' when cu_d.OpCode = "11101"
  else '0' ;

  cu_q.Call_Sig  <= '1' when cu_d.OpCode = "11111"
  else '0' ;

  cu_q.Ret_Sig  <= '1' when cu_d.OpCode (4 downto 1) = "1100"
  else '0' ;

  cu_q.Reti_Sig <= '1' when cu_d.OpCode = "11001"
  else '0';
 
  cu_q.ResetSignal <= '1' when cu_d.Reseti = '1'
  else '0';

	cu_q.RegTwoOp <='1' when Rtype = '1' and cu_d.OpCode(4 downto 3) ="00" 
else '0';

	cu_q.intBit <='1' when cu_d.Interrupt = '1' 
else '0';

	cu_q.jmpSuccess<=Jump_Success;

 cu_q.addSub_stack <= '1' when (cu_d.OpCode(4 downto 0) = RET_OPCODE) or (cu_d.OpCode(4 downto 0) = RETI_OPCODE) or (cu_d.OpCode(4 downto 0) = PUSH_OPCODE)
else '0';
cu_q.Push_Sig<='1' when cu_d.OpCode(4 downto 0) = PUSH_OPCODE
	else '0';
  end Architecture a_CU;



