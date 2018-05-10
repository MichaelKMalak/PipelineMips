library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package decode_pkg is
    type decode_in is record
   	Write_Address: regAddr;
	Write_Enable : std_logic;
	Write_Stack_Enable : std_logic;
	Write_Stack_Val: word;
	Instruction : word;
	Write_Val: word;
    end record decode_in;

    -- outputs from execution stage
        type decode_out is record
	Data1 : word;
	Data2 : word;
	Out_STACK: word;
    end record decode_out;

end package decode_pkg;
