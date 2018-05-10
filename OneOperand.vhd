Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all; 
use work.Opcodes_pkg.all;
use work.common_pkg.all;

-- R1: R dest 
-- R2: R src 
--Z<0>:=CCR<0> ; zero flag, change after arithmetic, logical, or shift operations
--N<0>:=CCR<1> ; negative flag, change after arithmetic, logical, or shift operations
--C<0>:=CCR<2> ; carry flag, change after arithmetic or shift operations.
--V<0>:=CCR<3> ; over flow, change after arithmetic or shift operations.

Entity OneOperand is
  Port( 
      R1 : in word; 
      OP : in opcode;
      flagsIn: in ALUflags;
      ALUout: out word; 
      flagsOut : out ALUflags
      );
End OneOperand;
  
Architecture Behavior_OneOperand of OneOperand is
signal extendedR1:  std_logic_vector(16 downto 0);
signal rotatedR1: word;
signal tempR1 :  std_logic_vector(16 downto 0);
signal flagsTemp : ALUflags;
Begin

rotatedR1<= R1(14 downto 0) & flagsIn(2) when OP = RLC_OPCODE else
           flagsIn(2) & R1(15 downto 1) when OP = RRC_OPCODE;

extendedR1 <= R1(15) & R1; 
tempR1 <=  not extendedR1 when OP = NOT_OPCODE else       
           std_logic_vector(unsigned(not extendedR1) + 1) when OP = NEG_OPCODE else 
           std_logic_vector(signed(extendedR1) + 1) when OP = INC_OPCODE else  
           std_logic_vector(signed(extendedR1) - 1) when OP = DEC_OPCODE;  
      
flagsTemp(0) <= '1' when rotatedR1=ZERO and (OP = RLC_OPCODE or OP = RRC_OPCODE ) else
	 '1' when  tempR1=ZERO&'0' and (OP = NEG_OPCODE or OP = NOT_OPCODE or OP = INC_OPCODE or OP = DEC_OPCODE) else
                '0';
            
flagsTemp(1) <= '1' when ((rotatedR1(15)='1' and (OP = RLC_OPCODE or OP = RRC_OPCODE )) or (tempR1(16)='1' and (OP = NEG_OPCODE or OP = NOT_OPCODE or OP = INC_OPCODE or OP = DEC_OPCODE))) else
                '0';		
flagsTemp(2) <= R1(15) when OP = RLC_OPCODE else -- The only opcode that changes carry is rotate with carry
            	R1(0) when OP = RRC_OPCODE else
		'1' when OP = SETC_OPCODE else
		'0' when OP = CLRC_OPCODE else 
		'0';
flagsTemp(3) <= '1' when tempR1(16)/=tempR1(15) and (OP = NEG_OPCODE or OP = NOT_OPCODE or OP = INC_OPCODE or OP = DEC_OPCODE) else
            '0'; 
                                
ALUout <= tempR1(15 downto 0) when (OP = NEG_OPCODE or OP = NOT_OPCODE or OP = INC_OPCODE or OP = DEC_OPCODE) else
		rotatedR1 when  (OP = RLC_OPCODE or OP = RRC_OPCODE ) else
		"XXXXXXXXXXXXXXXX";
flagsOut<=flagsTemp;
 
End Behavior_OneOperand;
