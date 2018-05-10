Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fetch_pkg.all;
use work.decode_pkg.all;
use work.mem_pkg.all;
use work.ex_pkg.all;
use work.cu_pkg.all;
use work.fu_pkg.all;
use work.hdu_pkg.all;
use work.buffers_pkg.all;
use work.common_pkg.all;

entity main is
  port( clk : in std_logic;
	interrupt: in std_logic;
	reset: in std_logic;
   	inPort: in word;
	outPort: out word
);
end entity main;

Architecture a_main of main is

component Fetch is
  port( Clk : in std_logic;
   	fetch_d : in fetch_in; 
	fetch_q : out fetch_out
);
end component;

component Decode is
  port( Clk : in std_logic;
   	decode_d : in decode_in; 
	decode_q : out decode_out
);
end component;

component instruction_executor is
    port ( clk : std_logic;
	   rst: std_logic;
	ex_d : in  ex_in;
          ex_q : out ex_out);
end component;

component memory_unit is
    Port (clk: in std_logic;	
	  mem_d : in  mem_in;
          mem_q : out mem_out);
End component;

component buffer1Type is
  port(clk, rst, we : in std_logic;
        d: in buffer1_in;
        q: out buffer1_in
        );
  end component;
component buffer2Type is
  port(clk, rst, we : in std_logic;
        d: in buffer2_in;
        q: out buffer2_in
        );
  end component;
component buffer3Type is
  port(clk, rst, we : in std_logic;
        d: in buffer3_in;
        q: out buffer3_in
        );
  end component;
component buffer4Type is
  port(clk, rst, we : in std_logic;
        d: in buffer4_in;
        q: out buffer4_in
        );
  end component;

component CU is
  port(cu_d : in cu_in; 
	cu_q : out cu_out
);
end component;
component HDU is
  port(HDU_d : in hdu_in; 
	HDU_q : out hdu_out
);
end component;

component FU is 
port (  fu_d : in fu_in; 
		fu_q : out fu_out
		);
end component;

component SPunit is
Generic (n : integer := 10); --should always be 10
  port(clk, en, addSub	: in std_logic; --when add: addSub='1' else addSub='0'
	SPin		: in std_logic_vector (n-1 downto 0);
	SPout		: out std_logic_vector (n-1 downto 0);
	SPout_prev	: out std_logic_vector (n-1 downto 0)
  );
end component;
	

--========== FETCH ============
signal fetchInput 	: fetch_in;
signal fetchOutput 	: fetch_out;
signal buffer1Input 	: buffer1_in;
signal buffer1Output 	: buffer1_in;
--========== DECODE ============
signal decodeInput 	: decode_in;
signal decodeOutput 	: decode_out;
signal fuInput 		: fu_in;
signal fuOutput 	: fu_out;
signal cuInput	 	: cu_in;
signal cuOutput 	: cu_out;
signal hduInput	 	: hdu_in;
signal hduOutput 	: hdu_out;
signal spInput	 	: address_size;
signal spOutput 	: address_size;
signal buffer2Input 	: buffer2_in;
signal buffer2Output 	: buffer2_in;
signal SP_unit_output	: address_size;
signal SP_unit_prev	: address_size;
signal SP_propagated 	: address_size;
--signal RegWrite_ExMem	: std_logic;
--signal RegWrite_MemWB	: std_logic;
--signal RegWrite_WB	: std_logic;
signal FlushBit_1	: std_logic;
--========== EXECUTE ============
signal executeInput 	: ex_in;
signal executeOutput 	: ex_out;
signal buffer3Input 	: buffer3_in;
signal buffer3Output 	: buffer3_in;
--========== MEMORY ============
signal memoryInput 	: mem_in;
signal memoryOutput 	: mem_out;
signal buffer4Input 	: buffer4_in;
signal buffer4Output 	: buffer4_in;
signal PC_out_memStage	: word;
--========== WriteBack ============
signal WBdata		: word;

  begin


--====================================================== FETCH -====================================================== 
fetch_stage		: Fetch port map( clk, fetchInput, fetchOutput);
	fetchInput.PC_Src <=cuOutput.PC_Src;
	fetchInput.PC_Src_WB <=buffer4Output.PC_Src;	
	fetchInput.WB_Out <=buffer4Output.memData  when (cuOutput.PC_Src /= "10") else 
				decodeOutput.Data2;			

----- BUFFER 1 -----
buffer_fetchDecode	: buffer1Type  port map (clk,rst=>FlushBit_1, we=>cuOutput.Write_En_Buffer1, d=>buffer1Input ,q=>buffer1Output); 

	buffer1Input.Instruction<=fetchOutput.Instruction;
	buffer1Input.PC_fetch_Out<=fetchOutput.PC_fetch_Out;
---====================================================== DECODE -====================================================== 
--RegWrite_ExMem <= '1' when buffer2Output.WB_Src="11" 
	--	else '0';
--RegWrite_MemWB  <= '1' when buffer3Output.WB_Src="11" 
	--	else '0';
--RegWrite_WB  <= '1' when buffer4Output.WB_Src="11" 
	--	else '0';
FlushBit_1<= '1' when (hduOutput.Flush='1') or (hduOutput.Flush_Mem='1')
else '0';
decode_stage		: Decode port map( clk, decodeInput, decodeOutput);
	
	decodeInput.Instruction <=buffer1Output.Instruction;
   	decodeInput.Write_Address <= buffer4Output.Instruction(7 downto 5); 		
	decodeInput.Write_Enable <=buffer4Output.Reg_Write;--: std_logic;	--> PROPAGATE from buffer4 (WB)
	decodeInput.Write_Val	 <=WBdata;				-->: word;	 	PROPAGATE from a MUX at (WB)
	decodeInput.Write_Stack_Enable <= cuOutput.Mem_Stack;
	decodeInput.Write_Stack_Val <= SP_unit_output&"000000";

controlUnit		: CU port map( cuInput, cuOutput);
	cuInput.OpCode <= buffer1Output.Instruction(15 downto 11);
	cuInput.Flag <= executeOutput.Flags;	 	
	cuInput.Interrupt <= interrupt;
	cuInput.Reseti <= reset;
	cuInput.Stall<=hduOutput.Stall;



forwardUnit		: FU port map( fuInput, fuOutput);
	fuInput.RegSrc_Id  <= buffer1Output.Instruction(10 downto 8);
	fuInput.RegDst_Id  <= buffer1Output.Instruction(7 downto 5);
	fuInput.RegDst_ExMem  <= buffer2Output.Instruction(7 downto 5);	--PROPAGATE instruction/ immediate value
	fuInput.RegDst_MemWb <= buffer3Output.Instruction(7 downto 5);	--PROPAGATE instruction/ immediate value
	fuInput.RegSelect <= cuOutput.RegTwoOp;
	fuInput.RegWrite_ExMem  <= buffer3Output.Reg_Write; 			-- PROPAGATED: write back signal to write on the registers
	fuInput.RegWrite_MemWB  <= buffer4Output.Reg_Write;			-- PROPAGATED: write back signal to write on the registers


HazardDetectionUnit	: HDU port map( hduInput, hduOutput);
	
	hduInput.Next_Stage_Reg <= buffer2Output.Instruction(7 downto 5);	--PROPAGATE instruction/ immediate value
	hduInput.Reg_Used <= cuOutput.RegTwoOp;
	hduInput.Src_Reg  <= buffer1Output.Instruction(10 downto 8);
	hduInput.Des_Reg  <= buffer1Output.Instruction(7 downto 5);
  	hduInput.Mem_Read <= buffer2Output.Memory_Read;				--PROPAGATE CU SIGNAL
	hduInput.Int_Sig <= cuOutput.intBit;
  	hduInput.Pop_Sig <= cuOutput.Pop_Sig; 
	hduInput.Call_Sig <= cuOutput.Call_Sig; 
	hduInput.Ret_Sig <= cuOutput.Ret_Sig; 
	hduInput.Jump_Success <= cuOutput.jmpSuccess; 
	hduInput.Reset<= cuOutput.ResetSignal;
	


StackPointerUnit	: SPunit generic map (n=>10) port map( clk, en=>cuOutput.Mem_Stack, addSub=>cuOutput.addSub_stack, SPin=> decodeOutput.Out_STACK(9 downto 0), SPout=> SP_unit_output, SPout_prev=>SP_unit_prev);
	

------ BUFFER 2 ------
	SP_propagated <= SP_unit_prev when cuOutput.addSub_stack='1'
	 else SP_unit_output;

buffer_decodeEx		: buffer2Type port map (clk,rst=>hduOutput.Flush_Mem, we=>'1', d=>buffer2Input ,q=>buffer2Output); 
	
	buffer2Input.Reg_Write<=cuOutput.Reg_Write;
	buffer2Input.Mem_Stack<=cuOutput.Mem_Stack;
	buffer2Input.Reti_Sig<=cuOutput.Reti_Sig;
	buffer2Input.PC_Out<=fetchOutput.PC_fetch_Out;
	buffer2Input.immediate<=fetchOutput.Instruction;
	buffer2Input.Instruction<=buffer1Output.Instruction;
	buffer2Input.FWDA<=fuOutput.ForwardA;
	buffer2Input.FWDB<=fuOutput.ForwardB;
	buffer2Input.operand1<=decodeOutput.Data1;
	buffer2Input.operand2<=decodeOutput.Data2;
	buffer2Input.WB_Src<=cuOutput.WB_Src;
	buffer2Input.Alu_imm<=cuOutput.Alu_Src;
	buffer2Input.Memory_Read<=cuOutput.Memory_Read;
--
	buffer2Input.PC_Src<=cuOutput.PC_Src;
	buffer2Input.Outport<=cuOutput.Outport;
	buffer2Input.Memory_Write<=cuOutput.Memory_Write;
	buffer2Input.Push_Sig<=cuOutput.Push_Sig;
	buffer2Input.Call_Sig<=cuOutput.Call_Sig;
	buffer2Input.Ret_Sig<=cuOutput.Ret_Sig;
	buffer2Input.ResetSignal<=cuOutput.ResetSignal;
	buffer2Input.intBit<=cuOutput.intBit;
	buffer2Input.SPaddr<=SP_propagated;
---====================================================== EXECUTE ====================================================== 
execute_stage		: instruction_executor port map( clk, reset, executeInput, executeOutput);

--in
	executeInput.FWDA <= buffer2Output.FWDA;
	executeInput.FWDB <= buffer2Output.FWDB;
	executeInput.ALUimm <= buffer2Output.ALU_imm; 		--> from ALUSRC from CU
	executeInput.ALUop <= buffer2Output.Instruction(15 downto 11);	
	executeInput.operand1 <= buffer2Output.operand1; 	--> data 1 SRC
	executeInput.operand2 <= buffer2Output.operand2; 	--> data 2 DST
	executeInput.immediate <= buffer2Output.immediate;	--> from buffer2 (da5el 3aleh 3alatol mn al Instruction memory)
	executeInput.wbFlags <= buffer4Output.Reti_Sig;
	executeInput.restoredFlags <= WBdata(15 downto 12);
	executeInput.AluDataFU <= buffer3Output.AluData;	--> from buffer3 (from ALUoutput)
	executeInput.MemDataFU <= buffer4Output.AluData;	--> from buffer4 (from AluDataFU)

--out
       	--AluOutput:word;
	--Flags: ALUflags;

----- BUFFER 3 ------
buffer_exMem		: buffer3Type port map (clk,rst=>reset, we=>'1', d=>buffer3Input ,q=>buffer3Output);  
	buffer3Input.Reg_Write<=buffer2Output.Reg_Write;
	buffer3Input.PC_Src<=buffer2Output.PC_Src;
	buffer3Input.PC_Out<=buffer2Output.PC_Out;
	buffer3Input.Instruction<=buffer2Output.Instruction;
	buffer3Input.operand2<=buffer2Output.operand2;
	buffer3Input.WB_Src<=buffer2Output.WB_Src;
	buffer3Input.immediate<=buffer2Output.immediate;
	buffer3Input.Memory_Read<=buffer2Output.Memory_Read;
	buffer3Input.Reti_Sig<=buffer2Output.Reti_Sig;

---
	buffer3Input.Mem_Stack<=buffer2Output.Mem_Stack;
	buffer3Input.Outport<=buffer2Output.Outport;
	buffer3Input.Memory_Write<=buffer2Output.Memory_Write;
	buffer3Input.Push_Sig<=buffer2Output.Push_Sig;
	buffer3Input.Call_Sig<=buffer2Output.Call_Sig;
	buffer3Input.Ret_Sig<=buffer2Output.Ret_Sig;
	buffer3Input.ResetSignal<=buffer2Output.ResetSignal;
	buffer3Input.intBit<=buffer2Output.intBit;
	buffer3Input.SPaddr<=buffer2Output.SPaddr;
---
	buffer3Input.AluData<=executeOutput.AluOutput;
	buffer3Input.CCRflags<=executeOutput.Flags;

---====================================================== MEMORY -====================================================== 
Memory_stage		: memory_unit port map( clk, memoryInput, memoryOutput);

PC_out_memStage		<= std_logic_vector(unsigned(buffer3Output.PC_out) + 1) when buffer3Output.Call_Sig ='1' 
			else buffer3Output.PC_out;
	
	--from buffer3 from buffer2 from CU
	memoryInput.INTsignal <= buffer3Output.intBit;
	memoryInput.RETsignal <= buffer3Output.Ret_Sig;
	memoryInput.CALLsignal <= buffer3Output.Call_Sig;
	memoryInput.MEMwrite <= buffer3Output.Memory_Write;		-- when PUSH, STD, CALL
	memoryInput.PushSignal <= buffer3Output.Push_Sig;
	memoryInput.ResetSignal <= buffer3Output.ResetSignal;
	memoryInput.MemStack <= buffer3Output.Mem_Stack;	--1:stack else memory
	memoryInput.ImmAddr <= buffer3Output.immediate(9 downto 0);	
	memoryInput.PCaddr <= PC_out_memStage(9 downto 0);	
	memoryInput.SPaddr <= buffer3Output.SPaddr;	
	memoryInput.operand2 <= buffer3Output.operand2;	--word
	memoryInput.CCRflags <= buffer3Output.CCRflags;	--word

--out       	memData:word;	--PC or SP or WBdata

------ BUFFER 4 -----
buffer_memWb		: buffer4Type port map (clk,rst=>reset, we=>'1', d=>buffer4Input ,q=>buffer4Output);
	buffer4Input.Reg_Write<=buffer3Output.Reg_Write;
	buffer4Input.Reti_Sig<=buffer3Output.Reti_Sig;  
	buffer4Input.PC_Out<=buffer3Output.PC_Out;
	buffer4Input.operand2<=buffer3Output.operand2;
	buffer4Input.WB_Src<=buffer3Output.WB_Src;
	buffer4Input.immediate<=buffer3Output.immediate;
	buffer4Input.AluData<=buffer3Output.AluData;
	buffer4Input.Outport<=buffer3Output.Outport;
	buffer4Input.PC_Src<=buffer3Output.PC_Src;
	buffer4Input.Instruction<=buffer3Output.Instruction;
	buffer4Input.memData<=memoryOutput.memData;

--====================================================== Write Back -====================================================== 

WBdata<= buffer4Output.immediate when buffer4Output.WB_Src = "01"		--propagated
	else buffer4Output.memData when buffer4Output.WB_Src = "10"		--from memory output
	else buffer4Output.AluData when buffer4Output.WB_Src = "11"		--from ALU
	else  buffer4Output.operand2;				--from DECODE

outPort <= WBdata when buffer4Output.Outport='1'		
		else "XXXXXXXXXXXXXXXX";

end Architecture a_main;
