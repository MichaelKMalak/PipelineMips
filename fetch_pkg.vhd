library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package fetch_pkg is
    type fetch_in is record
	PC_Src : std_logic_vector( 1 downto 0); --PC_Src of decode stage from CU
	PC_Src_WB : std_logic_vector( 1 downto 0); --PC_Src from CU propagated till WB
	WB_Out : word;
    end record fetch_in;

    -- outputs from execution stage
        type fetch_out is record
	Instruction : word;
	PC_fetch_Out : word;
    end record fetch_out;

end package fetch_pkg;

