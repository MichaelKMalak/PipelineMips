Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all; 
use work.Opcodes_pkg.all;
use work.common_pkg.all;
-- R1: R dest 
-- R2: R src 

Entity TwoOperands is
  Port( R1, R2 : word; 
      OP : in opcode; 
	flagsIn: in ALUflags;
      ALUout:out word; 
      Flags : out ALUflags);
End TwoOperands;
  
Architecture Behavior_TwoOperands of TwoOperands is
  
 Component Nbit is
     Generic (n : integer := 16);
     Port(a, b : in std_logic_vector(n-1 downto 0) ;
	        cin : in std_logic;
	        s : out std_logic_vector(n-1 downto 0);
	        cout : out std_logic);
 End Component;
    
Signal tempOut: word;
Signal Sub_out: word;
Signal Add_out: word;
Signal tempFlag: std_logic_vector(3 downto 0);
Signal R2_2comp: word;

signal add_flag :std_logic;
signal sub_flag :std_logic;

Begin
  
 
 R2_2comp <= std_logic_vector(unsigned(not R2) + 1);
           
 Adder16 : Nbit generic map (n => 16) port map(R1 ,R2 , '0' , Add_out , add_flag);  
 Subrtactor16 : Nbit generic map (n => 16) port map(R1 , R2_2comp , '0' , Sub_out , sub_flag);          

 tempOut <= Add_out when OP = ADD_OPCODE else -- ADD
           Sub_out when OP = SUB_OPCODE else -- SUB
           R1 and R2 when OP = AND_OPCODE else -- AND
           R1 or R2 when OP = OR_OPCODE else -- OR
           std_logic_vector(shift_right(unsigned(R2), to_integer(unsigned(R1)))) when OP = SHR_OPCODE else 
           std_logic_vector(shift_left(unsigned(R2), to_integer(unsigned(R1)))) when OP = SHL_OPCODE else 
           R2 when OP = MOV_OPCODE; -- MOV
           
           
           --'0' & R1(15 downto to1) when OP = "01111" else -- SHR
           --to_stdlogicvector(to_bitvector(R1) srl to_integer(R2)) when OP = "01111" else --SHR
           --R1(from downto 0) & '0' when OP = "01110" else -- SHL
           --to_stdlogicvector(to_bitvector(R1) sll to_integer(R2)) when OP = "01110" else -- SHL
           
 tempFlag(0) <= '1' when tempOut = ZERO  -- Zero Flag
                else '0';
                
 tempFlag(1) <= '1' when (tempOut(15) = '1' and ((OP /= ADD_OPCODE) and (OP /= SUB_OPCODE))) or ((add_flag = '1' or sub_flag = '1')  and (OP = ADD_OPCODE or OP = SUB_OPCODE))
		else '0';    
                
 tempFlag(2) <= '0';

 tempFlag(3) <= '1' when (add_flag /= Add_out(15) and OP = ADD_OPCODE) or ( sub_flag /= Sub_out(15) and OP = SUB_OPCODE )  
		else '0';
 
 Flags <= tempFlag;
 ALUout <= tempOut;
 
End Behavior_TwoOperands;
