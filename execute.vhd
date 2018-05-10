-- Don't forget to propagate control signals AND other signals like immediate value
-- NOT TESTED UNIT TEST YET!!!!
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ex_pkg.all;
use work.common_pkg.all;

entity instruction_executor is
    port ( clk : std_logic;
	   rst: std_logic;
	ex_d : in  ex_in;
          ex_q : out ex_out
);
end entity instruction_executor;

architecture Behavior of instruction_executor is

component ALUmain is
  Port( R1, R2 : in word; 
      OP : in opcode;
	flagsIn : in ALUflags; 
      ALUout:out word; 
      Flags_Out : out ALUflags);
End component ALUmain;

component ccr_register is
  generic (n:integer :=4);
  port(clk, rst, we : in std_logic;
        d: in std_logic_vector(n-1 downto 0);
        q: out std_logic_vector(n-1 downto 0)
        );
end component;
    signal MUX3Out        : word;
    signal MUX2Out        : word;
    signal MUX1Out        : word;
    signal ALUccrOut      : ALUflags;
    signal ALUccrIn       : ALUflags;
    signal flagsInCCR     : ALUflags;
    signal CCRenable	  : std_logic;
begin -- architecture Behavior
ex_q.Flags<=ALUccrOut;

MUX1Out <= ex_d.MemDataFU when ex_d.FWDA="01" else
	   ex_d.AluDataFU when ex_d.FWDA="10" else
           ex_d.operand1 when ex_d.FWDA="00" else
	   X"0000" when ex_d.FWDA="11";

MUX2Out <= ex_d.MemDataFU when ex_d.FWDB="01" else
	   ex_d.AluDataFU when ex_d.FWDB="10" else
           MUX3Out when ex_d.FWDB="00" else
	   X"0000" when ex_d.FWDB="11";

MUX3Out <= ex_d.operand2 when ex_d.ALUimm='0' else
	   ex_d.immediate when ex_d.ALUimm='1';
   
flagsInCCR<= ex_d.restoredFlags when ex_d.wbFlags='1' else
		ALUccrOut;

CCRenable<='0' when ((ALUccrOut(0)='X' or ALUccrOut(1)='X' or ALUccrOut(2)='X' or ALUccrOut(3)='X') and (ex_d.wbFlags/='1')) else
		    '1';

aluBlock: ALUmain port map(MUX2Out, MUX1Out, ex_d.ALUop, ALUccrIn , ex_q.AluOutput, ALUccrOut);
CCR: ccr_register generic map(n=>4) port map (clk,rst, we=>CCRenable, d=>flagsInCCR,q=>ALUccrIn);  

end architecture Behavior;