
;CodeVisionAVR C Compiler V3.52 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x5E:
	.DB  0x34,0x2,0x9B,0x3,0x22,0x2,0x6F,0x0
	.DB  0xF7,0x1,0xF8,0x1,0x41,0x6C,0x69,0x63
	.DB  0x65,0x0,0x52,0x6F,0x62,0x72,0x74,0x0
	.DB  0x43,0x68,0x61,0x72,0x6C,0x0
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x49,0x44,0x20,0x3A,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x59
	.DB  0x6F,0x75,0x72,0x20,0x50,0x43,0x20,0x3A
	.DB  0x20,0x0,0x53,0x6F,0x72,0x72,0x79,0x20
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x50,0x43
	.DB  0x0,0x57,0x72,0x6F,0x6E,0x67,0x20,0x49
	.DB  0x44,0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D
	.DB  0x65,0x2C,0x20,0x0,0x25,0x63,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x75,0x73,0x65
	.DB  0x72,0x20,0x49,0x44,0x3A,0x20,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x6E,0x65,0x77
	.DB  0x20,0x50,0x43,0x3A,0x20,0x0,0x52,0x65
	.DB  0x6E,0x74,0x65,0x72,0x20,0x6E,0x65,0x77
	.DB  0x20,0x50,0x43,0x3A,0x20,0x0,0x43,0x6F
	.DB  0x6E,0x74,0x61,0x63,0x74,0x20,0x41,0x64
	.DB  0x6D,0x69,0x6E,0x0,0x4E,0x65,0x77,0x20
	.DB  0x50,0x61,0x73,0x73,0x43,0x6F,0x64,0x65
	.DB  0x20,0x73,0x61,0x76,0x65,0x64,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x75,0x73,0x65
	.DB  0x72,0x20,0x50,0x43,0x3A,0x20,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x41,0x64,0x6D
	.DB  0x69,0x6E,0x20,0x50,0x43,0x3A,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void userEnter();
;int checkUserID(const char ID[3]);
;_Bool checkPassCode(const char PC[3], int address);
;void AdminEdit();
;void UserEdit();
;void getName(int address);
;void storeNewPC(const char newPC[3], int address);
;void rawData();
;void readData();
;unsigned char EE_Read(unsigned int address);
;void EE_Write(unsigned int address, unsigned char data);
;void motor();
;void Buzz();
;char keypad();
;void main(void)
; 0000 001D {

	.CSEG
_main:
; .FSTART _main
; 0000 001E //LCD
; 0000 001F DDRC = 0b00000111;
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 0020 PORTC = 0b11111000;
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 0021 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0022 
; 0000 0023 //Push-Down button Interrupt
; 0000 0024 DDRD.2 = 0;
	CBI  0x11,2
; 0000 0025 DDRD.3 = 0;
	CBI  0x11,3
; 0000 0026 PORTD.2 = 1;
	SBI  0x12,2
; 0000 0027 PORTD.3 = 1;
	SBI  0x12,3
; 0000 0028 
; 0000 0029 //SOUNDER
; 0000 002A DDRD.5 = 1;
	SBI  0x11,5
; 0000 002B 
; 0000 002C //Interrupt
; 0000 002D GICR |= (1 << INT0);                 // Enable INT0
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 002E GICR |= (1 << INT1);                // Enable INT1
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 002F 
; 0000 0030 MCUCR |= (1 << ISC01) | (1 << ISC00); // Trigger INT0 on rising edge
	IN   R30,0x35
	ORI  R30,LOW(0x3)
	OUT  0x35,R30
; 0000 0031 MCUCR |= (1 << ISC11) | (1 << ISC10); // Trigger INT1 on rising edge
	IN   R30,0x35
	ORI  R30,LOW(0xC)
	OUT  0x35,R30
; 0000 0032 
; 0000 0033 SREG.7 = 1; // Enable global interrupts
	BSET 7
; 0000 0034 
; 0000 0035 
; 0000 0036 //Motor
; 0000 0037 DDRD.0 = 1;
	SBI  0x11,0
; 0000 0038 DDRD.1 = 1;
	SBI  0x11,1
; 0000 0039 
; 0000 003A rawData(); // Call rawData once to store data in EEPROM
	RCALL _rawData
; 0000 003B 
; 0000 003C while (1)
_0x11:
; 0000 003D {
; 0000 003E char number = keypad();
; 0000 003F lcd_clear();
	SBIW R28,1
;	number -> Y+0
	RCALL _keypad
	ST   Y,R30
	RCALL _lcd_clear
; 0000 0040 
; 0000 0041 if (number == '*')
	LD   R26,Y
	CPI  R26,LOW(0x2A)
	BRNE _0x14
; 0000 0042 {
; 0000 0043 userEnter();
	RCALL _userEnter
; 0000 0044 }
; 0000 0045 }
_0x14:
	ADIW R28,1
	RJMP _0x11
; 0000 0046 }
_0x15:
	RJMP _0x15
; .FEND
;void userEnter()
; 0000 0049 {
_userEnter:
; .FSTART _userEnter
; 0000 004A char ID[3];
; 0000 004B char PC[3];
; 0000 004C int IdAddres;
; 0000 004D bool pcCode;
; 0000 004E int i;
; 0000 004F 
; 0000 0050 lcd_clear();
	SBIW R28,6
	RCALL __SAVELOCR6
;	ID -> Y+9
;	PC -> Y+6
;	IdAddres -> R16,R17
;	pcCode -> R19
;	i -> R20,R21
	RCALL _lcd_clear
; 0000 0051 lcd_printf("Enter your ID : ");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x0
; 0000 0052 for (i = 0; i < 3; i++)
_0x17:
	__CPWRN 20,21,3
	BRGE _0x18
; 0000 0053 {
; 0000 0054 ID[i] = keypad();
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,9
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0055 lcd_putchar(ID[i]);
	MOVW R26,R28
	ADIW R26,9
	RCALL SUBOPT_0x1
; 0000 0056 }
	__ADDWRN 20,21,1
	RJMP _0x17
_0x18:
; 0000 0057 
; 0000 0058 // Check EEPROM for ID
; 0000 0059 IdAddres = checkUserID(ID);
	MOVW R26,R28
	ADIW R26,9
	RCALL SUBOPT_0x2
; 0000 005A if (IdAddres)
	BREQ _0x19
; 0000 005B {
; 0000 005C lcd_clear();
	RCALL _lcd_clear
; 0000 005D lcd_printf("Enter Your PC : ");
	__POINTW1FN _0x0,17
	RCALL SUBOPT_0x0
; 0000 005E 
; 0000 005F for (i = 0; i < 3; i++)
_0x1B:
	__CPWRN 20,21,3
	BRGE _0x1C
; 0000 0060 {
; 0000 0061 PC[i] = keypad();
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0062 lcd_putchar(PC[i]);
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x1
; 0000 0063 }
	__ADDWRN 20,21,1
	RJMP _0x1B
_0x1C:
; 0000 0064 pcCode = checkPassCode(PC, IdAddres);
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x3
	MOV  R19,R30
; 0000 0065 if(!pcCode)
	CPI  R19,0
	BRNE _0x1D
; 0000 0066 {
; 0000 0067 lcd_clear();
	RCALL _lcd_clear
; 0000 0068 lcd_printf("Sorry Wrong PC");   //1 peep
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x4
; 0000 0069 Buzz();
; 0000 006A }
; 0000 006B else
	RJMP _0x1E
_0x1D:
; 0000 006C {
; 0000 006D lcd_clear();
	RCALL _lcd_clear
; 0000 006E getName(IdAddres);
	MOVW R26,R16
	RCALL _getName
; 0000 006F motor();
	RCALL _motor
; 0000 0070 }
_0x1E:
; 0000 0071 }
; 0000 0072 else{
	RJMP _0x1F
_0x19:
; 0000 0073 lcd_clear();
	RCALL _lcd_clear
; 0000 0074 lcd_printf("Wrong ID");    // 2 peep
	__POINTW1FN _0x0,49
	RCALL SUBOPT_0x4
; 0000 0075 Buzz();
; 0000 0076 Buzz();
	RCALL _Buzz
; 0000 0077 }
_0x1F:
; 0000 0078 
; 0000 0079 }
	RJMP _0x20C0007
; .FEND
;int checkUserID(const char ID[3]){
; 0000 007B int checkUserID(const char ID[3]){
_checkUserID:
; .FSTART _checkUserID
; 0000 007C int eeprom_address = 6;
; 0000 007D char eeprom_ID;
; 0000 007E int found = 0;
; 0000 007F int i;
; 0000 0080 int j;
; 0000 0081 for (i = 0; i < 3; i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	RCALL __SAVELOCR6
;	ID -> Y+10
;	eeprom_address -> R16,R17
;	eeprom_ID -> R19
;	found -> R20,R21
;	i -> Y+8
;	j -> Y+6
	__GETWRN 16,17,6
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x21:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,3
	BRGE _0x22
; 0000 0082 {
; 0000 0083 eeprom_address = 6 + i * 14;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	RCALL __MULW12
	ADIW R30,6
	MOVW R16,R30
; 0000 0084 for (j = 0; j < 3; j++)
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x24:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,3
	BRGE _0x25
; 0000 0085 {
; 0000 0086 EEPROM_WAIT;  // Wait till EEPROM is ready
_0x26:
	SBIC 0x1C,1
	RJMP _0x26
; 0000 0087 eeprom_ID = EE_Read(eeprom_address) + '0';
	MOVW R26,R16
	RCALL _EE_Read
	SUBI R30,-LOW(48)
	MOV  R19,R30
; 0000 0088 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0089 if (eeprom_ID == ID[j])
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CP   R30,R19
	BRNE _0x29
; 0000 008A {
; 0000 008B found += 1; // Increment the count when a match is found
	__ADDWRN 20,21,1
; 0000 008C }
; 0000 008D eeprom_address++;
_0x29:
	__ADDWRN 16,17,1
; 0000 008E }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x24
_0x25:
; 0000 008F if (found == 3)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x2A
; 0000 0090 return eeprom_address + 1 ; else
	MOVW R30,R16
	ADIW R30,1
	RJMP _0x20C0007
_0x2A:
; 0000 0091 {
; 0000 0092 found = 0; // Reset the count for the next iteration
	__GETWRN 20,21,0
; 0000 0093 }
; 0000 0094 }
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x21
_0x22:
; 0000 0095 return false;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20C0007:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; 0000 0096 }
; .FEND
;_Bool checkPassCode(const char PC[3], int address){
; 0000 0098 _Bool checkPassCode(const char PC[3], int address){
_checkPassCode:
; .FSTART _checkPassCode
; 0000 0099 char eeprom_PC;
; 0000 009A int i;
; 0000 009B 
; 0000 009C for (i = 0; i < 3; i++)
	RCALL __SAVELOCR6
	MOVW R20,R26
;	PC -> Y+6
;	address -> R20,R21
;	eeprom_PC -> R17
;	i -> R18,R19
	__GETWRN 18,19,0
_0x2D:
	__CPWRN 18,19,3
	BRGE _0x2E
; 0000 009D {
; 0000 009E EEPROM_WAIT;  // Wait till EEPROM is ready
_0x2F:
	SBIC 0x1C,1
	RJMP _0x2F
; 0000 009F eeprom_PC = EE_Read(address) + '0';  // Convert digit to character
	MOVW R26,R20
	RCALL _EE_Read
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 00A0 if (eeprom_PC != PC[i])
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	CP   R30,R17
	BREQ _0x32
; 0000 00A1 {
; 0000 00A2 return false; // PC does not match, return false
	LDI  R30,LOW(0)
	RJMP _0x20C0006
; 0000 00A3 }
; 0000 00A4 address++;
_0x32:
	__ADDWRN 20,21,1
; 0000 00A5 }
	__ADDWRN 18,19,1
	RJMP _0x2D
_0x2E:
; 0000 00A6 
; 0000 00A7 return true; // PC matches, return true
	LDI  R30,LOW(1)
_0x20C0006:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 00A8 }
; .FEND
;void getName(int address){
; 0000 00AA void getName(int address){
_getName:
; .FSTART _getName
; 0000 00AB int i;
; 0000 00AC char name;
; 0000 00AD address = address-10;
	RCALL __SAVELOCR6
	MOVW R20,R26
;	address -> R20,R21
;	i -> R16,R17
;	name -> R19
	__SUBWRN 20,21,10
; 0000 00AE lcd_printf("Welcome, ");
	__POINTW1FN _0x0,58
	RCALL SUBOPT_0x5
; 0000 00AF for( i=0; i<5 ;i++)
	__GETWRN 16,17,0
_0x34:
	__CPWRN 16,17,5
	BRGE _0x35
; 0000 00B0 {
; 0000 00B1 name = EE_Read(address);
	MOVW R26,R20
	RCALL _EE_Read
	MOV  R19,R30
; 0000 00B2 lcd_printf("%c",name);
	__POINTW1FN _0x0,68
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
; 0000 00B3 address++;
	__ADDWRN 20,21,1
; 0000 00B4 }
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
; 0000 00B5 }
	RCALL __LOADLOCR6
	RJMP _0x20C0003
; .FEND
;void AdminEdit()
; 0000 00B8 {
_AdminEdit:
; .FSTART _AdminEdit
; 0000 00B9 char userID[3];
; 0000 00BA char newUserPC[3];
; 0000 00BB char confirmPC[3];
; 0000 00BC int userIdAddres;
; 0000 00BD int i;
; 0000 00BE 
; 0000 00BF lcd_clear();
	RCALL SUBOPT_0x6
;	userID -> Y+10
;	newUserPC -> Y+7
;	confirmPC -> Y+4
;	userIdAddres -> R16,R17
;	i -> R18,R19
; 0000 00C0 lcd_printf("Enter user ID: ");
; 0000 00C1 
; 0000 00C2 for (i = 0; i < 3; i++) {
	__GETWRN 18,19,0
_0x37:
	__CPWRN 18,19,3
	BRGE _0x38
; 0000 00C3 userID[i] = keypad();
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
; 0000 00C4 lcd_putchar(userID[i]);
; 0000 00C5 }
	__ADDWRN 18,19,1
	RJMP _0x37
_0x38:
; 0000 00C6 
; 0000 00C7 userIdAddres = checkUserID(userID);
	MOVW R26,R28
	ADIW R26,10
	RCALL SUBOPT_0x2
; 0000 00C8 
; 0000 00C9 if (userIdAddres) {
	BREQ _0x39
; 0000 00CA lcd_clear();
	RCALL SUBOPT_0x9
; 0000 00CB lcd_printf("Enter new PC: ");
; 0000 00CC 
; 0000 00CD for (i = 0; i < 3; i++) {
	__GETWRN 18,19,0
_0x3B:
	__CPWRN 18,19,3
	BRGE _0x3C
; 0000 00CE newUserPC[i] = keypad();
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
; 0000 00CF lcd_putchar(newUserPC[i]);
; 0000 00D0 }
	__ADDWRN 18,19,1
	RJMP _0x3B
_0x3C:
; 0000 00D1 
; 0000 00D2 lcd_clear();
	RCALL SUBOPT_0xC
; 0000 00D3 lcd_printf("Renter new PC: ");
; 0000 00D4 
; 0000 00D5 for (i=0;i<3;i++)
	__GETWRN 18,19,0
_0x3E:
	__CPWRN 18,19,3
	BRGE _0x3F
; 0000 00D6 {
; 0000 00D7 confirmPC[i] = keypad();
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
; 0000 00D8 lcd_putchar(newUserPC[i]);
; 0000 00D9 }
	__ADDWRN 18,19,1
	RJMP _0x3E
_0x3F:
; 0000 00DA 
; 0000 00DB for (i=0;i<3;i++)
	__GETWRN 18,19,0
_0x41:
	__CPWRN 18,19,3
	BRGE _0x42
; 0000 00DC {
; 0000 00DD if(confirmPC[i] != newUserPC[i])
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	BREQ _0x43
; 0000 00DE {
; 0000 00DF lcd_clear();
	RCALL SUBOPT_0x10
; 0000 00E0 lcd_printf("Contact Admin");
; 0000 00E1 Buzz();
; 0000 00E2 Buzz();
	RCALL _Buzz
; 0000 00E3 return;
	RJMP _0x20C0004
; 0000 00E4 }
; 0000 00E5 }
_0x43:
	__ADDWRN 18,19,1
	RJMP _0x41
_0x42:
; 0000 00E6 lcd_clear();
	RCALL SUBOPT_0x11
; 0000 00E7 lcd_printf("New PassCode saved");
; 0000 00E8 delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 00E9 storeNewPC( newUserPC,userIdAddres);
; 0000 00EA 
; 0000 00EB } else {
	RJMP _0x44
_0x39:
; 0000 00EC lcd_clear();
	RCALL SUBOPT_0x13
; 0000 00ED lcd_printf("Contact Admin");
; 0000 00EE delay_ms(100);
	RCALL SUBOPT_0x14
; 0000 00EF Buzz();
; 0000 00F0 Buzz();
; 0000 00F1 }
_0x44:
; 0000 00F2 
; 0000 00F3 lcd_clear(); // Clear the LCD after the loop
	RJMP _0x20C0005
; 0000 00F4 
; 0000 00F5 }
; .FEND
;void UserEdit() {
; 0000 00F7 void UserEdit() {
_UserEdit:
; .FSTART _UserEdit
; 0000 00F8 char userID[3];
; 0000 00F9 char newUserPC[3];
; 0000 00FA char confirmPC[3];
; 0000 00FB int userIdAddres;
; 0000 00FC int i;
; 0000 00FD 
; 0000 00FE lcd_clear();
	RCALL SUBOPT_0x6
;	userID -> Y+10
;	newUserPC -> Y+7
;	confirmPC -> Y+4
;	userIdAddres -> R16,R17
;	i -> R18,R19
; 0000 00FF lcd_printf("Enter user ID: ");
; 0000 0100 
; 0000 0101 for (i = 0; i < 3; i++) {
	__GETWRN 18,19,0
_0x46:
	__CPWRN 18,19,3
	BRGE _0x47
; 0000 0102 userID[i] = keypad();
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0x8
; 0000 0103 lcd_putchar(userID[i]);
; 0000 0104 }
	__ADDWRN 18,19,1
	RJMP _0x46
_0x47:
; 0000 0105 
; 0000 0106 userIdAddres = checkUserID(userID);
	MOVW R26,R28
	ADIW R26,10
	RCALL SUBOPT_0x2
; 0000 0107 
; 0000 0108 if (userIdAddres) {
	BRNE PC+2
	RJMP _0x48
; 0000 0109 lcd_clear();
	RCALL _lcd_clear
; 0000 010A lcd_printf("Enter user PC: ");
	__POINTW1FN _0x0,151
	RCALL SUBOPT_0x5
; 0000 010B 
; 0000 010C for (i = 0; i < 3; i++) {
	__GETWRN 18,19,0
_0x4A:
	__CPWRN 18,19,3
	BRGE _0x4B
; 0000 010D newUserPC[i] = keypad();
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
; 0000 010E lcd_putchar(newUserPC[i]);
; 0000 010F }
	__ADDWRN 18,19,1
	RJMP _0x4A
_0x4B:
; 0000 0110 if(!(checkPassCode(newUserPC , userIdAddres)))
	MOVW R30,R28
	ADIW R30,7
	RCALL SUBOPT_0x3
	CPI  R30,0
	BRNE _0x4C
; 0000 0111 {
; 0000 0112 lcd_clear();
	RCALL SUBOPT_0x10
; 0000 0113 lcd_printf("Contact Admin");
; 0000 0114 Buzz();
; 0000 0115 Buzz();
	RCALL _Buzz
; 0000 0116 return;
	RJMP _0x20C0004
; 0000 0117 }
; 0000 0118 lcd_clear();
_0x4C:
	RCALL SUBOPT_0x9
; 0000 0119 lcd_printf("Enter new PC: ");
; 0000 011A 
; 0000 011B for (i = 0; i < 3; i++) {
	__GETWRN 18,19,0
_0x4E:
	__CPWRN 18,19,3
	BRGE _0x4F
; 0000 011C newUserPC[i] = keypad();
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
; 0000 011D lcd_putchar(newUserPC[i]);
; 0000 011E }
	__ADDWRN 18,19,1
	RJMP _0x4E
_0x4F:
; 0000 011F 
; 0000 0120 lcd_clear();
	RCALL SUBOPT_0xC
; 0000 0121 lcd_printf("Renter new PC: ");
; 0000 0122 
; 0000 0123 for (i=0;i<3;i++)
	__GETWRN 18,19,0
_0x51:
	__CPWRN 18,19,3
	BRGE _0x52
; 0000 0124 {
; 0000 0125 confirmPC[i] = keypad();
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0126 lcd_putchar(confirmPC[i]);
	RCALL SUBOPT_0xE
	LD   R26,X
	RCALL _lcd_putchar
; 0000 0127 }
	__ADDWRN 18,19,1
	RJMP _0x51
_0x52:
; 0000 0128 
; 0000 0129 for (i=0;i<3;i++)
	__GETWRN 18,19,0
_0x54:
	__CPWRN 18,19,3
	BRGE _0x55
; 0000 012A {
; 0000 012B if(confirmPC[i] != newUserPC[i])
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	BREQ _0x56
; 0000 012C {
; 0000 012D lcd_clear();
	RCALL SUBOPT_0x10
; 0000 012E lcd_printf("Contact Admin");
; 0000 012F Buzz();
; 0000 0130 Buzz();
	RCALL _Buzz
; 0000 0131 return;
	RJMP _0x20C0004
; 0000 0132 }
; 0000 0133 }
_0x56:
	__ADDWRN 18,19,1
	RJMP _0x54
_0x55:
; 0000 0134 lcd_clear();
	RCALL SUBOPT_0x11
; 0000 0135 lcd_printf("New PassCode saved");
; 0000 0136 delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 0137 storeNewPC( newUserPC,userIdAddres);
; 0000 0138 
; 0000 0139 } else {
	RJMP _0x57
_0x48:
; 0000 013A lcd_clear();
	RCALL SUBOPT_0x13
; 0000 013B lcd_printf("Contact Admin");
; 0000 013C delay_ms(100);
	RCALL SUBOPT_0x14
; 0000 013D Buzz();
; 0000 013E Buzz();
; 0000 013F }
_0x57:
; 0000 0140 
; 0000 0141 
; 0000 0142 lcd_clear(); // Clear the LCD after the loop
_0x20C0005:
	RCALL _lcd_clear
; 0000 0143 }
_0x20C0004:
	RCALL __LOADLOCR4
	ADIW R28,13
	RET
; .FEND
;void storeNewPC(const char newPC[3], int address){
; 0000 0145 void storeNewPC(const char newPC[3], int address){
_storeNewPC:
; .FSTART _storeNewPC
; 0000 0146 int eeprom_address = address;
; 0000 0147 int i;
; 0000 0148 int digit;
; 0000 0149 
; 0000 014A for (i = 0; i < 3; i++)
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR6
;	newPC -> Y+8
;	address -> Y+6
;	eeprom_address -> R16,R17
;	i -> R18,R19
;	digit -> R20,R21
	__GETWRS 16,17,6
	__GETWRN 18,19,0
_0x59:
	__CPWRN 18,19,3
	BRGE _0x5A
; 0000 014B {
; 0000 014C EEPROM_WAIT;  // Wait till EEPROM is ready
_0x5B:
	SBIC 0x1C,1
	RJMP _0x5B
; 0000 014D delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 014E 
; 0000 014F // Convert character to integer
; 0000 0150 digit = newPC[i] - '0';
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	MOVW R20,R30
; 0000 0151 
; 0000 0152 // Print debugging information
; 0000 0153 lcd_clear();
	RCALL _lcd_clear
; 0000 0154 //lcd_printf("Writing %d to %d", digit, eeprom_address);
; 0000 0155 //delay_ms(1000);
; 0000 0156 
; 0000 0157 EE_Write(eeprom_address, digit);
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R20
	RCALL _EE_Write
; 0000 0158 eeprom_address++;
	__ADDWRN 16,17,1
; 0000 0159 }
	__ADDWRN 18,19,1
	RJMP _0x59
_0x5A:
; 0000 015A }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;void rawData()
; 0000 015D {
_rawData:
; .FSTART _rawData
; 0000 015E char user_names[][6] = {"Alice", "Robrt", "Charl"};
; 0000 015F short user_ids[] = {111, 503, 504};
; 0000 0160 short user_passwords[] = {564, 923, 546};
; 0000 0161 int userIndex;
; 0000 0162 int i;
; 0000 0163 int eeprom_address = 0; // Starting EEPROM address for sequential reading
; 0000 0164 
; 0000 0165 for (userIndex = 0; userIndex < sizeof(user_ids) / sizeof(user_ids[0]); userIndex++)
	SBIW R28,30
	LDI  R24,30
	__GETWRN 22,23,0
	LDI  R30,LOW(_0x5E*2)
	LDI  R31,HIGH(_0x5E*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	user_names -> Y+18
;	user_ids -> Y+12
;	user_passwords -> Y+6
;	userIndex -> R16,R17
;	i -> R18,R19
;	eeprom_address -> R20,R21
	__GETWRN 20,21,0
	__GETWRN 16,17,0
_0x60:
	__CPWRN 16,17,3
	BRGE _0x61
; 0000 0166 {
; 0000 0167 // Write User Name to EEPROM (fixed length)
; 0000 0168 for (i = 0; i < 5; ++i)
	__GETWRN 18,19,0
_0x63:
	__CPWRN 18,19,5
	BRGE _0x64
; 0000 0169 {
; 0000 016A EE_Write(eeprom_address, user_names[userIndex][i]);
	ST   -Y,R21
	ST   -Y,R20
	__MULBNWRU 16,17,6
	MOVW R26,R28
	ADIW R26,20
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R18
	ADC  R31,R19
	LD   R26,Z
	RCALL _EE_Write
; 0000 016B eeprom_address++;
	__ADDWRN 20,21,1
; 0000 016C }
	__ADDWRN 18,19,1
	RJMP _0x63
_0x64:
; 0000 016D 
; 0000 016E // Delimiter between user name and ID
; 0000 016F EE_Write(eeprom_address, DELIMITER);
	RCALL SUBOPT_0x15
; 0000 0170 eeprom_address++;
; 0000 0171 
; 0000 0172 // Write User ID (3 digits) to EEPROM
; 0000 0173 EE_Write(eeprom_address, user_ids[userIndex] / 100);
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
; 0000 0174 EE_Write(eeprom_address + 1, (user_ids[userIndex] / 10) % 10);
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
; 0000 0175 EE_Write(eeprom_address + 2, user_ids[userIndex] % 10);
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x19
; 0000 0176 eeprom_address += 3; // Move to the next address for the next data
; 0000 0177 
; 0000 0178 // Delimiter between user id and password
; 0000 0179 EE_Write(eeprom_address, DELIMITER);
	RCALL SUBOPT_0x15
; 0000 017A eeprom_address++;
; 0000 017B 
; 0000 017C // Write User Password (3 digits) to EEPROM
; 0000 017D EE_Write(eeprom_address, user_passwords[userIndex] / 100);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x17
; 0000 017E EE_Write(eeprom_address + 1, (user_passwords[userIndex] / 10) % 10);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x18
; 0000 017F EE_Write(eeprom_address + 2, user_passwords[userIndex] % 10);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x19
; 0000 0180 eeprom_address += 3; // Move to the next address for the next data
; 0000 0181 
; 0000 0182 // Delimiter between different users
; 0000 0183 EE_Write(eeprom_address, DELIMITER);
	RCALL SUBOPT_0x1B
; 0000 0184 eeprom_address++;
	__ADDWRN 20,21,1
; 0000 0185 }
	__ADDWRN 16,17,1
	RJMP _0x60
_0x61:
; 0000 0186 
; 0000 0187 // Mark the end of data with 0xFFFF
; 0000 0188 EE_Write(eeprom_address, 0xFF);
	RCALL SUBOPT_0x1B
; 0000 0189 EE_Write(eeprom_address + 1, 0xFF);
	MOVW R30,R20
	ADIW R30,1
	RCALL SUBOPT_0x1C
; 0000 018A EE_Write(eeprom_address + 2, 0xFF);
	MOVW R30,R20
	ADIW R30,2
	RCALL SUBOPT_0x1C
; 0000 018B }
	RCALL __LOADLOCR6
	ADIW R28,36
	RET
; .FEND
;void readData()
; 0000 018E {
; 0000 018F int eeprom_address = 0; // Starting EEPROM address for sequential reading
; 0000 0190 int i;
; 0000 0191 for(i = 0; i < 3; i++)
;	eeprom_address -> R16,R17
;	i -> R18,R19
; 0000 0192 {
; 0000 0193 int i = 0;               // Reset i for each user
; 0000 0194 char user_name[6];       // Fixed size for user names
; 0000 0195 int user_id;
; 0000 0196 int user_password;
; 0000 0197 
; 0000 0198 // Read User Name from EEPROM (fixed length)
; 0000 0199 for (i = 0; i < 5; ++i)
;	i -> Y+10
;	user_name -> Y+4
;	user_id -> Y+2
;	user_password -> Y+0
; 0000 019A {
; 0000 019B user_name[i] = EE_Read(eeprom_address);
; 0000 019C eeprom_address++;
; 0000 019D }
; 0000 019E user_name[5] = '\0'; // Null-terminate the string
; 0000 019F 
; 0000 01A0 // Check and skip delimiter between user name and ID
; 0000 01A1 if (EE_Read(eeprom_address) != DELIMITER)
; 0000 01A2 {
; 0000 01A3 // Handle delimiter error or end of data
; 0000 01A4 break;
; 0000 01A5 }
; 0000 01A6 eeprom_address++;
; 0000 01A7 
; 0000 01A8 // Read User ID (3 digits) from EEPROM
; 0000 01A9 user_id = EE_Read(eeprom_address) * 100 +
; 0000 01AA EE_Read(eeprom_address + 1) * 10 +
; 0000 01AB EE_Read(eeprom_address + 2);
; 0000 01AC eeprom_address += 3; // Move to the next address for the next data
; 0000 01AD 
; 0000 01AE // Check and skip delimiter between user id and password
; 0000 01AF if (EE_Read(eeprom_address) != DELIMITER)
; 0000 01B0 {
; 0000 01B1 // Handle delimiter error or end of data
; 0000 01B2 break;
; 0000 01B3 }
; 0000 01B4 eeprom_address++;
; 0000 01B5 
; 0000 01B6 // Read User Password (3 digits) from EEPROM
; 0000 01B7 user_password = EE_Read(eeprom_address) * 100 +
; 0000 01B8 EE_Read(eeprom_address + 1) * 10 +
; 0000 01B9 EE_Read(eeprom_address + 2);
; 0000 01BA eeprom_address += 3; // Move to the next address for the next data
; 0000 01BB 
; 0000 01BC // Check and skip delimiter between different users
; 0000 01BD if (EE_Read(eeprom_address) != DELIMITER)
; 0000 01BE {
; 0000 01BF // Handle delimiter error or end of data
; 0000 01C0 break;
; 0000 01C1 }
; 0000 01C2 eeprom_address++;
; 0000 01C3 
; 0000 01C4 // Display the read data
; 0000 01C5 lcd_clear();
; 0000 01C6 //lcd_printf("Name: %s, ID: %d, P: %d\n", user_name, user_id, user_password);
; 0000 01C7 //delay_ms(900);
; 0000 01C8 }
; 0000 01C9 }
;unsigned char EE_Read(unsigned int address)
; 0000 01CC {
_EE_Read:
; .FSTART _EE_Read
; 0000 01CD EEPROM_WAIT;    // Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x6E:
	SBIC 0x1C,1
	RJMP _0x6E
; 0000 01CE EEAR = address; // Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 01CF EECR.0 = 1;      // Execute read command
	SBI  0x1C,0
; 0000 01D0 return EEDR;
	IN   R30,0x1D
	RJMP _0x20C0002
; 0000 01D1 }
; .FEND
;void EE_Write(unsigned int address, unsigned char data)
; 0000 01D4 {
_EE_Write:
; .FSTART _EE_Write
; 0000 01D5 EEPROM_WAIT;    // Wait till EEPROM is ready
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	address -> R18,R19
;	data -> R17
_0x73:
	SBIC 0x1C,1
	RJMP _0x73
; 0000 01D6 EEAR = address; // Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 01D7 EEDR = data;    // Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 01D8 EECR.2 = 1;      // Master write enable
	SBI  0x1C,2
; 0000 01D9 EECR.1 = 1;      // Write Enable
	SBI  0x1C,1
; 0000 01DA EEPROM_WAIT;    // Wait till EEPROM is ready
_0x7A:
	SBIC 0x1C,1
	RJMP _0x7A
; 0000 01DB EECR.1 = 0;      // Clear Write Enable bit
	CBI  0x1C,1
; 0000 01DC }
	RCALL __LOADLOCR4
_0x20C0003:
	ADIW R28,6
	RET
; .FEND
;void motor()
; 0000 01DF {
_motor:
; .FSTART _motor
; 0000 01E0 int i;
; 0000 01E1 for (i = 0; i < 5; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x80:
	__CPWRN 16,17,5
	BRGE _0x81
; 0000 01E2 // Door closed
; 0000 01E3 PORTD |= (1 << PORTD0);  // PORTD.0 = 1
	SBI  0x12,0
; 0000 01E4 PORTD &= ~(1 << PORTD1); // PORTD.1 = 0
	CBI  0x12,1
; 0000 01E5 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 01E6 
; 0000 01E7 // Door opening
; 0000 01E8 PORTD &= ~(1 << PORTD0); // PORTD.0 = 0
	CBI  0x12,0
; 0000 01E9 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 01EA 
; 0000 01EB //        // Door open
; 0000 01EC //        PORTD |= (1 << PORTD1);  // PORTD.1 = 1
; 0000 01ED //        delay_ms(1000);
; 0000 01EE //
; 0000 01EF //        // Door closing
; 0000 01F0 //        PORTD &= ~(1 << PORTD1); // PORTD.1 = 0
; 0000 01F1 //        delay_ms(1000);
; 0000 01F2 }
	__ADDWRN 16,17,1
	RJMP _0x80
_0x81:
; 0000 01F3 }
_0x20C0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void Buzz()
; 0000 01F6 {
_Buzz:
; .FSTART _Buzz
; 0000 01F7 PORTD.5 = 1; // Assuming PD5 is connected to the sounder
	SBI  0x12,5
; 0000 01F8 delay_ms(100); // Adjust the delay as needed
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01F9 PORTD.5 = 0;
	CBI  0x12,5
; 0000 01FA }
	RET
; .FEND
;char keypad()
; 0000 01FD {
_keypad:
; .FSTART _keypad
; 0000 01FE while (1)
_0x86:
; 0000 01FF {
; 0000 0200 PORTC.0 = 0; // C0 is on, C1 and C2 are off
	CBI  0x15,0
; 0000 0201 PORTC.1 = 1;
	SBI  0x15,1
; 0000 0202 PORTC.2 = 1;
	SBI  0x15,2
; 0000 0203 
; 0000 0204 switch (PINC)
	IN   R30,0x13
; 0000 0205 {
; 0000 0206 case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x92
; 0000 0207 while (PINC.3 == 0)
_0x93:
	SBIS 0x13,3
; 0000 0208 ; // While the button is pressed, Wait!
	RJMP _0x93
; 0000 0209 return '1';
	LDI  R30,LOW(49)
	RET
; 0000 020A break;
	RJMP _0x91
; 0000 020B 
; 0000 020C case 0b11101110:
_0x92:
	CPI  R30,LOW(0xEE)
	BRNE _0x96
; 0000 020D while (PINC.4 == 0)
_0x97:
	SBIS 0x13,4
; 0000 020E ; // While the button is pressed, Wait!
	RJMP _0x97
; 0000 020F return '4';
	LDI  R30,LOW(52)
	RET
; 0000 0210 break;
	RJMP _0x91
; 0000 0211 
; 0000 0212 case 0b11011110:
_0x96:
	CPI  R30,LOW(0xDE)
	BRNE _0x9A
; 0000 0213 while (PINC.5 == 0)
_0x9B:
	SBIS 0x13,5
; 0000 0214 ; // While the button is pressed, Wait!
	RJMP _0x9B
; 0000 0215 return '7';
	LDI  R30,LOW(55)
	RET
; 0000 0216 break;
	RJMP _0x91
; 0000 0217 
; 0000 0218 case 0b10111110:
_0x9A:
	CPI  R30,LOW(0xBE)
	BREQ _0x9F
; 0000 0219 case 0b10111101:
	CPI  R30,LOW(0xBD)
	BRNE _0xA0
_0x9F:
; 0000 021A case 0b10111011:
	RJMP _0xA1
_0xA0:
	CPI  R30,LOW(0xBB)
	BRNE _0x91
_0xA1:
; 0000 021B while (PINC.6 == 0)
_0xA3:
	SBIS 0x13,6
; 0000 021C ; // While the button is pressed, Wait!
	RJMP _0xA3
; 0000 021D return '*';
	LDI  R30,LOW(42)
	RET
; 0000 021E break;
; 0000 021F }
_0x91:
; 0000 0220 
; 0000 0221 PORTC.0 = 1; // C1 is on, C0 and C2 are off
	SBI  0x15,0
; 0000 0222 PORTC.1 = 0;
	CBI  0x15,1
; 0000 0223 PORTC.2 = 1;
	SBI  0x15,2
; 0000 0224 
; 0000 0225 switch (PINC)
	IN   R30,0x13
; 0000 0226 {
; 0000 0227 case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0xAF
; 0000 0228 while (PINC.3 == 0)
_0xB0:
	SBIS 0x13,3
; 0000 0229 ; // While the button is pressed, Wait!
	RJMP _0xB0
; 0000 022A return '2';
	LDI  R30,LOW(50)
	RET
; 0000 022B break;
	RJMP _0xAE
; 0000 022C 
; 0000 022D case 0b11101101:
_0xAF:
	CPI  R30,LOW(0xED)
	BRNE _0xB3
; 0000 022E while (PINC.4 == 0)
_0xB4:
	SBIS 0x13,4
; 0000 022F ; // While the button is pressed, Wait!
	RJMP _0xB4
; 0000 0230 return '5';
	LDI  R30,LOW(53)
	RET
; 0000 0231 break;
	RJMP _0xAE
; 0000 0232 
; 0000 0233 case 0b11011101:
_0xB3:
	CPI  R30,LOW(0xDD)
	BRNE _0xB7
; 0000 0234 while (PINC.5 == 0)
_0xB8:
	SBIS 0x13,5
; 0000 0235 ; // While the button is pressed, Wait!
	RJMP _0xB8
; 0000 0236 return '8';
	LDI  R30,LOW(56)
	RET
; 0000 0237 break;
	RJMP _0xAE
; 0000 0238 
; 0000 0239 case 0b10111101:
_0xB7:
	CPI  R30,LOW(0xBD)
	BRNE _0xAE
; 0000 023A while (PINC.6 == 0)
_0xBC:
	SBIS 0x13,6
; 0000 023B ; // While the button is pressed, Wait!
	RJMP _0xBC
; 0000 023C return '0';
	LDI  R30,LOW(48)
	RET
; 0000 023D break;
; 0000 023E }
_0xAE:
; 0000 023F 
; 0000 0240 PORTC.0 = 1; // C2 is on, C0 and C1 are off
	SBI  0x15,0
; 0000 0241 PORTC.1 = 1;
	SBI  0x15,1
; 0000 0242 PORTC.2 = 0;
	CBI  0x15,2
; 0000 0243 
; 0000 0244 switch (PINC)
	IN   R30,0x13
; 0000 0245 {
; 0000 0246 case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0xC8
; 0000 0247 while (PINC.3 == 0)
_0xC9:
	SBIS 0x13,3
; 0000 0248 ; // While the button is pressed, Wait!
	RJMP _0xC9
; 0000 0249 return '3';
	LDI  R30,LOW(51)
	RET
; 0000 024A break;
	RJMP _0xC7
; 0000 024B 
; 0000 024C case 0b11101011:
_0xC8:
	CPI  R30,LOW(0xEB)
	BRNE _0xCC
; 0000 024D while (PINC.4 == 0)
_0xCD:
	SBIS 0x13,4
; 0000 024E ; // While the button is pressed, Wait!
	RJMP _0xCD
; 0000 024F return '6';
	LDI  R30,LOW(54)
	RET
; 0000 0250 break;
	RJMP _0xC7
; 0000 0251 
; 0000 0252 case 0b11011011:
_0xCC:
	CPI  R30,LOW(0xDB)
	BRNE _0xC7
; 0000 0253 while (PINC.5 == 0)
_0xD1:
	SBIS 0x13,5
; 0000 0254 ; // While the button is pressed, Wait!
	RJMP _0xD1
; 0000 0255 return '9';
	LDI  R30,LOW(57)
	RET
; 0000 0256 break;
; 0000 0257 }
_0xC7:
; 0000 0258 }
	RJMP _0x86
; 0000 0259 }
; .FEND
;interrupt [2] void ext_int0_isr(void)
; 0000 025C {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	RCALL SUBOPT_0x1D
; 0000 025D char adminPC[3];
; 0000 025E int i;
; 0000 025F bool admin;
; 0000 0260 lcd_clear();
	SBIW R28,3
	RCALL __SAVELOCR4
;	adminPC -> Y+4
;	i -> R16,R17
;	admin -> R19
	RCALL _lcd_clear
; 0000 0261 lcd_printf("Enter Admin PC: ");
	__POINTW1FN _0x0,167
	RCALL SUBOPT_0x5
; 0000 0262 
; 0000 0263 for (i = 0; i < 3; i++)
	__GETWRN 16,17,0
_0xD5:
	__CPWRN 16,17,3
	BRGE _0xD6
; 0000 0264 {
; 0000 0265 adminPC[i] = keypad();
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _keypad
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0266 lcd_putchar(adminPC[i]);
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _lcd_putchar
; 0000 0267 }
	__ADDWRN 16,17,1
	RJMP _0xD5
_0xD6:
; 0000 0268 
; 0000 0269 admin = checkPassCode(adminPC, 10);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _checkPassCode
	MOV  R19,R30
; 0000 026A 
; 0000 026B // Check Admin PC
; 0000 026C if (!admin)
	CPI  R19,0
	BRNE _0xD7
; 0000 026D {
; 0000 026E lcd_clear();
	RCALL SUBOPT_0x10
; 0000 026F lcd_printf("Contact Admin");
; 0000 0270 Buzz();
; 0000 0271 Buzz();
	RCALL _Buzz
; 0000 0272 }
; 0000 0273 else
	RJMP _0xD8
_0xD7:
; 0000 0274 AdminEdit();
	RCALL _AdminEdit
; 0000 0275 }
_0xD8:
	RCALL __LOADLOCR4
	ADIW R28,7
	RJMP _0xD9
; .FEND
;interrupt [3] void ext_int1_isr(void)
; 0000 0278 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x1D
; 0000 0279 UserEdit();
	RCALL _UserEdit
; 0000 027A }
_0xD9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R5,R16
	MOV  R4,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x1E
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1E
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x20C0001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R7,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x20
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x20
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x21
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x22
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x21
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x21
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x20
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x20
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x20
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G101:
; .FSTART _put_lcd_G101
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G101)
	LDI  R31,HIGH(_put_lcd_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ADD  R26,R20
	ADC  R27,R21
	LD   R26,X
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	RCALL _checkUserID
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RJMP _checkPassCode

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RJMP _Buzz

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	SBIW R28,9
	RCALL __SAVELOCR4
	RCALL _lcd_clear
	__POINTW1FN _0x0,71
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,10
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	ST   X,R30
	MOVW R26,R28
	ADIW R26,10
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL _lcd_clear
	__POINTW1FN _0x0,87
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,7
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xB:
	ST   X,R30
	MOVW R26,R28
	ADIW R26,7
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL _lcd_clear
	__POINTW1FN _0x0,102
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R18
	ADC  R27,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LD   R0,X
	MOVW R26,R28
	ADIW R26,7
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	CP   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	RCALL _lcd_clear
	__POINTW1FN _0x0,118
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL _lcd_clear
	__POINTW1FN _0x0,132
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RJMP _storeNewPC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL _lcd_clear
	__POINTW1FN _0x0,118
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	RCALL _Buzz
	RJMP _Buzz

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(255)
	RCALL _EE_Write
	__ADDWRN 20,21,1
	ST   -Y,R21
	ST   -Y,R20
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x16:
	MOVW R26,R28
	ADIW R26,14
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R26,R30
	RCALL _EE_Write
	MOVW R30,R20
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R30
	RCALL _EE_Write
	MOVW R30,R20
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R26,R30
	RCALL _EE_Write
	__ADDWRN 20,21,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1A:
	MOVW R26,R28
	ADIW R26,8
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(255)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x20:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x21:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	PUSH R26
	PUSH R27
	MOVW R26,R22
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	POP  R27
	POP  R26
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
