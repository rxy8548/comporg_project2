# Microcode for 350-20181-II ISA
#######################################################
#00 Memory Read and PC Adjust 1
#  MDR <-- M[PC]
#  PC <-- PC + 2
00:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite, IRWrite,
     Seq;
#######################################################
#01 DispatchROM1 : Loads DispatchROM1
01:	DispatchROM1;
#######################################################
#02 Loads DispatchROM2 for long instructions
#  MDR <-- M[PC]
#  PC <-- PC + 2
#	DispatchROM2
02:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
     DispatchROM2;
#######################################################
#03 Clear : Clears AC : OPCODE 0
# AC <-- 0
03: ACWrite, Zero_AC,
	Fetch;
#######################################################
#04 Dec : Decrements AC by 1 : OPCODE 33
# AC <-- AC -1
#04: ACWrite, ALU_AC, Subt,AC_ALUA,One_ALUB,
#	Fetch;
#######################################################	
#04 Dec : Decrements AC by 1 : OPCODE 33
# AC <-- AC -1
04: ACWrite, ALU_AC, Subt,AC_ALUA,One_ALUB,
	Fetch;
#######################################################	
#05 Inc : increments AC by 1 : OPCODE 34
# AC <-- AC + 1
05: ACWrite, ALU_AC, Add,AC_ALUA,One_ALUB,
	Fetch;
#######################################################	
#06 LoadCS : Loads CS into AC : OPCODE 27
# AC <-- CS
06: ACWrite, CS_AC,
	Fetch;
#######################################################	
#07 LoadDS : Loads DS into AC : OPCODE 25
# AC <-- DS
07: ACWrite, DS_AC,
	Fetch;
#######################################################	
#08 LoadSS : Loads SS into AC : OPCODE 19
# AC <-- SS
08: ACWrite, SS_AC,
	Fetch;
#######################################################	
#09 StoreCS : Loads AC into CS : OPCODE 14
# CS <-- AC
09: CSWrite,
	Fetch;
#######################################################	
#10 StoreDS : Loads AC into DS : OPCODE 13
# DS <-- AC
10: DSWrite,
	Fetch;
#######################################################	
#11 StoreSS : Loads AC into SS : OPCODE 11
# SS <-- AC
11: SSWrite,
	Fetch;
#######################################################	
#12 Jump Address :  : OPCODE 5
# PC <-- CS + Addr10
12: PCWrite, ALU_PC, Add, CS_ALUA, Address10_ALUB,
	Fetch;
#######################################################	
#13 AddI Immediate : adds immediate to ac : OPCODE 28
# AC <-- AC + signext(imm10)
13: ACWrite, ALU_AC, Add, AC_ALUA, Imm10_ALUB,
	Fetch;
#######################################################	
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
#######################################################	
#17 AddDec Address : : OPCODE 23
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
#######################################################	
#22 AddInc Address : : OPCODE 24
# MAR <-- DS + Address10 
22: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
23: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- AC + MDR
24: ACWrite, AC_ALUA, MDR_ALUB, Add,
	Seq;

# MDR <-- MDR + 1
25: ALU_MDR, Add, MDR_ALUA, One_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
26: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
#######################################################
#27 BrNeg Offset : : OPCODE 8
# (AC < 0)PC <-- PC + 2 + (SignExt(Offset10)*2) 
27: PCWriteCondN, ALU_PC, Add, PC_ALUA, Offset10_ALUB, 
	Fetch;
#######################################################	
#28 BrPos Offset : : OPCODE 6
# (AC > 0)PC <-- PC + 2 + (SignExt(Offset10)*2) 
28: PCWriteCondP, ALU_PC, Add, PC_ALUA, Offset10_ALUB, 
	Fetch;
#######################################################
#29 BrZ Offset : : OPCODE 7
# (AC = 0)PC <-- PC + 2 + (SignExt(Offset10)*2) 
29: PCWriteCondZ, ALU_PC, Add, PC_ALUA, Offset10_ALUB, 
	Fetch;
#######################################################	
#30 IncM Address : : OPCODE 30
# MAR <-- DS + Address10 
30: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
31: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- MDR + 1
32: ALU_MDR, Add, MDR_ALUA, One_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
33: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
#######################################################
#34 DecM Address : : OPCODE 29
# MAR <-- DS + Address10 
34: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
35: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- MDR - 1
36: ALU_MDR, Subt, MDR_ALUA, One_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
37: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
#######################################################
#38 JumpN Address : : OPCODE 4
# MAR <-- DS + Address10 
38: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# PC <-- M[MAR]
39: MAR_MemAddress, MemRead, PCWrite, Mem_PC,
	Fetch;
#######################################################
#40 Load : : OPCODE 35
# MAR <-- DS + Address10 
40: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# AC <-- M[MAR]
41: MAR_MemAddress, MemRead, ACWrite, Mem_AC,
	Fetch;
#######################################################
#42 Subt : : OPCODE 31
# MAR <-- DS + Address10 
42: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
43: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# AC <-- AC - MDR
44: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB, Subt,
	Fetch;
