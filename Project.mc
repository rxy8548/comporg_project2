# Microcode for 350-20181-II ISA

#00 Memory Read and PC Adjust 1
#  MDR <-- M[PC]
#  PC <-- PC - 2
00:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Subt, ALU_PC, PCWrite,
     Seq;

#01 PC Adjust 2
#  PC <-- PC + 2
01:  PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
     Fetch;

