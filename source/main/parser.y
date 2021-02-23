//=====================================================
%{
#include <malloc.h>
#include <main/my.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

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

//Флаги и глобальные переменные
int readingCommandLine = 0;
int inProgram = 0;
int lineCounter = 1;
int columnCounter = 1;
enum OUTPUTMODE globalMode = M_BINARY;

//Предописания
void printAnalyzeBuf();
void operationAnalyze(char * name);
void numArgAnalyze(int arg);
void getCommand(enum OUTPUTMODE mode);
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

_text	: text	{ getCommand(globalMode); printAnalyzeBuf(); }

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
void storeAnalizeBuf(char * msg) {
	analyzeBuf.stored++;
	if (analyzeBuf.stored > analyzeBuf.size)
	{
		analyzeBuf.size+=ANALYZE_BUF_ALLOCATE_SIZE;
		analyzeBuf.p = (message*)realloc(analyzeBuf.p, analyzeBuf.size * sizeof(message));
	}
	strcpy(analyzeBuf.p[analyzeBuf.stored-1].content, msg);
}

//Сохранение числа в заданной СС в буфер трансляции
void storeNumToAnalizeBuffer(int num, int base, int digits){
	char temp[MSG_LENGTH];
	toBaseConvert(num, base, digits);
	sprintf(temp, "%s\n", stringBuffer);
	storeAnalizeBuf(temp);
}

void storeBytesToAnalyzeByffer(int * a[], int l, int base, int digits) {
	for (int i = 0; i < l; i++)
	{
		storeNumToAnalizeBuffer(a[i], base, digits);
	}
}

//Внутренняя функция трансляции в двоичное представление
void internalBinaryStore() {
	const int base = 2;
	const int digits = 8;
	const int arg1 = opDesc.arg1;
	const int arg2 = opDesc.arg2;
	int * a[10];
	int l;
	if (strcmp(opDesc.opName, "MOV") == 0)
	{
		a[0] = 1;
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
	}
	else if (strcmp(opDesc.opName, "MVI") == 0)
	{
		a[0] = 0;
		a[1] = arg1;
		a[2] = arg2;
		l = 3;
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
	storeBytesToAnalyzeByffer(a, l, base, digits);
}

//Запись операции в буфер трансляции
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
					printf("line %d: <ERROR> too much args\n", lineCounter);
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
			printf("line %d: <ERROR> unrecognized mode\n", lineCounter);
			break;
	}
}

//Инициализация буфера трансляции
void analyzeBufInit() {
	free(analyzeBuf.p);
	analyzeBuf.stored = 0;
	analyzeBuf.size = ANALYZE_BUF_INIT_SIZE;
	analyzeBuf.p = (message *)calloc(ANALYZE_BUF_INIT_SIZE, sizeof(message));
}

//Вывод буфера трансляции
void printAnalyzeBuf() {
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
	//printf("line %d: called with arg %d\n", lineCounter, arg);
	//Проверка на ожидаемое количество аргументов
	const int expected = opDesc.expectedArgs;
	if (opDesc.args >= expected)
	{
		printf("line %d: <ERROR> expected %d argument(s)\n", lineCounter, expected);
	}
	//Если аргумент отрицательный
	else if (arg < 0)
	{
		printf("line %d: <ERROR> expected non negative argument\n", lineCounter);
	}
	//Если получили двухбайтный аргумент
	else if (arg >= 8)
	{
		//printf(">=8. Get %d\n", arg);
		printf("line %d: <WARNING> argument adapted to match %d 8-bit value(s)\n", lineCounter, expected);
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
				switch (expected)
				{
					case 1:
						opDesc.arg1 = arg;
						break;
					case 2:
						opDesc.arg2 = arg;
						break;
					default:
						printf("line %d: <ERROR> too much args expected\n", lineCounter);
						break;
				}
				break;
			case 2:
				//Сдвигаем аргументы
				opDesc.arg1 = opDesc.arg2;
				opDesc.arg2 = arg;
				break;
			default:
				printf("line %d: <ERROR> too much args in operation\n", lineCounter);
				break;
		}
	}
}

//Добавление в описание команды числового аргумента
void numArgAnalyze(int arg) {
	if (readingCommandLine == 1)
	{
		addOpDescArgument(arg);
	}
	else
	{
		printf("line %d: <ERROR> unexpected numeric argument\n", lineCounter);
	}
}

//Содержит ли массив длины l аргумент?
int inArray(char * a[], char * arg, int l) {
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
			printf("line %d: <ERROR> wrong argument amount\n", lineCounter);
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
		printf ("line %d: <ERROR> command duplicates in command list\n", lineCounter);
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
		printf("line %d: <ERROR>: unexpected argument\n", lineCounter);
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
	//Только вошли в программу?
	if (inProgram == 0)
	{
		analyzeBufInit();
		inProgram = 1;
	}
	//Уже читаем команду? А аргументов не много захапали?
	if (readingCommandLine == 1 && opDesc.args >= opDesc.expectedArgs) 
	{
		//Много. Записываем команду (внутри обнуляется флаг)
		//printf("line %d: get cmd with %d args (%d, %d)\n", lineCounter-1, opDesc.args, opDesc.arg1, opDesc.arg2);
		getCommand(globalMode);
	}	
	//Проверяем, читаем уже команду или пока нет
	if (readingCommandLine == 0)
	{
		int t = isCommandName(name);
		//Команда есть такая?
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
		//Нет такой команды. Ошибка
		else
		{
			printf("line %d: <ERROR> wrong command recieved\n", lineCounter);
		}
	}
	//Не все аргументы получили пока. А имя-то такое найдется?
	else if (isRegisterName(name) == 1)
	{
		addOpDescArgument(argConvert(name));
	}
	//Нет такого имени. Ловите ошибку.
	else
	{
		printf("line %d: <ERROR> wrong register name recieved\n", lineCounter);
	}
}