library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package mem_pkg is
    type mem_in is record
	INTsignal: std_logic;
	RETsignal: std_logic; --RET and RETI
	CALLsignal: std_logic; 
	MEMwrite:  std_logic; -- when PUSH, STD, CALL
	PushSignal:  std_logic;
	ResetSignal:  std_logic;
	MemStack: std_logic;	--1:stack else memory
	ImmAddr: address_size;
	PCaddr: address_size;	-- it is the pc+1 (AFTER the instruction)
	SPaddr: address_size;
	operand2: word;	--DST
	CCRflags:ALUflags;
    end record mem_in;

    -- outputs from execution stage
        type mem_out is record
       	memData:word;	--PC or SP or WBdata
    end record mem_out;

end package mem_pkg;
