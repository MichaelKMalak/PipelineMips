library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;
use work.fetch_pkg.all;


package buffers_pkg is
    type buffer1_in is record
	Instruction : word;
	PC_fetch_Out : word;
    end record buffer1_in;
  type buffer1_out is record
	Instruction : word;
	PC_fetch_Out : word;
    end record buffer1_out;
end package buffers_pkg;