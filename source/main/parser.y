//=====================================================
%{
#include <malloc.h>
#include <main/my.h>
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
	int	arg1;
	int arg2;
} operationDescription;

//Информация об анализируемой операции
operationDescription opDesc;
analyzeBuffer analyzeBuf;
char stringBuffer[MSG_LENGTH];

//Флаги
int readingCommandLine = 0;
int inProgram = 0;
enum OUTPUTMODE globalMode = M_CHECK;

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
%token	MULT
%token	DIV
%token	MOD
%token	PLUS
%token	MINUS
%token	INC
%token	DEC
%token	OPEN
%token	CLOSE

%start _text

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

_text	: text	{ printAnalyzeBuf(); }

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
	| ariphmetic5	{ numArgAnalyze($<val>1); }

ariphmetic5	: ariphmetic5 unstrDiv MINUS unstrDiv ariphmetic4	{ $<val>$ = $<val>1 - $<val>5; 	}
			| ariphmetic5 unstrDiv PLUS unstrDiv ariphmetic4	{ $<val>$ = $<val>1 + $<val>5; 	}
			| ariphmetic4										{ $<val>$ = $<val>1; 			}
			
ariphmetic4	: ariphmetic4 unstrDiv MULT unstrDiv ariphmetic3	{ $<val>$ = $<val>1 * $<val>5; 	}
			| ariphmetic4 unstrDiv DIV 	unstrDiv ariphmetic3	{ $<val>$ = $<val>1 / $<val>5; 	}
			| ariphmetic4 unstrDiv MOD 	unstrDiv ariphmetic3	{ $<val>$ = $<val>1 % $<val>5; 	}
			| ariphmetic3										{ $<val>$ = $<val>1; 			}

ariphmetic3	: INC unstrDiv ariphmetic3	{ $<val>$ = $<val>3 + 1;	}
			| DEC unstrDiv ariphmetic3	{ $<val>$ = $<val>3 - 1;	}
			| ariphmetic2				{ $<val>$ = $<val>1;		}

ariphmetic2	: ariphmetic2 unstrDiv INC	{ $<val>$ = $<val>1 + 1;	}
			| ariphmetic2 unstrDiv DEC	{ $<val>$ = $<val>1 - 1;	}
			| ariphmetic1				{ $<val>$ = $<val>1;		}

ariphmetic1	: OPEN unstrDiv ariphmetic5 unstrDiv CLOSE	{ $<val>$ = $<val>3;	}
			| num										{ $<val>$ = $<val>1;	}

id	: ID	{ operationAnalyze($1); }

divider	: DIVIDER divider 	{}
		| DIVIDER			{}

unstrDiv: DIVIDER	{}
		|			{}

num	: DECIMAL VALUE		{ $<val>$ = toDecimalConvert(10, $2); }
	| HEXADECIMAL VALUE	{ $<val>$ = toDecimalConvert(16, $2); }
	| OCTAL	VALUE		{ $<val>$ = toDecimalConvert(8, $2); }
	| BINARY VALUE		{ $<val>$ = toDecimalConvert(2, $2); }


%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


void toBaseConvert(int num, int base, int digits) {
	for (int i = digits-1; i >= 0; i-=1)
	{
		stringBuffer[i] = num % base + '0';
		num = num / base;
	}
	stringBuffer[digits] = '\0';
}

void storeAnalizeBuf(char * msg) {
	analyzeBuf.stored++;
	if (analyzeBuf.stored > analyzeBuf.size)
	{
		analyzeBuf.size+=ANALYZE_BUF_ALLOCATE_SIZE;
		analyzeBuf.p = (message*)realloc(analyzeBuf.p, analyzeBuf.size * sizeof(message));
	}
	strcpy(analyzeBuf.p[analyzeBuf.stored-1].content, msg);
}

void storeNumToAnalizeBuffer(int num, int base, int digits){
	char temp[MSG_LENGTH];
	toBaseConvert(num, base, digits);
	sprintf(temp, "%s\n", stringBuffer);
	storeAnalizeBuf(temp);
}

internalBinaryStore() {
	const int base = 2;
	const int digits = 8;
	const int arg1 = opDesc.arg1;
	const int arg2 = opDesc.arg2;
	if (strcmp(opDesc.opName, "MOV") == 0)
	{
		storeNumToAnalizeBuffer(1, base, digits);
		storeNumToAnalizeBuffer(arg1, base, digits);
		storeNumToAnalizeBuffer(arg2, base, digits);
	}
	else if (strcmp(opDesc.opName, "MVI") == 0)
	{
		storeNumToAnalizeBuffer(0, base, digits);
		storeNumToAnalizeBuffer(arg1, base, digits);
		storeNumToAnalizeBuffer(arg2, base, digits);
	}
	else if (strcmp(opDesc.opName, "LXI") == 0)
	{

	}
	else if (strcmp(opDesc.opName, "LDA") == 0)
	{

	}
	else if (strcmp(opDesc.opName, "LDAX") == 0)
	{

	}
	else if (strcmp(opDesc.opName, "STA") == 0)
	{

	}
	else if (strcmp(opDesc.opName, "STAX") == 0)
	{

	}
}

void getCommand(enum OUTPUTMODE mode) {
	readingCommandLine = 0;
	char temp[MSG_LENGTH];
	switch (mode)
	{
		case M_CHECK:
			switch (opDesc.expectedArgs)
			{
				case 1:
					sprintf(temp, "%s %d\n", opDesc.opName, opDesc.arg1);
					storeAnalizeBuf(temp);
					break;
				case 2:
					sprintf(temp, "%s %d %d\n", opDesc.opName, opDesc.arg1, opDesc.arg2);
					storeAnalizeBuf(temp);
					break;
				default:
					printf("<ERROR> too much args");
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
			printf("<ERROR> unrecognized mode");
			break;
	}
}

void analyzeBufInit() {
	free(analyzeBuf.p);
	analyzeBuf.stored = 0;
	analyzeBuf.size = ANALYZE_BUF_INIT_SIZE;
	analyzeBuf.p = (message *)calloc(ANALYZE_BUF_INIT_SIZE, sizeof(message));
}

void printAnalyzeBuf() {
	printf("\n\x1b[30;1mCode analysis results:\n\x1b[0m______________________________\n");
	for (int i = 0; i < analyzeBuf.stored; i++)
	{
		toBaseConvert(i, 2, 8);
		printf("%s: %s", stringBuffer, analyzeBuf.p[i].content);
	}
	printf("\n");
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
}


//Инициализация переменной под новую операцию
void operationAnalyze(char * name) {
	//Только вошли в программу?
	if (inProgram == 0)
	{
		analyzeBufInit();
		inProgram = 1;
	}
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