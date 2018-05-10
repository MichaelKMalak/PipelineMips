library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;
use work.fetch_pkg.all;


package buffers_pkg is
    type buffer1_in is record
	Instruction : std_logic_vector(15 downto 0);
	PC_fetch_Out :std_logic_vector(15 downto 0);
    end record buffer1_in;
--=================================================================
    type buffer2_in is record
	PC_Out : word;
	Instruction: word;
	immediate: word;
--Forward out
	FWDA:  std_logic_vector(1 downto 0);
	FWDB:  std_logic_vector(1 downto 0);
--Decode Out
	operand1 : word;
	operand2 : word;
	--Out_STACK: word;
--CU out
	PC_Src :  std_logic_vector( 1 downto 0);
  	WB_Src :  std_logic_vector( 1 downto 0);
	--IV_Src :  std_logic;
  	Alu_imm :  std_logic; -- equals ALU_source
 	Mem_Stack :  std_logic;
  	Outport :  std_logic;
  	Memory_Write :  std_logic;
  	Memory_Read :  std_logic;
  	Reg_Write :  std_logic;		--di hya al write_enable ali da5la lel decode mn al buffer4
  	--Stack_Pointer :  std_logic;
  	--Write_En_Buffer1 :  std_logic; 			
  	--Flags_Restored :  std_logic; -- lma ygely reti
  	--Pop_Sig :  std_logic; 
	Push_Sig:  std_logic; 
  	Call_Sig :  std_logic;
  	Ret_Sig :  std_logic; -- 5araga mn CU lma yegy ret aw reti
  	Reti_Sig :  std_logic;
	ResetSignal:  std_logic;
	--RegTwoOp  : std_logic;
	intBit	: std_logic;
	--jmpSuccess : std_logic;
	--addSub_stack : std_logic;
--HDU out
	--Flush : std_logic;
  	--Flush_Mem : std_logic; -- alfar2 mabeno w maben alflush al3adyy da byflush 2 buffers 
  	--Stall : std_logic;
SPaddr: address_size;	
    end record buffer2_in;

    
--=================================================================--=================================================================
    type buffer3_in is record
	PC_Out : word;
	Instruction: word;
	immediate: word;
--Forward out
	--FWDA:  std_logic_vector(1 downto 0);
	--FWDB:  std_logic_vector(1 downto 0);
--Decode Out
	--operand1 : word;
	operand2 : word;
	--Out_STACK: word;
--CU out
	PC_Src :  std_logic_vector( 1 downto 0);
  	WB_Src :  std_logic_vector( 1 downto 0);
	--IV_Src :  std_logic;
  	------------------------Alu_imm :  std_logic; -- equals ALU_source
 	Mem_Stack :  std_logic;
  	Outport :  std_logic;
  	Memory_Write :  std_logic;	--DECODE
  	Memory_Read :  std_logic;
  	Reg_Write :  std_logic;		--di hya al write_enable ali da5la lel decode mn al buffer4
  	--Stack_Pointer :  std_logic;
  	--Write_En_Buffer1 :  std_logic; 			
  	--Flags_Restored :  std_logic; -- lma ygely reti
  	--Pop_Sig :  std_logic; 
	Push_Sig : std_logic; 
  	Call_Sig :  std_logic;
  	Ret_Sig :  std_logic; -- 5araga mn CU lma yegy ret aw reti
  	Reti_Sig :  std_logic;
	ResetSignal:  std_logic;
	--RegTwoOp  : std_logic;
	intBit	: std_logic;
	--jmpSuccess : std_logic;
	--addSub_stack : std_logic;
--HDU out
	--Flush : std_logic;
  	--Flush_Mem : std_logic; -- alfar2 mabeno w maben alflush al3adyy da byflush 2 buffers 
  	--Stall : std_logic;
--IMM value
	--ALUimm: word;
--EX out
	--AluOutput:word;
	--Flags: ALUflags;
	CCRflags: ALUflags;	--FROM execute
	SPaddr: address_size;	
	AluData:word;
    end record buffer3_in;

     
--=================================================================--=================================================================
    type buffer4_in is record
		PC_Out : word;
	Instruction: word;
	immediate: word;
--Forward out
	--FWDA:  std_logic_vector(1 downto 0);
	--FWDB:  std_logic_vector(1 downto 0);
--Decode Out
	--operand1 : word;
	operand2 : word;
	--Out_STACK: word;
--CU out
	PC_Src :  std_logic_vector( 1 downto 0);
  	WB_Src :  std_logic_vector( 1 downto 0);
	--IV_Src :  std_logic;
  	------------------------Alu_imm :  std_logic; -- equals ALU_source
 	--Mem_Stack :  std_logic;
  	Outport :  std_logic;
  	Memory_Write :  std_logic;	--DECODE
  	Memory_Read :  std_logic;
  	Reg_Write :  std_logic;		--di hya al write_enable ali da5la lel decode mn al buffer4
  	--Stack_Pointer :  std_logic;
  	--Write_En_Buffer1 :  std_logic; 			
  	--Flags_Restored :  std_logic; -- lma ygely reti
  	--Pop_Sig :  std_logic; 
	Push_Sig : std_logic; 
  	Call_Sig :  std_logic;
  	Ret_Sig :  std_logic; -- 5araga mn CU lma yegy ret aw reti
  	Reti_Sig :  std_logic;
	ResetSignal:  std_logic;
	--RegTwoOp  : std_logic;
	intBit	: std_logic;
	--jmpSuccess : std_logic;
	--addSub_stack : std_logic;
--HDU out
	--Flush : std_logic;
  	--Flush_Mem : std_logic; -- alfar2 mabeno w maben alflush al3adyy da byflush 2 buffers 
  	--Stall : std_logic;
--IMM value
	--ALUimm: word;
--EX out
	--AluOutput:word;
	--Flags: ALUflags;
	AluData:word;
	memData:word;
    end record buffer4_in;
end package;
    
