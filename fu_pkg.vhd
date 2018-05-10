library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package fu_pkg is
    type fu_in is record
		RegSrc_Id	: regAddr;
		RegDst_Id	: regAddr;
		RegDst_ExMem	: regAddr;
		RegDst_MemWb	: regAddr;
		RegSelect	: std_logic;	-- 0: only Dest is important, 1: both Dest and Src are imp
		RegWrite_ExMem  : std_logic;	-- write back signal to write on the registers
		RegWrite_MemWB  : std_logic;

    end record fu_in;

    type fu_out is record
		ForwardA:  std_logic_vector(1 downto 0);	-- 00: Selects original data read from reg. 01: overwrite memory data of wb stage
		ForwardB:  std_logic_vector(1 downto 0);	-- 10: overwrite ALU data of memory stage
    end record fu_out;

end package fu_pkg;
