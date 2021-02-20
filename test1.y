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
	CMC
};	

enum OUTPUTMODE
{
	BINARY,
	OCTAL,
	NUMERIC,
	CHECK
} globalMode;
	
//Описание команды:
typedef struct {
	int expectedArgs;
	int args;
	char opName[10];
	int	arg1;
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
										//printf("line parsed\n");
										getCommand(globalMode);
									 	readingCommandLine = 0;
									}
	| LABEL			 			 	{ 
										//printf("line parsed\n");
										getCommand(globalMode);
								 		readingCommandLine = 0;
									}

command	: 	id divider arguments	{}
		|	id divider				{}
		|	id						{}

arguments	: arg divider arguments {}
			| arg divider			{}
			| arg

arg	: id			{}
	| ariphmetic	{ numArgAnalyze($<val>1); }

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
	return 46;
	/*TODO конвертер по разным основаниям в 10-чную систему*/
}

/*int[] toBinaryConvert(int num) {
	char result[MAX_BINARY_LENGTH];
	for (int i = MAX_BINARY_LENGTH-1; i >= 0; i--) {
		result[i] = num%2;
		num = num/2;
	}
	return result;
}*/

void getCommand(enum OUTPUTMODE mode) {
	readingCommandLine = 0;
	printf("\x1b[32;1mparsed: %s %d %d\n\x1b[0m", opDesc.opName, opDesc.arg1, opDesc.arg2);
	
}

void numArgAnalyze(int arg) {
	if (readingCommandLine == 1)
	{
		addOpDescArgument(arg);
	}
	else
	{
		printf("<ERROR> unexpected numeric argument\n");
	}	
}

void addOpDescArgument(int arg) {
	//printf("called with arg %d\n", arg);
	//Проверка на ожидаемое количество аргументов
	if (opDesc.args >= opDesc.expectedArgs) 
	{
		printf("<ERROR> expected %d argument(s)\n", opDesc.expectedArgs);
	} 
	//Если аргумент отрицательный
	else if (arg < 0)
	{	
		printf("<ERROR> expected non negative argument\n");
	}
	//Если получили двухбайтный аргумент
	else if (arg >= 8)
	{
		//printf(">=8. Get %d\n", arg);
		addOpDescArgument(arg/8);
		addOpDescArgument(arg%8);
	}
	else 
	{
		opDesc.args++;
		//printf("adding arg %d\n", arg);
		switch (opDesc.args)
		{
			case 1:
				switch (opDesc.expectedArgs) 
				{
					case 1:
						opDesc.arg1 = arg;
						break;
					case 2:
						opDesc.arg2 = arg;
						break;
					default:
						printf("<ERROR> too much args expected\n");
						break;
				}
				break;
			case 2:
				//Сдвигаем аргументы
				opDesc.arg1 = opDesc.arg2;
				opDesc.arg2 = arg;
				break;
		}
	}
	/*if (opDesc.args == opDesc.expectedArgs)
		printf("parsed: %s %d %d\n", opDesc.opName, opDesc.arg1, opDesc.arg2);*/
}


//Инициализация переменной под новую операцию
void operationAnalyze(char * name) {
	//Проверяем, читаем уже команду или пока нет
	if (readingCommandLine == 0) 
	{
		int t = isCommandName(name);
		if (t != -1)
		{
			//printf ("initialized\n");
			opDesc.expectedArgs = t;
			strcpy(opDesc.opName, name);
			opDesc.args = 0;
			opDesc.arg1 = 0;
			opDesc.arg2 = 0;
			readingCommandLine = 1;
		}
		else
		{
			printf("<ERROR> wrong command recieved\n");
		}	
	}
	else if (isRegisterName(name) == 1)
	{
		addOpDescArgument(argConvert(name));
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