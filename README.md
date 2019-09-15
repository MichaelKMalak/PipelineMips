# Pipelined-Processor

A simple 5-stage pipelined microprocessor with RISC-like instruction set architecture.

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
| CCR<3:0>| condition code register |
| Z<0>:=CCR<0> | zero flag, change after arithmetic, logical, or shift operations |
| N<0>:=CCR<1> | negative flag, change after arithmetic, logical, or shift operations |
| C<0>:=CCR<2> | carry flag, change after arithmetic or shift operations. |
| V<0>:=CCR<3> | over flow, change after arithmetic or shift operations. |

### B) Input-Output

IN.PORT<15:0> ; 16-bit data input port
OUT.PORT<15:0> ; 16-bit data output port
INTR.IN<0> ; a single, non-maskable interrupt
RESET.IN<0> ; reset signal
1
Rsrc ; 1st operand register
Rdst ; 2nd operand register and result register field
EA ; Effective address
Imm ; Immediate Value (16 bit)
