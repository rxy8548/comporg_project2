# Microcode for 350-20181-II ISA

#00 Memory Read and PC Adjust 1
#  MDR <-- M[PC]
#  PC <-- PC + 2
00:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite, IRWrite,
     Seq;

#01 DispatchROM1 : Loads DispatchROM1
01:	DispatchROM1;

#02 Loads DispatchROM2 for long instructions
#  MDR <-- M[PC]
#  PC <-- PC + 2
#	DispatchROM2
02:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
     DispatchROM2;

#03 Clear : Clears AC : OPCODE 0
# AC <-- 0
03: ACWrite, Zero_AC,
	Fetch;

#04 Dec : Decrements AC by 1 : OPCODE 33
# AC <-- AC -1
04: ACWrite, ALU_AC, Subt,AC_ALUA,One_ALUB,
	Fetch;
	
#04 Dec : Decrements AC by 1 : OPCODE 33
# AC <-- AC -1
04: ACWrite, ALU_AC, Subt,AC_ALUA,One_ALUB,
	Fetch;
	
#05 Inc : increments AC by 1 : OPCODE 34
# AC <-- AC + 1
05: ACWrite, ALU_AC, Add,AC_ALUA,One_ALUB,
	Fetch;
	
#06 LoadCS : Loads CS into AC : OPCODE 27
# AC <-- CS
06: ACWrite, CS_AC,
	Fetch;
	
#07 LoadDS : Loads DS into AC : OPCODE 25
# AC <-- DS
07: ACWrite, DS_AC,
	Fetch;
	
#08 LoadSS : Loads SS into AC : OPCODE 19
# AC <-- SS
08: ACWrite, SS_AC,
	Fetch;
	
#09 StoreCS : Loads AC into CS : OPCODE 14
# CS <-- AC
09: CSWrite,
	Fetch;
	
#10 StoreDS : Loads AC into DS : OPCODE 13
# DS <-- AC
10: DSWrite,
	Fetch;
	
#11 StoreSS : Loads AC into SS : OPCODE 11
# SS <-- AC
11: SSWrite,
	Fetch;
	
#12 Jump Address :  : OPCODE 5
# PC <-- CS + Addr10
12: PCWrite, ALU_PC, Add, CS_ALUA, Address10_ALUB,
	Fetch;
	
#13 AddI Immediate : adds immediate to ac : OPCODE 28
# AC <-- AC + signext(imm10)
13: ACWrite, ALU_AC, Add, AC_ALUA, Imm10_ALUB,
	Fetch;
	
#14 Add Address : Adds an address to AC : OPCODE 32
# MAR <-- DS + Address10 
14: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;
	
# MDR <-- M[MAR]
15: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# AC <-- AC + MDR
16: ACWrite, AC_ALUA, MDR_ALUB, Add,
	Fetch;
	
#17 AddDec Address : : OPCODE 
# MAR <-- DS + Address10 
17: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
18: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- AC + MDR
19: ACWrite, AC_ALUA, MDR_ALUB, Add,
	Seq;

# MDR <-- MDR - 1
20: ALU_MDR, Subt, MDR_ALUA, One_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
21: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
		