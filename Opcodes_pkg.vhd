library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.common_pkg.all;

package Opcodes_pkg is
    constant ZERO: std_logic_vector (word'range) := (others=>'0');
    constant NOP_OPCODE : opcode := "00000";
    constant RLC_OPCODE : opcode := "00010";
    constant RRC_OPCODE : opcode := "00011";
    constant NOT_OPCODE : opcode := "00100";
    constant NEG_OPCODE : opcode := "00101";
    constant INC_OPCODE : opcode := "00110";
    constant DEC_OPCODE : opcode := "00111";
    constant MOV_OPCODE : opcode := "01001";
    constant ADD_OPCODE : opcode := "01010";
    constant SUB_OPCODE : opcode := "01011";
    constant AND_OPCODE : opcode := "01100";
    constant OR_OPCODE : opcode  := "01101";
    constant SHL_OPCODE : opcode := "01110";
    constant SHR_OPCODE : opcode := "01111";
    constant OUT_OPCODE : opcode := "10000";
    constant IN_OPCODE : opcode  := "10001";
    constant SETC_OPCODE : opcode:= "10010";
    constant CLRC_OPCODE : opcode := "10011";
    constant JZ_OPCODE : opcode   := "10100";
    constant JN_OPCODE : opcode   := "10101";
    constant JC_OPCODE : opcode   := "10110";
    constant JMP_OPCODE : opcode  := "10111";
    constant RET_OPCODE : opcode  := "11000";
    constant RETI_OPCODE : opcode := "11001";
    constant LDD_OPCODE : opcode  := "11010";
    constant STD_OPCODE : opcode  := "11011";
    constant LDM_OPCODE : opcode  := "11100";
    constant POP_OPCODE : opcode  := "11101";
    constant PUSH_OPCODE : opcode := "11110";
    constant CALL_OPCODE : opcode := "11111";

end package  Opcodes_pkg;
