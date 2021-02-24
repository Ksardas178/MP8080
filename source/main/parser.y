//=====================================================
%{
#include <malloc.h>
#include <main/my.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

enum OUTPUTMODE
{
	M_BINARY,
	M_OCTAL,
	M_NUMERIC,
	M_CHECK
};

typedef struct {
	char content[MSG_LENGTH];
} message;

//Буфер хранения сообщений о ходе анализа функции
typedef struct {
	int size;
	int stored;
	message *p;
} analyzeBuffer;

//Описание команды:
typedef struct {
	int expectedArgs;
	int args;
	char opName[10];
	int	arg[MAX_ARGS];
} operationDescription;

//Информация об анализируемой операции
operationDescription opDesc;
analyzeBuffer analyzeBuf;
char stringBuffer[MSG_LENGTH];

//Флаги и глобальные переменные
int readingCommandLine = 0;
int inProgram = 0;
int lineCounter = 1;
int warningCounter = 0;
int errorCounter = 0;
int columnCounter = 1;
enum OUTPUTMODE globalMode = M_CHECK;

//Предописания
void printAnalyzeBuf();
void operationAnalyze(char * name);
void numArgAnalyze(int arg);
void getCommand();
int toDecimalConvert(int base, const char* sum);
	
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
%token	NEWLINE
%token	<str>LABEL
%token	MULT
%token	DIV
%token	MOD
%token	PLUS
%token	MINUS
%token	INC
%token	DEC
%token	OPEN
%token	CLOSE
%token	SHL
%token	SHR

%start _text

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

_text	: text	{ getCommand(); printAnalyzeBuf(); }

text: line text	{}
	| line		{}

line: arguments	{}
	| LABEL		{}

arguments	: arg arguments {}
			| arg			{}

arg	: ID			{ operationAnalyze($1); 	}
	| ariphmetic6	{ numArgAnalyze($<val>1); 	}

ariphmetic6	: ariphmetic6 SHR ariphmetic5	{ $<val>$ = $<val>1/pow(2, $<val>3);	}
			| ariphmetic6 SHL ariphmetic5	{ $<val>$ = $<val>1*pow(2, $<val>3);	}
			| ariphmetic5					{ $<val>$ = $<val>1; 					}

ariphmetic5	: ariphmetic5 MINUS ariphmetic4	{ $<val>$ = $<val>1 - $<val>3; 	}
			| ariphmetic5 PLUS  ariphmetic4	{ $<val>$ = $<val>1 + $<val>3; 	}
			| ariphmetic4					{ $<val>$ = $<val>1; 			}
			
ariphmetic4	: ariphmetic4 MULT ariphmetic3	{ $<val>$ = $<val>1 * $<val>3; 	}
			| ariphmetic4 DIV  ariphmetic3	{ $<val>$ = $<val>1 / $<val>3; 	}
			| ariphmetic4 MOD  ariphmetic3	{ $<val>$ = $<val>1 % $<val>3; 	}
			| ariphmetic3					{ $<val>$ = $<val>1; 			}

ariphmetic3	: INC  ariphmetic3	{ $<val>$ = $<val>2 + 1;	}
			| DEC  ariphmetic3	{ $<val>$ = $<val>2 - 1;	}
			| ariphmetic2		{ $<val>$ = $<val>1;		}

ariphmetic2	: ariphmetic2  INC	{ $<val>$ = $<val>1 + 1;	}
			| ariphmetic2  DEC	{ $<val>$ = $<val>1 - 1;	}
			| ariphmetic1		{ $<val>$ = $<val>1;		}

ariphmetic1	: OPEN  ariphmetic5  CLOSE	{ $<val>$ = $<val>2;	}
			| num						{ $<val>$ = $<val>1;	}

num	: DECIMAL VALUE		{ $<val>$ = toDecimalConvert(10, $2); }
	| HEXADECIMAL VALUE	{ $<val>$ = toDecimalConvert(16, $2); }
	| OCTAL	VALUE		{ $<val>$ = toDecimalConvert(8, $2); }
	| BINARY VALUE		{ $<val>$ = toDecimalConvert(2, $2); }


%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//Перевод 10-чного числа в заданную СС и запись в глобальный буфер n знаков
void toBaseConvert(int num, int base, int digits) {
	for (int i = digits-1; i >= 0; i-=1)
	{
		stringBuffer[i] = num % base + '0';
		num = num / base;
	}
	stringBuffer[digits] = '\0';
}

//Сохранение строки в буфер с транслированным кодом
void storeAnalyzeBuf(char * msg) {
	analyzeBuf.stored++;
	if (analyzeBuf.stored > analyzeBuf.size)
	{
		analyzeBuf.size+=ANALYZE_BUF_ALLOCATE_SIZE;
		analyzeBuf.p = (message*)realloc(analyzeBuf.p, analyzeBuf.size * sizeof(message));
	}
	strcpy(analyzeBuf.p[analyzeBuf.stored-1].content, msg);
}

//Сохранение числа в заданной СС в буфер трансляции
void storeNumToAnalyzeBuffer(int num, int base, int digits){
	char temp[MSG_LENGTH];
	toBaseConvert(num, base, digits);
	sprintf(temp, "%s\n", stringBuffer);
	storeAnalyzeBuf(temp);
}

void storeBytesToAnalyzeBuffer(int a[], int l, int base, int digits) {
	for (int i = 0; i < l; i++)
	{
		storeNumToAnalyzeBuffer(a[i], base, digits);
	}
}

//Создает число, соответствующее 1му аргументу операции
int generateCommandNameCode(int a, int b, int c) {
	return (a * 8 + b) * 8 + c;
}

//Внутренняя функция трансляции в двоичное представление
void internalBinaryStore() {
	const int base = 2;
	const int digits = 8;
	const int arg1 = opDesc.arg[0];
	const int arg2 = opDesc.arg[1];
	const int arg3 = opDesc.arg[2];
	int a[10];
	int l;
	if (strcmp(opDesc.opName, "MOV") == 0)
	{
		a[0] = generateCommandNameCode(1, arg1, arg2);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "MVI") == 0)
	{
		a[0] = generateCommandNameCode(0, arg1, 6);;
		a[1] = arg2;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "LXI") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, C or SP register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1, 1);
		a[1] = arg2;
		a[2] = arg3;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "LDA") == 0)
	{
		a[0] = generateCommandNameCode(0, 7, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "LDAX") == 0)
	{
		if (arg1 != 0 && arg1 != 2)
		{
			printf("line %d: <WARNING> must be B or D register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1+1, 2);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "STA") == 0)
	{	
		a[0] = generateCommandNameCode(0, 6, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "STAX") == 0)
	{
		if (arg1 != 0 && arg1 != 2)
		{
			printf("line %d: <WARNING> must be B or D register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1, 2);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "IN") == 0)
	{
		a[0] = generateCommandNameCode(3, 3, 3);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "OUT") == 0)
	{
		a[0] = generateCommandNameCode(3, 2, 3);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "XCHG") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "XTHL") == 0)
	{
		a[0] = generateCommandNameCode(3, 4, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "LHLD") == 0)
	{
		a[0] = generateCommandNameCode(0, 5, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "SHLD") == 0)
	{
		a[0] = generateCommandNameCode(0, 4, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "SPHL") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "PCHL") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "PUSH") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, H or PSW register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(3, arg1, 5);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "POP") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, H or PSW register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(3, arg1, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "JMP") == 0)
	{
		a[0] = generateCommandNameCode(3, 0, 3);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CALL") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 5);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "RET") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "PCHL") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RST") == 0)
	{
		a[0] = generateCommandNameCode(3, arg1, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "JNZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 0, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JNC") == 0)
	{
		a[0] = generateCommandNameCode(3, 2, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JC") == 0)
	{
		a[0] = generateCommandNameCode(3, 3, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JPO") == 0)
	{
		a[0] = generateCommandNameCode(3, 4, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JPE") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JP") == 0)
	{
		a[0] = generateCommandNameCode(3, 6, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "JM") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 2);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CNZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 0, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CNC") == 0)
	{
		a[0] = generateCommandNameCode(3, 2, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CC") == 0)
	{
		a[0] = generateCommandNameCode(3, 3, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CPO") == 0)
	{
		a[0] = generateCommandNameCode(3, 4, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CPE") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CP") == 0)
	{
		a[0] = generateCommandNameCode(3, 6, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "CM") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 4);
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "RNZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 0, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RZ") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RNC") == 0)
	{
		a[0] = generateCommandNameCode(3, 2, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RC") == 0)
	{
		a[0] = generateCommandNameCode(3, 3, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RPO") == 0)
	{
		a[0] = generateCommandNameCode(3, 4, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RPE") == 0)
	{
		a[0] = generateCommandNameCode(3, 5, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RP") == 0)
	{
		a[0] = generateCommandNameCode(3, 6, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RM") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "EI") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "DI") == 0)
	{
		a[0] = generateCommandNameCode(3, 6, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "NOP") == 0)
	{
		a[0] = generateCommandNameCode(0, 0, 0);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "HLT") == 0)
	{
		a[0] = generateCommandNameCode(1, 6, 6);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ADD") == 0)
	{
		a[0] = generateCommandNameCode(2, 0, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ADI") == 0)
	{
		a[0] = generateCommandNameCode(3, 0, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "ADC") == 0)
	{
		a[0] = generateCommandNameCode(2, 1, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ACI") == 0)
	{
		a[0] = generateCommandNameCode(3, 1, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "SUB") == 0)
	{
		a[0] = generateCommandNameCode(2, 2, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "SUI") == 0)
	{
		a[0] = generateCommandNameCode(3, 2, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "SBB") == 0)
	{
		a[0] = generateCommandNameCode(2, 3, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "SBI") == 0)
	{
		a[0] = generateCommandNameCode(3, 3, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "CMP") == 0)
	{
		a[0] = generateCommandNameCode(2, 7, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "CPI") == 0)
	{
		a[0] = generateCommandNameCode(3, 7, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "INR") == 0)
	{
		a[0] = generateCommandNameCode(0, arg1, 4);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "INX") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, C or SP register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "DCR") == 0)
	{
		a[0] = generateCommandNameCode(0, arg1, 5);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "DCX") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, C or SP register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1+1, 3);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "DAD") == 0)
	{
		if (arg1 % 2 != 0)
		{
			printf("line %d: <WARNING> must be B, D, C or SP register specified\n", lineCounter);
		}
		
		a[0] = generateCommandNameCode(0, arg1+1, 1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "DAA") == 0)
	{
		a[0] = generateCommandNameCode(0, 4, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ANA") == 0)
	{
		a[0] = generateCommandNameCode(2, 4, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ANI") == 0)
	{
		a[0] = generateCommandNameCode(3, 4, 6);	
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "XRA") == 0)
	{
		a[0] = generateCommandNameCode(2, 5, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "XRI") == 0)
	{		
		a[0] = generateCommandNameCode(3, 5, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "ORA") == 0)
	{
		a[0] = generateCommandNameCode(2, 6, arg1);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "ORI") == 0)
	{
		a[0] = generateCommandNameCode(3, 6, 6);
		a[1] = arg1;
		l = 2;
	}
	else if (strcmp(opDesc.opName, "CMA") == 0)
	{
		a[0] = generateCommandNameCode(0, 5, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RLC") == 0)
	{
		a[0] = generateCommandNameCode(0, 0, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RRC") == 0)
	{
		a[0] = generateCommandNameCode(0, 1, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RAL") == 0)
	{
		a[0] = generateCommandNameCode(0, 2, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "RAR") == 0)
	{
		a[0] = generateCommandNameCode(0, 3, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "STC") == 0)
	{
		a[0] = generateCommandNameCode(0, 6, 7);
		l = 1;
	}
	else if (strcmp(opDesc.opName, "CMC") == 0)
	{
		a[0] = generateCommandNameCode(0, 7, 7);
		l = 1;
	}
	storeBytesToAnalyzeBuffer(a, l, base, digits);
}

//Запись операции в буфер трансляции
void getCommand() {
	if (opDesc.args < opDesc.expectedArgs)
	{
		fprintf(stderr, "line %d: <ERROR> too few arguments in command. Expected %d\n", lineCounter, opDesc.expectedArgs);
	}
	else
	{
		readingCommandLine = 0;
		char temp[MSG_LENGTH];
		switch (globalMode)
		{
			case M_CHECK:
				switch (opDesc.expectedArgs)
				{
					case 0:
						sprintf(temp, "%s\n", opDesc.opName);
						storeAnalyzeBuf(temp);
						break;
					case 1:
						sprintf(temp, "%s %d\n", opDesc.opName, opDesc.arg[0]);
						storeAnalyzeBuf(temp);
						break;
					case 2:
						sprintf(temp, "%s %d %d\n", opDesc.opName, opDesc.arg[0], opDesc.arg[1]);
						storeAnalyzeBuf(temp);
						break;
					case 3:
						sprintf(temp, "%s %d %d %d\n", opDesc.opName, opDesc.arg[0], opDesc.arg[1], opDesc.arg[2]);
						storeAnalyzeBuf(temp);
						break;
					default:
						printf("line %d: <INTERNAL_ERROR> too much args\n", lineCounter);
						break;
				}
				break;
			case M_BINARY:
				internalBinaryStore();
				break;
			case M_OCTAL:
				/*TODO*/
				break;
			case M_NUMERIC:
				/*TODO*/
				break;
			default:
				printf("line %d: <INTERNAL_ERROR> unrecognized mode\n", lineCounter);
				break;
		}
	}
}

//Инициализация информации об анализируемой команде
void commandInfoInit(int expected, char * name) {
	//printf ("initialized\n");
	opDesc.expectedArgs = expected;
	strcpy(opDesc.opName, name);
	opDesc.args = 0;
	for (int i = 0; i < MAX_ARGS; i++)
	{
		opDesc.arg[i] = 0;
	}
}

//Инициализация буфера трансляции
void analyzeBufInit() {
	char * empty = "";
	commandInfoInit(0, empty);
	free(analyzeBuf.p);
	analyzeBuf.stored = 0;
	analyzeBuf.size = ANALYZE_BUF_INIT_SIZE;
	analyzeBuf.p = (message *)calloc(ANALYZE_BUF_INIT_SIZE, sizeof(message));
}

//Вывод буфера трансляции
void printAnalyzeBuf() {
	printf("\n");
	if (errorCounter > 0) 
	{
		printf("\x1b[31;1mErrors: %d\n\x1b[0m", errorCounter);
	}
	if (warningCounter > 0) 
	{
		printf("\x1b[33;1mWarnings: %d\n\x1b[0m", warningCounter);
	} 
	if (errorCounter == 0 && warningCounter == 0)
	{
		printf("\x1b[32;1mInput is correct\n\x1b[0m");
	}
	printf("\n\x1b[30;1mCode analysis results:\n\x1b[0m______________________________\n");
	for (int i = 0; i < analyzeBuf.stored; i++)
	{
		toBaseConvert(i, 2, 8);
		printf("%s: %s", stringBuffer, analyzeBuf.p[i].content);
	}
	printf("\n");
}

//Добавление числового аргумента в буфер операции
void addOpDescArgument(int arg) {
	const int expected = opDesc.expectedArgs;
	//<CMD ARG[0] ARG[1] ARG[2]>
	{
		opDesc.args++;
		switch (expected)
		{
			case 1:
				opDesc.arg[0] = arg;
				break;
			case 2:
				opDesc.arg[0] = opDesc.arg[1];
				opDesc.arg[1] = arg;
				break;
			case 3:
				opDesc.arg[0] = opDesc.arg[1];
				opDesc.arg[1] = opDesc.arg[2];
				opDesc.arg[2] = arg;
				break;
			default:
				printf("line %d: <INTERNAL_ERROR> too much args expected\n", lineCounter);
				break;
		}
	}
	if (expected == opDesc.args)
	{
		//Пишем последний аргумент? Заносим команду в буфер
		getCommand();
	}
}

//Добавление в описание команды числового аргумента
void numArgAnalyze(int arg) {
	//Встретили, когда искали команду?
	if (readingCommandLine == 0)
	{
		//errorCounter++;
		//fprintf(stderr, "line %d: <ERROR> unexpected command\n", lineCounter);
	}
	//Были в команде, но не ждали больше аргументов?
	else if (opDesc.args == opDesc.expectedArgs)
	{
		errorCounter++;
		fprintf(stderr, "line %d: <ERROR> too much arguments. Expected %d\n", lineCounter, opDesc.expectedArgs);
	}
	//Если аргумент отрицательный
	else if (arg < 0)
	{
		errorCounter++;
		fprintf(stderr, "line %d: <ERROR> expected non negative argument\n", lineCounter);
	}
	//Читаем команду, ждем аргумент, он неотрицательный. Отлично
	else
	{	
		addOpDescArgument(arg);
	}
}

//Содержит ли массив длины l аргумент?
int inArray(const char * a[], char * arg, int l) {
	for (int i = 0; i < l; i++)
	{
		if (strcmp(arg, a[i]) == 0)
		{
			return 1;
		}
	}
	return 0;
}

//Проверяет, действительно ли у команды n аргументов
int isNArgCommand(char * arg, int n) {
	switch (n) {
		case 0:
			{
				const char * a[] =
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
				const char * a[] =
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
				const char * a[] =
					{"MOV", "MVI", "LDA",
					 "STA", "LHLD", "SHLD",
					 "JMP", "CALL", "JNZ", "JZ",
					 "JNC", "JC", "JPO", "JPE",
					 "JP", "JM", "CNZ", "CZ",
					 "CNC", "CC", "CPO", "CPE",
					 "CP", "CM"};
				int l = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, l);
			}
		case 3:
			{
				const char * a[] =
					{"LXI"};
				int l = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, l);
			}
		default:
			printf("line %d: <INTERNAL_ERROR> wrong argument amount\n", lineCounter);
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
	for (int i = 0; i <= MAX_ARGS; i++)
		if (isNArgCommand(arg, i))
		{
			found++;
			result = i;
		}
	if (found > 1)
	{
		printf ("line %d: <INTERNAL_ERROR> command duplicates in command list\n", lineCounter);
	}
	return result;
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
		errorCounter++;
		fprintf(stderr, "line %d: <ERROR>: unexpected argument\n", lineCounter);
		return -1;
	}
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

//Инициализация переменной под новую операцию
void operationAnalyze(char * name) {
	int t = isCommandName(name);
	//Только вошли в программу?
	if (inProgram == 0)
	{
		analyzeBufInit();
		commandInfoInit(t, name);
		inProgram = 1;
	}
	//Находимся в режиме поиска команды
	if (readingCommandLine == 0)
	{
		//Если нашли команду без аргументов
		if (t == 0) 
		{
			//Сразу же выводим ее
			commandInfoInit(t, name);
			getCommand();
			//Флаг не меняем - ищем новую команду
		}
		//Нашли не команду
		else if (t == -1)
		{
			errorCounter++;
			fprintf(stderr, "line %d: <ERROR> unexpected command: %s\n", lineCounter, name);
		}
		//Нашли команду с n аргументами
		else
		{
			//Ставим флаг
			readingCommandLine = 1;
			commandInfoInit(t, name);
		}
	}
	//Находимся в режиме чтения команды
	else
	{
		//И вдруг читаем еще команду
		if (t != -1)
		{
			//Условно сбросили флаг
			errorCounter++;
			fprintf(stderr, "line %d: <ERROR> expected argument but recieved command\n", lineCounter);
			//Снова подняли флаг и читаем
			commandInfoInit(t, name);			
		}
		//Читаем имя регистра
		else if (isRegisterName(name) == 1)
		{
			//Преобразуем в число и сохраним в аргументы
			numArgAnalyze(argConvert(name));
		}
		//А такого случая быть не должно
		else
		{
			readingCommandLine = 0;
			errorCounter++;
			fprintf(stderr, "line %d: <ERROR> wrong symbolic name recieved: %s\n", lineCounter, name);
		}
	}
}