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

%token	<val>DECIMAL
%token	<str>HEXADECIMAL
%token	<str>OCTAL
%token	<str>BINARY
%token	<str>ID
%token	DIVIDER
%token	<str>LABEL

%start text													

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text: line divider text	{}
	| line divider		{}
	| line				{}

line: command 						{}
	| LABEL			 			 	{}

command	: 	id divider arguments	{}
		|	id						{}

arguments	: arg divider arguments {}
			| arg

arg	: id	{}
	| num	{}

id	: ID	{ printf("%s\n", $1); }

divider	: DIVIDER divider 	{}
		| DIVIDER			{}

num	: DECIMAL		{}
	| HEXADECIMAL	{}
	| OCTAL			{}
	| BINARY		{}


%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int toDecimalConvert(int base, char * num) {
	/*TODO конвертер по разным основаниям в 10-чную систему*/
}

int toOctalConvert(int base, char * num) {
	/*Надо ли это нам? Как будем хранить не десятичные числа? Мб вообще в строках? А работать с 10-м представлением?*/
	/*TODO конвертер по разным основаниям в 8-чную систему*/
}

//Конвертация символьного значения регистра/регистровой пары в числовое
int argConvert(char * arg) {
	if (strcmp(arg, "B") == 0)
	{
		return 0;
	}
	else if (strcmp(arg, "C") == 0) 
	{
		return 1;
	}
	else if (strcmp(arg, "D") == 0) 
	{
		return 2;
	}
	else if (strcmp(arg, "E") == 0) 
	{
		return 3;
	}
	else if (strcmp(arg, "H") == 0) 
	{
		return 4;
	}
	else if (strcmp(arg, "L") == 0) 
	{
		return 5;
	}
	else if (strcmp(arg, "M") == 0) 
	{
		return 6;
	}
	else if (strcmp(arg, "A") == 0) 
	{
		return 7;
	}
	else if (strcmp(arg, "SP") == 0) 
	{
		return 6;
	}
	else if (strcmp(arg, "PSW") == 0) 
	{
		return 6;
	}
	else 
	{
		printf("<ERROR>: unexpected argument\n");
		return 0;
	}
}

/*Full command list*/
/*XCHG|XTHL|SPHL|PCHL|RET|RNZ|RZ|RNC|RC|RPO|RPE|RP|RM|EI|DI|NOP|HLT|DAA|CMA|RLC|RRC|RAL|RAR|STC|CMC;

LDAX|STAX|IN|OUT|PUSH|POP|PCHL|RST|ADD|ADI|ADC|ACI|SUB|SUI|SBB|SBI|CMP|CPI|INR|INX|DCR|DCX|DAD|ANA|ANI|XRA|XRI|ORA|ORI;

MOV|MVI|LXI|LXISP|LDA|STA|LHLD|SHLD|JMP|CALL|JNZ|JZ|JNC|JC|JPO|JPE|JP|JM|CNZ|CZ|CNC|CC|CPO|CPE|CP|CM;*/