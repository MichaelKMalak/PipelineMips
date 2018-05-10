library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package ex_pkg is
    type ex_in is record
	
       	FWDA : std_logic_vector(1 downto 0);
	FWDB: std_logic_vector(1 downto 0);
	ALUimm: std_logic;	--using immediate value
	wbFlags: std_logic; --when I need to return the flags
	restoredFlags: ALUflags;
	ALUop: opcode;		--opcode
	operand1: word;	--SRC
	operand2: word;	--DST
	immediate: word;
	AluDataFU: word;
	MemDataFU: word;

    end record ex_in;

    -- outputs from execution stage
        type ex_out is record
       	AluOutput:word;
	Flags: ALUflags;
    end record ex_out;

end package  ex_pkg;
