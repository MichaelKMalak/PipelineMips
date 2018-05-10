Library ieee;
Use ieee.std_logic_1164.all;
use work.Opcodes_pkg.all;
use work.common_pkg.all;

Entity ALUmain is
  Port( R1, R2 : in word; 
      OP : in opcode;
	flagsIn : in ALUflags; 
      ALUout:out word; 
      Flags_Out : out ALUflags);
End ALUmain;
  
Architecture Behavior_ALUmain of ALUmain is

component OneOperand is
  Port( 
      R1 : in word; 
      OP : in opcode;
      flagsIn: in ALUflags;
      ALUout: out word; 
      flagsOut : out ALUflags
      );
End component;

 component TwoOperands is
  Port( R1, R2 : word; 
      OP : in opcode; 
	flagsIn: in ALUflags;
      ALUout:out word; 
      Flags : out ALUflags);
End component;

 Signal oneOp_out: std_logic_vector(15 downto 0); 
 Signal twoOp_out: std_logic_vector(15 downto 0); 
 Signal oneOpFlag_out: std_logic_vector(3 downto 0);
 Signal twoOpFlag_out: std_logic_vector(3 downto 0);
 
 Begin
   
 One: OneOperand port map(R1, OP, flagsIn, oneOp_out, oneOpFlag_out);  
 Two: TwoOperands port map (R1, R2, OP,flagsIn,  twoOp_out, twoOpFlag_out);    

 With OP Select
 ALUout <= oneOp_out When RLC_OPCODE |  RRC_OPCODE |  NOT_OPCODE |  NEG_OPCODE |  INC_OPCODE |  DEC_OPCODE,
          twoOp_out When ADD_OPCODE |  SUB_OPCODE |  AND_OPCODE |  OR_OPCODE |  SHR_OPCODE |  SHL_OPCODE,
           "XXXXXXXXXXXXXXXX" WHEN OTHERS;          
         
With OP Select
Flags_Out <=  oneOpFlag_out When RLC_OPCODE |  RRC_OPCODE |  NOT_OPCODE |  NEG_OPCODE |  INC_OPCODE |  DEC_OPCODE | CLRC_OPCODE | SETC_OPCODE,
           twoOpFlag_out When ADD_OPCODE |  SUB_OPCODE |  AND_OPCODE |  OR_OPCODE |  SHR_OPCODE |  SHL_OPCODE,
           "XXXX" WHEN OTHERS;  
                 

End Behavior_ALUmain;