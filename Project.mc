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
#######################################################
#45 Store Address : : OPCODE 15
# MAR <-- DS + Address10 
45: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# M[MAR] <-- AC
46: MemWrite, AC_Mem, MAR_MemAddress,
	Fetch;
#######################################################
#47 LoadIL Immediate : : OPCODE 21
# AC <-- 0  
47: Zero_AC, ACWrite,
	Seq;
##########################
#48 AddIL Immediate : : 26
# AC <-- AC + MDR (((Imm16)))
48: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Fetch;
#######################################################
#49 AddL Address16 : : OPCODE 22
# MDR <-- M[MAR]
49: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# AC <-- AC + MDR
50: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Fetch;
#######################################################
#51 Loads DispatchROM2 for long instructions
#  MAR <-- M[PC]
#  PC <-- PC + 2
#	DispatchROM2
51:  PC_MemAddress, MemRead, Mem_MAR, MARWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
     DispatchROM2;
#######################################################
#52 AddN Address : :OPCODE 20
# MAR <-- DS + Address10 
52: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
53: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MAR <-- MDR - 1
54: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
55: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# MDR <-- M[MAR]
56: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# AC <-- AC + MDR
57: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Fetch;
#######################################################
#58 AddNDec/Inc Address : : OPCODE 17/18
# MAR <-- DS + Address10 
58: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
59: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MAR <-- MDR - 1
60: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
61: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# MDR <-- M[MAR]
62: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# AC <-- AC + MDR
63: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Seq;

# MAR <-- DS + Address10 
64: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
65: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	DispatchROM2;
##############################	
# MDR <-- MDR - 2
66: ALU_MDR, Subt, MDR_ALUA, Two_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
67: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
##############################
# MDR <-- MDR + 2
68: ALU_MDR, Add, MDR_ALUA, Two_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
69: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
#######################################################
#70 StoreN Address : : OPCODE 12
# MAR <-- DS + Address10 
70: ALU_MAR, Add, DS_ALUA, Address10_ALUB, MARWrite,
	Seq;
	
# MDR <-- M[MAR]
71: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MAR <-- MDR - 1
72: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
73: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;
	
# M[MAR] <-- AC
74: MemWrite, AC_Mem, MAR_MemAddress,
	Fetch;
#######################################################
#75 Pop Address : : OPCODE 10
# MAR <-- SS + Address10 
75: ALU_MAR, Add, SS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
76: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MAR <-- MDR - 1
77: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
78: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# MDR <-- M[MAR]
79: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# AC <-- 0  
80: Zero_AC, ACWrite,
	Seq;
	
# AC <-- AC + MDR
81: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Seq;
############################## M[SS + Address10] <-- M[SS + Address10] + 2
# MAR <-- SS + Address10 
82: ALU_MAR, Add, SS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
83: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MDR <-- MDR + 2
84: ALU_MDR, Add, MDR_ALUA, Two_ALUB, MDRWrite,
	Seq;

# M[MAR] <-- MDR
85: MAR_MemAddress, MemWrite, MDR_Mem,
	Fetch;
#######################################################
#86 RetSub Address : : OPCODE 2
# MAR <-- SS + Address10 
86: ALU_MAR, Add, SS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
87: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;
	
# MAR <-- MDR - 1
88: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
89: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# MDR <-- M[MAR]
90: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# PC <-- MDR - 1  
91: Subt, PCWrite, ALU_PC, MDR_ALUA, One_ALUB,
	Seq;
	
# PC <-- PC + 1
92: ALU_PC, PCWrite, Add, PC_ALUA, One_ALUB,
	DispatchROM2;
#######################################################
#93 AddDisp Immediate, Address16 : : OPCODE 16
# AC <-- AC + signext(imm10)
93: ACWrite, ALU_AC, Add, AC_ALUA, Imm10_ALUB,
	Seq;
###########################	
#  MAR <-- M[PC]
#  PC <-- PC + 2
#	DispatchROM2
94: PC_MemAddress, MemRead, Mem_MAR, MARWrite,
    PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
    Seq;
	 
# MDR <-- M[MAR]
95: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MAR <-- MDR - 1
96: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
97: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# MDR <-- M[MAR]
98: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	DispatchROM2;
#####
# AC <-- AC + MDR
99: ALU_AC, ACWrite, AC_ALUA, MDR_ALUB,
	Fetch;
#######################################################
#100 JumpDisp Immediate, Address16 : : OPCODE 1
#PC <-- MDR + signext(imm10)
100: PCWrite, ALU_PC, Add, MDR_ALUA, Imm10_ALUB,
	 Fetch;
#######################################################
#101 Push Address : : OPCODE 9
# MAR <-- SS + Address10 
101: ALU_MAR, Add, SS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
102: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- MDR - 2
103: Subt, MDR_ALUA, Two_ALUB, MDRWrite, ALU_MDR,
	Seq;

# M[MAR] <-- MDR
104: MemWrite, MDR_Mem, 
	Seq;

# MAR <-- MDR - 1
105: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
106: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

# M[MAR] <-- AC
107: MemWrite, AC_Mem,
	Fetch;
#######################################################
#108 JumpSub Address, Address16 : : OPCODE 3
# MAR <-- SS + Address10 
108: ALU_MAR, Add, SS_ALUA, Address10_ALUB, MARWrite,
	Seq;

# MDR <-- M[MAR]
109: MAR_MemAddress, MemRead, MDRWrite, Mem_MDR,
	Seq;

# MDR <-- MDR - 2
110: Subt, MDR_ALUA, Two_ALUB, MDRWrite, ALU_MDR,
	Seq;

# M[MAR] <-- MDR
111: MemWrite, MDR_Mem, 
	Seq;

# MAR <-- MDR - 1
112: Subt, MARWrite, ALU_MAR, MDR_ALUA, One_ALUB,
	Seq;
	
# MAR <-- MAR + 1
113: ALU_MAR, MARWrite, Add, MAR_ALUA, One_ALUB,
	Seq;

#  MDR <-- M[PC]
#  PC <-- PC + 2
114: PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
	 PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
    Seq;
	 
# M[MAR} <-- PC
115: PC_Mem, MemWrite, MAR_MemAddress,
	Seq;

# PC <-- MDR - 1  
116: Subt, PCWrite, ALU_PC, MDR_ALUA, One_ALUB,
	Seq;
	
# PC <-- PC + 1
117: ALU_PC, PCWrite, Add, PC_ALUA, One_ALUB,
	Fetch;
