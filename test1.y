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
	int expectedArgs;
	int args;
	char * opName;
	int	 arg1;
	int arg2;
} operationDescription;
	
//Информация об анализируемой операции
operationDescription opDesc;
	
//Флаги
int readingCommandLine = 0;
	
%}
//=====================================================

//Inter-module buffer
%union {
	int val;
	char * str;
}

%token	DECIMAL
%token	HEXADECIMAL
%token	OCTAL
%token	BINARY
%token	<str>VALUE
%token	<str>ID
%token	DIVIDER
%token	NEWLINE
%token	<str>LABEL

%start text													

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text: newLine line newLine text	{}
	| line newLine text			{}
	| newLine line newLine		{}
	| line newLine				{}
	| newLine line				{}
	| line						{}

newLine	: NEWLINE					{}
		| divider newLine 			{}
		| newLine divider 			{}
		| divider newLine divider	{}
		| NEWLINE newLine			{}

line: command 						{ 
										printf("line parsed\n");
									 	readingCommandLine = 0;
									}
	| LABEL			 			 	{ 
										printf("line parsed\n");
								 		readingCommandLine = 0;
									}

command	: 	id divider arguments	{}
		|	id divider				{}
		|	id						{}

arguments	: arg divider arguments {}
			| arg divider			{}
			| arg

arg	: id			{ if (isRegisterName($<str>1) == 1) printf("found\n");}
	| ariphmetic	{}

ariphmetic	: num	{/*Потом отсюда расширим арифметику*/}

id	: ID	{ printf("%s\n", $1); operationAnalyze($1); }

divider	: DIVIDER divider 	{}
		| DIVIDER			{}

num	: DECIMAL VALUE		{ $<val>$ = toDecimalConvert(10, $2); }
	| HEXADECIMAL VALUE	{ $<val>$ = toDecimalConvert(16, $2); }
	| OCTAL	VALUE		{ $<val>$ = toDecimalConvert(8, $2); }
	| BINARY VALUE		{ $<val>$ = toDecimalConvert(2, $2); }


%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int toDecimalConvert(int base, char * num) {
	return 0;
	/*TODO конвертер по разным основаниям в 10-чную систему*/
}

int toBaseConvert(int base, int num) {
	/*Надо ли это нам? Как будем хранить не десятичные числа? Мб вообще в строках? А работать с 10-м представлением?*/
	/*TODO конвертер по разным основаниям в 8-чную систему*/
}

//Инициализация переменной под новую операцию
void operationAnalyze(char * name) {
	//Проверяем, читаем уже команду или пока нет
	if (readingCommandLine == 0) 
	{
		int t = isCommandName(name);
		if (t != -1)
		{
			opDesc.expectedArgs = t;
			opDesc.args = 0;
			readingCommandLine = 1;
		}
		else
		{
			printf("<ERROR> wrong command recieved\n");
		}	
	}
	else if (isRegisterName(name) == 1)
	{
		switch (opDesc.args) {
			case 1:
				opDesc.arg1 = argConvert(name);
				break;
			case 2:
				opDesc.arg2 = argConvert(name);
				break;
		}
		opDesc.args++;
		//Проверка на ожидаемое количество аргументов
		if (opDesc.args > opDesc.expectedArgs) 
		{
			printf("<ERROR> expected %d argument(s)\n", opDesc.expectedArgs);
		}
	}
}

int inArray(char * a[], char * arg, int l) {
	//int l = sizeof(a)/sizeof(a[0]);
	for (int i = 0; i < l; i++)
	{
		if (strcmp(arg, a[i]) == 0) 
		{
			return 1;
		}
	}
	return 0;
}

int isNArgCommand(char * arg, int n) {
	switch (n) {
		case 0:
			{
				char * a[] =
					{"XCHG", "XTHL", "SPHL", "PCHL", "RET", 
					 "RNZ", "RZ", "RNC", "RC", "RPO", "RPE", 
					 "RP", "RM", "EI", "DI", "NOP", "HLT", 
					 "DAA", "CMA", "RLC", "RRC", "RAL", 
					 "RAR", "STC", "CMC" };
				int l = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, l);
			}
		case 1:
			{
				char * a[] =
					{"LDAX", "STAX", "IN", "OUT", 
					 "PUSH", "POP", "PCHL", "RST", 
					 "ADD", "ADI", "ADC", "ACI", 
					 "SUB", "SUI", "SBB", "SBI", 
					 "CMP", "CPI", "INR", "INX", 
					 "DCR", "DCX", "DAD", "ANA", 
					 "ANI", "XRA", "XRI", "ORA", 
					 "ORI"};
				int l = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, l);
			}
		case 2:
			{
				char * a[] =
					{"MOV", "MVI", "LXI", "LDA", 
					 "STA", "LHLD", "SHLD", 
					 "JMP", "CALL", "JNZ", "JZ", 
					 "JNC", "JC", "JPO", "JPE", 
					 "JP", "JM", "CNZ", "CZ", 
					 "CNC", "CC", "CPO", "CPE", 
					 "CP", "CM"};
				int l = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, l);
			}
		default:
			printf("<ERROR> wrong argument amount\n");
			return 0;
	}
}

//Встречена команда?
int isCommandName(char * arg) {
	//Количество найденных совпадений (0 или 1 при корректной работе)
	int found = 0;
	//Количество аргументов (-1 - команда не найдена)
	int result = -1;
	//Цикл по возможному количеству арг-в
	for (int i = 0; i <= 2; i++)
	{
		found+=isNArgCommand(arg, i);
		if (found > 0) result = i;
	}
	if (found > 1) 
	{
		printf ("<ERROR> command duplicates in command list\n");
	}
	return result;
}

//Встречено условное имя регистра/регистровой пары?
int isRegisterName(char * arg) {
	const char * a[] = 
		{"B", "C", "D", "E", "H", "L", "M", "A", "PSW", "SP"};
	int length = sizeof(a)/sizeof(a[0]);
	for (int i = 0; i < length; i++)
	{
		if (strcmp(arg, a[i]) == 0) 
		{
			return 1;
		}
	}
	return 0;
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
		return -1;
	}
}

/*Full command list*/
/*XCHG|XTHL|SPHL|PCHL|RET|RNZ|RZ|RNC|RC|RPO|RPE|RP|RM|EI|DI|NOP|HLT|DAA|CMA|RLC|RRC|RAL|RAR|STC|CMC;

LDAX|STAX|IN|OUT|PUSH|POP|PCHL|RST|ADD|ADI|ADC|ACI|SUB|SUI|SBB|SBI|CMP|CPI|INR|INX|DCR|DCX|DAD|ANA|ANI|XRA|XRI|ORA|ORI;

MOV|MVI|LXI|LXISP|LDA|STA|LHLD|SHLD|JMP|CALL|JNZ|JZ|JNC|JC|JPO|JPE|JP|JM|CNZ|CZ|CNC|CC|CPO|CPE|CP|CM;*/