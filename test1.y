//=====================================================
%{
#include <malloc.h>
#include "my.h"
#include <string.h>
#include <stdio.h>

//Global variables&flags
int lineCounter = 1;	
int columnCounter = 0;
	
//Типы операций
enum OPCODE
{
	MOV,
	MVI,
	LXI,
	LDA,
	LDAX,
	STA,
	STAX,
	IN,
	OUT,
	XCHG,
	XTHL,
	LHLD,
	SHLD,
	SPHL,
	PCHL,
	PUSH,
	POP,
	JMP,
	CALL,
	RET,
	RST,
	JNZ,
	JZ,
	JNC,
	JC,
	JPO,
	JPE,
	JP,
	JM,
	CNZ,
	CZ,
	CNC,
	CC,
	CPO,
	CPE,
	CP,
	CM,
	RNZ,
	RZ,
	RNC,
	RC,
	RPO,
	RPE,
	RP,
	RM,
	EI,
	DI,
	NOP,
	HLT,
	ADD,
	ADI,
	ADC,
	ACI,
	SUB,
	SUI,
	SBB,
	SBI,
	CMP,
	CPI,
	INR,
	INX,
	DCR,
	DCX,
	DAD,
	DAA,
	ANA,
	ANI,
	XRA,
	XRI,
	ORA,
	ORI,
	CMA,
	RLC,
	RRC,
	RAL,
	RAR,
	STC,
	CMC,
};
	
//Типы аргументов
enum ARGTYPE
{
	NAME,
	VALUE
};

//Описание команды:
typedef struct {
	int args;
	enum OPCODE opCode;
} commandInfo;

typedef struct {
	int val;
	char * str;
} variousInfo;	

//Описание аргумента:
typedef struct {
	enum ARGTYPE argType;
	variousInfo * arg;//Число либо строка в зависимости от типа
} argumentInfo;

%}
//=====================================================

//Inter-module buffer
%union {
	int val;
	char * str;
}

%token	<val>NUM
%token	<str>ID
%token	DIVIDER
%token	<str>LABEL

%start text													

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text: line '\n' text	{}
	| line				{}

line: command 						{}
	| LABEL			 			 	{}

command	: 	ID DIVIDER arguments	{}
		|	ID						{}

arguments	: arguments DIVIDER arguments 	{}
			| ID 							{}
			| NUM							{}			


%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	

/*Full command list*/
/*XCHG|XTHL|SPHL|PCHL|RET|RNZ|RZ|RNC|RC|RPO|RPE|RP|RM|EI|DI|NOP|HLT|DAA|CMA|RLC|RRC|RAL|RAR|STC|CMC;

LDAX|STAX|IN|OUT|PUSH|POP|PCHL|RST|ADD|ADI|ADC|ACI|SUB|SUI|SBB|SBI|CMP|CPI|INR|INX|DCR|DCX|DAD|ANA|ANI|XRA|XRI|ORA|ORI;

MOV|MVI|LXI|LXISP|LDA|STA|LHLD|SHLD|JMP|CALL|JNZ|JZ|JNC|JC|JPO|JPE|JP|JM|CNZ|CZ|CNC|CC|CPO|CPE|CP|CM;*/