# Pipelined-Processor
[![GitHub license](https://img.shields.io/github/license/MichaelKMalak/Pipelined-Processor)](https://github.com/MichaelKMalak/Pipelined-Processor/blob/master/LICENSE)
<br>A simple 5-stage pipelined microprocessor with RISC-like instruction set architecture.

## Introduction
The processor in this project has a RISC-like instruction set architecture. There are eight 2-byte general purpose registers; R0, R1, R2, R3, R4, R5, R6, and R7. R7 works as program counter (PC). R6 works as a stack pointer (SP); and hence; points to the top of the stack. The initial value of SP is 1023. The memory address space is 1 KB of 16-bit width and is word addressable. ( N.B. word = 2 bytes)

When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that have already entered the pipeline), then the address of the next instruction (in PC) is saved on top of the stack, and PC is loaded from address 1 of the memory. To return from an interrupt, an RTI instruction loads PC from the top of stack, and the flow of the program resumes from the instruction after the interrupted instruction.

## ISA Specifications
### A) Registers

| Register | Details |
| --- | --- |
| R[0:7]<15:0> | Eight 16-bit general purpose registers |
| PC<15:0>:=R[7]<15:0> | 16-bit program counter |
| SP<15:0>:=R[6]<15:0> | 16-bit stack pointer |
| CCR<3:0> | condition code register |
| Z<0>:=CCR<0> | zero flag, change after arithmetic, logical, or shift operations |
| N<0>:=CCR<1> | negative flag, change after arithmetic, logical, or shift operations |
| C<0>:=CCR<2> | carry flag, change after arithmetic or shift operations. |
| V<0>:=CCR<3> | over flow, change after arithmetic or shift operations. |

### B) Input-Output

| Command  | Details |
| --- | --- |
| IN.PORT<15:0> | 16-bit data input port |
| OUT.PORT<15:0> | 16-bit data output port |
| INTR.IN<0> | a single, non-maskable interrupt |
| RESET.IN<0>|  reset signal |
| Rsrc | 1st operand register |
| Rdst | 2nd operand register and result register field|
| EA |  Effective address |
| Imm | Immediate Value (16 bit)|

### C) Commands

| Mnemonic  | Function |
| --- | --- |
| NOP| PC ← PC + 1 |
| MOV Rsrc, Rdst | Move value from register Rsrc to register Rdst|
| ADD Rsrc, Rdst | Add the values stored in registers Rsrc, Rdst <br> and store the result in Rdst <br> If the result =0 then Z ←1; else: Z ←0;<br>If the result <0 then N ←1; else: N ←0 |
| SUB Rsrc, Rdst | Subtract the values stored in registers Rsrc, Rdst<br> and store the result in Rdst<br> If the result =0 then Z ←1; else: Z ←0;<br> If the result <0 then N ←1; else: N ←0 |
| AND Rsrc, Rdst | AND the values stored in registers Rsrc, Rdst<br> and store the result in Rdst<br> If the result =0 then Z ←1; else: Z ←0;<br> If the result <0 then N ←1; else: N ←0 |
| OR Rsrc, Rdst | OR the values stored in registers Rsrc, Rdst<br> and store the result in Rdst<br> If the result =0 then Z ←1; else: Z ←0;<br> If the result <0 then N ←1; else: N ←0 |
| RLC Rdst | Rotate left Rdst ; C ←R[ Rdst ]<15>;<br> R[ Rdst ] ← R[ Rdst ]<14:0>&C |
| RRC Rdst | Rotate right Rdst ; C ←R[ Rdst ]<0>;<br> R[ Rdst ] ←C&R[ Rdst ]<15:1>; |
| SHL Rsrc, Imm, Rdst | Shift left Rsrc by #Imm bits and store result in Rdst<br> R[ Rdst ] ← R[ Rsrc]<(15-Imm):0>&0 |
| SHR Rsrc, Imm, Rdst | Shift right Rsrc by #Imm bits and store result in Rdst<br> R[ Rdst ] ← 0&R[ Rsrc ]<15:Imm> |
| SETC | C ←1 |
| CLRC |  C ←0 |
| PUSH Rdst |  X[SP--] ← R[ Rdst ]; |
| POP Rdst |  R[ Rdst ] ← X[++SP]; |
| OUT Rdst |  OUT.PORT ← R[ Rdst ] |
| IN Rdst |  R[ Rdst ] ←IN.PORT |
| NOT Rdst | NOT value stored in register Rdst<br> R[ Rdst ] ← 1’s Complement(R[ Rdst ]);<br> If (1’s Complement(R[ Rdst ]) = 0): Z ←1; else: Z ←0;<br> If (1’s Complement(R[ Rdst ]) < 0): N ←1; else: N ←0 |
| NEG Rdst | Negate the value stored in register Rdst<br> R[ Rdst ] ← 2’s Complement(R[ Rdst ]);<br> If (2’s Complement(R[ Rdst ]) = 0): Z ←1; else: Z ←0;<br> If (2’s Complement(R[ Rdst ]) < 0): N ←1; else: N ←0 |
| INC Rdst | Increment value stored in Rdst<br> R[ Rdst ] ←R[ Rdst ] + 1;<br> If ((R[ Rdst ] + 1) = 0): Z ←1; else: Z ←0;<br> If ((R[ Rdst ] + 1) < 0): N ←1; else: N ←0 |
| DEC Rdst | Decrement value stored in Rdst<br> R[ Rdst ] ←R[ Rdst ] – 1;<br> If ((R[ Rdst ] – 1) = 0): Z ←1; else: Z ←0;<br> If ((R[ Rdst ] – 1) < 0): N ←1; else: N ←0 |
| JZ Rdst | Jump if zero<br> If (Z=1): PC ←R[ Rdst ]; (Z=0) |
| JN Rdst | Jump if negative<br> If (N=1): PC ←R[ Rdst ]; (N=0) |
| JC Rdst | Jump if carry<br> If (C=1): PC ←R[ Rdst ]; (C=0): |
| JMP Rdst | Jump<br> PC ←R[ Rdst ] |
| CALL Rdst  | (X[SP--] ← PC + 1; PC ← R[ Rdst ]) |
| RET |  PC ← X[++SP] |
| RTI |  PC ← X[++SP]; Flags restored |
| LDM Rdst, Imm | Load immediate value to register Rdst<br> R[ Rdst ] ← Imm<15:0> |
| LDD Rdst, EA | Load value from memory address EA to register Rdst<br> R[ Rdst ] ← M[EA]; |
| STD Rsrc, EA | Store value in register Rsrc to memory location EA<br> M[EA] ←R[Rsrc]; |
| Reset | PC ← M[0] |
| Interrupt |  X[SP--]←PC;<br> PC ← M[1];<br> Flags preserved |

## Design
### Instructions
One instruction is 16 bits. In case of reading immediate value, we raise (i) bit and that allows us to read another 16-bit instruction as an immediate value, bypassing the first buffer between the fetching and the decoding stages.
![16 bit instructions](https://raw.githubusercontent.com/MichaelKMalak/Pipelined-Processor/master/Tables/16bit.PNG)

### Control Unit
Inputs: 5-bit Opcode – Interrupt input - Flags
Control signals/outputs are as follows
![opcodes](https://raw.githubusercontent.com/MichaelKMalak/Pipelined-Processor/master/Tables/Control%20Unit.PNG)

#### ALU Operation Codes
5 bits opcode is the ALUOP, and that allows the ALU to select what it wants.
![opcodes](https://raw.githubusercontent.com/MichaelKMalak/Pipelined-Processor/master/Tables/ALU%20operations.PNG)

#### Essential Multiplexers
##### Writeback Multiplexer (WB MUX)
![WB MUX](https://raw.githubusercontent.com/MichaelKMalak/Pipelined-Processor/master/Tables/Writeback%20Multiplexer.PNG)

##### Program Counter Multiplexer at fetching stage (PCMUX)
![PCMUX](https://github.com/MichaelKMalak/Pipelined-Processor/blob/master/Tables/Program%20Counter%20Multiplexer%20at%20fetching%20stage.PNG)

#### Stack Pointer Unit 
 The output is the stack pointer (SP) latest address that will be entered on memory unit as an address.
![SP](https://raw.githubusercontent.com/MichaelKMalak/Pipelined-Processor/master/Tables/Stack%20Pointer.PNG)

## Assumptions
*	IF/ID Buffer has an enable that deactivates when immediate_next is on. Immediate_next will be off.
*	Stall signal is an output of Hazard unit is the selection line of a MUX with control signals and zeros as an input. Stalling will nullify control signals from decoding phase (the bubble will propagate). 
*	INT signal is read at the decoding stage. Storing the PC and the flags; each takes half cycle (falling and rising edges).
*	In forwarding unit, for full forwarding it activates if(Mem/WD.Rd=ID/Ex.Rs) OR if(Ex/Mem.Rd = ID/Ex.Rs).
*	We always predict not taken.
*	Stack Pointer is initialized with 1032, while Program counter and memory pointer are initialized with zeros.
* If the operation doesn’t affect the ALU, and after it reads the opcode, no change in its output should occur. 
*	Decoding always takes the same three bits of both register source and destination. It’s up to the ALU to use whatever is needed.
*	Flags are updated in rising edge and read on falling edge
*	Instruction #1 and #8 are not allowed by the compiler.
