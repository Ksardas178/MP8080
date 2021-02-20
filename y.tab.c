/* original parser id follows */
/* yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93" */
/* (use YYMAJOR/YYMINOR for ifdefs dependent on parser version) */

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20140715

#define YYEMPTY        (-1)
#define yyclearin      (yychar = YYEMPTY)
#define yyerrok        (yyerrflag = 0)
#define YYRECOVERING() (yyerrflag != 0)
#define YYENOMEM       (-2)
#define YYEOF          0
#define YYPREFIX "yy"

#define YYPURE 0

#line 3 "test1.y"
#include <malloc.h>
#include "my.h"
#include <string.h>
#include <stdio.h>

/*Global variables&flags*/
int lineCounter = 1;	
int columnCounter = 0;
	
/*Типы операций*/
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

/*Буфер хранения сообщений о ходе анализа функции*/
typedef struct {
	int size;
	int stored;
	message *p;
} analyzeBuffer;	
	
/*Описание команды:*/
typedef struct {
	int expectedArgs;
	int args;
	char opName[10];
	int	arg1;
	int arg2;
} operationDescription;
	
/*Информация об анализируемой операции*/
operationDescription opDesc;
analyzeBuffer analyzeBuf;
char stringBuffer[MSG_LENGTH];
	
/*Флаги*/
int readingCommandLine = 0;
int inProgram = 0;
enum OUTPUTMODE globalMode = M_BINARY;
	
#line 137 "test1.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
	int val;
	char * str;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 164 "y.tab.c"

/* compatibility with bison */
#ifdef YYPARSE_PARAM
/* compatibility with FreeBSD */
# ifdef YYPARSE_PARAM_TYPE
#  define YYPARSE_DECL() yyparse(YYPARSE_PARAM_TYPE YYPARSE_PARAM)
# else
#  define YYPARSE_DECL() yyparse(void *YYPARSE_PARAM)
# endif
#else
# define YYPARSE_DECL() yyparse(void)
#endif

/* Parameters sent to lex. */
#ifdef YYLEX_PARAM
# define YYLEX_DECL() yylex(void *YYLEX_PARAM)
# define YYLEX yylex(YYLEX_PARAM)
#else
# define YYLEX_DECL() yylex(void)
# define YYLEX yylex()
#endif

/* Parameters sent to yyerror. */
#ifndef YYERROR_DECL
#define YYERROR_DECL() yyerror(const char *s)
#endif
#ifndef YYERROR_CALL
#define YYERROR_CALL(msg) yyerror(msg)
#endif

extern int YYPARSE_DECL();

#define DECIMAL 257
#define HEXADECIMAL 258
#define OCTAL 259
#define BINARY 260
#define VALUE 261
#define ID 262
#define DIVIDER 263
#define NEWLINE 264
#define LABEL 265
#define YYERRCODE 256
typedef short YYINT;
static const YYINT yylhs[] = {                           -1,
    0,    1,    1,    1,    1,    1,    1,    2,    2,    2,
    2,    2,    3,    3,    5,    5,    5,    7,    7,    7,
    8,    8,    9,    6,    4,    4,   10,   10,   10,   10,
};
static const YYINT yylen[] = {                            2,
    1,    4,    3,    3,    2,    2,    1,    1,    2,    2,
    3,    2,    1,    1,    3,    2,    1,    3,    2,    1,
    1,    1,    1,    1,    2,    1,    2,    2,    2,    2,
};
static const YYINT yydefred[] = {                         0,
   24,    0,    0,   14,    0,    1,    0,    0,    0,   13,
    0,   25,    0,    0,   10,    0,    0,    0,    0,    3,
    0,   10,    0,    0,    0,    0,   21,   15,    0,   22,
   23,    2,   27,   28,   29,   30,    0,   18,
};
static const YYINT yydgoto[] = {                          5,
    6,    7,    8,    9,   10,   11,   28,   29,   30,   31,
};
static const YYINT yysindex[] = {                      -216,
    0, -263, -256,    0,    0,    0, -212, -256, -256,    0,
 -263,    0, -263, -256,    0, -216, -263, -220, -216,    0,
 -256,    0, -250, -249, -246, -245,    0,    0, -263,    0,
    0,    0,    0,    0,    0,    0, -220,    0,
};
static const YYINT yyrindex[] = {                         0,
    0,    1,   10,    0,    0,    0,    0,   20,    0,    0,
    4,    0,    5,   24,    0,   26,    9,   17,   28,    0,
   14,    0,    0,    0,    0,    0,    0,    0,   13,    0,
    0,    0,    0,    0,    0,    0,   19,    0,
};
static const YYINT yygindex[] = {                         0,
  -13,   22,   15,   16,    0,  -16,   -3,    0,    0,    0,
};
#define YYTABLESIZE 283
static const YYINT yytable[] = {                          2,
   26,   27,   20,   17,   12,   32,    2,    3,    9,    8,
   33,   34,   20,   10,   35,   36,   16,   12,   19,    7,
   27,   14,   15,    6,   13,    5,   18,    4,   15,   16,
   17,   21,   22,   38,   21,   19,   23,   24,   25,   26,
    0,    1,   17,    0,   37,    1,    2,    3,    4,    1,
    2,    0,    4,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   26,   26,   26,
   26,    0,   26,    0,   26,   26,   12,   17,   12,   12,
    9,    8,    9,    9,    8,   10,   20,    0,   10,   16,
   16,   19,   19,
};
static const YYINT yycheck[] = {                        263,
    0,   18,   16,    0,    0,   19,  263,  264,    0,    0,
  261,  261,    0,    0,  261,  261,    0,    2,    0,    0,
   37,    7,    7,    0,    3,    0,   11,    0,   13,    8,
    9,   16,   17,   37,   19,   14,  257,  258,  259,  260,
   -1,  262,   21,   -1,   29,  262,  263,  264,  265,  262,
  263,   -1,  265,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,  259,
  260,   -1,  262,   -1,  264,  265,  262,  264,  264,  265,
  262,  262,  264,  265,  265,  262,  264,   -1,  265,  263,
  264,  263,  264,
};
#define YYFINAL 5
#ifndef YYDEBUG
#define YYDEBUG 1
#endif
#define YYMAXTOKEN 265
#define YYUNDFTOKEN 278
#define YYTRANSLATE(a) ((a) > YYMAXTOKEN ? YYUNDFTOKEN : (a))
#if YYDEBUG
static const char *const yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"DECIMAL","HEXADECIMAL","OCTAL",
"BINARY","VALUE","ID","DIVIDER","NEWLINE","LABEL",0,0,0,0,0,0,0,0,0,0,0,0,
"illegal-symbol",
};
static const char *const yyrule[] = {
"$accept : _text",
"_text : text",
"text : newLine line newLine text",
"text : line newLine text",
"text : newLine line newLine",
"text : line newLine",
"text : newLine line",
"text : line",
"newLine : NEWLINE",
"newLine : divider newLine",
"newLine : newLine divider",
"newLine : divider newLine divider",
"newLine : NEWLINE newLine",
"line : command",
"line : LABEL",
"command : id divider arguments",
"command : id divider",
"command : id",
"arguments : arg divider arguments",
"arguments : arg divider",
"arguments : arg",
"arg : id",
"arg : ariphmetic",
"ariphmetic : num",
"id : ID",
"divider : DIVIDER divider",
"divider : DIVIDER",
"num : DECIMAL VALUE",
"num : HEXADECIMAL VALUE",
"num : OCTAL VALUE",
"num : BINARY VALUE",

};
#endif

int      yydebug;
int      yynerrs;

int      yyerrflag;
int      yychar;
YYSTYPE  yyval;
YYSTYPE  yylval;

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 10000
#define YYMAXDEPTH  10000
#endif
#endif

#define YYINITSTACKSIZE 200

typedef struct {
    unsigned stacksize;
    YYINT    *s_base;
    YYINT    *s_mark;
    YYINT    *s_last;
    YYSTYPE  *l_base;
    YYSTYPE  *l_mark;
} YYSTACKDATA;
/* variables for the parser stack */
static YYSTACKDATA yystack;
#line 206 "test1.y"
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
#line 756 "y.tab.c"

#if YYDEBUG
#include <stdio.h>		/* needed for printf */
#endif

#include <stdlib.h>	/* needed for malloc, etc */
#include <string.h>	/* needed for memset */

/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int yygrowstack(YYSTACKDATA *data)
{
    int i;
    unsigned newsize;
    YYINT *newss;
    YYSTYPE *newvs;

    if ((newsize = data->stacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return YYENOMEM;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = (int) (data->s_mark - data->s_base);
    newss = (YYINT *)realloc(data->s_base, newsize * sizeof(*newss));
    if (newss == 0)
        return YYENOMEM;

    data->s_base = newss;
    data->s_mark = newss + i;

    newvs = (YYSTYPE *)realloc(data->l_base, newsize * sizeof(*newvs));
    if (newvs == 0)
        return YYENOMEM;

    data->l_base = newvs;
    data->l_mark = newvs + i;

    data->stacksize = newsize;
    data->s_last = data->s_base + newsize - 1;
    return 0;
}

#if YYPURE || defined(YY_NO_LEAKS)
static void yyfreestack(YYSTACKDATA *data)
{
    free(data->s_base);
    free(data->l_base);
    memset(data, 0, sizeof(*data));
}
#else
#define yyfreestack(data) /* nothing */
#endif

#define YYABORT  goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR  goto yyerrlab

int
YYPARSE_DECL()
{
    int yym, yyn, yystate;
#if YYDEBUG
    const char *yys;

    if ((yys = getenv("YYDEBUG")) != 0)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = YYEMPTY;
    yystate = 0;

#if YYPURE
    memset(&yystack, 0, sizeof(yystack));
#endif

    if (yystack.s_base == NULL && yygrowstack(&yystack) == YYENOMEM) goto yyoverflow;
    yystack.s_mark = yystack.s_base;
    yystack.l_mark = yystack.l_base;
    yystate = 0;
    *yystack.s_mark = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
        {
            goto yyoverflow;
        }
        yystate = yytable[yyn];
        *++yystack.s_mark = yytable[yyn];
        *++yystack.l_mark = yylval;
        yychar = YYEMPTY;
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;

    YYERROR_CALL("syntax error");

    goto yyerrlab;

yyerrlab:
    ++yynerrs;

yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yystack.s_mark]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yystack.s_mark, yytable[yyn]);
#endif
                if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
                {
                    goto yyoverflow;
                }
                yystate = yytable[yyn];
                *++yystack.s_mark = yytable[yyn];
                *++yystack.l_mark = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yystack.s_mark);
#endif
                if (yystack.s_mark <= yystack.s_base) goto yyabort;
                --yystack.s_mark;
                --yystack.l_mark;
            }
        }
    }
    else
    {
        if (yychar == YYEOF) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = YYEMPTY;
        goto yyloop;
    }

yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    if (yym)
        yyval = yystack.l_mark[1-yym];
    else
        memset(&yyval, 0, sizeof yyval);
    switch (yyn)
    {
case 1:
#line 156 "test1.y"
	{ printAnalyzeBuf(); }
break;
case 2:
#line 158 "test1.y"
	{}
break;
case 3:
#line 159 "test1.y"
	{}
break;
case 4:
#line 160 "test1.y"
	{}
break;
case 5:
#line 161 "test1.y"
	{}
break;
case 6:
#line 162 "test1.y"
	{}
break;
case 7:
#line 163 "test1.y"
	{}
break;
case 8:
#line 165 "test1.y"
	{}
break;
case 9:
#line 166 "test1.y"
	{}
break;
case 10:
#line 167 "test1.y"
	{}
break;
case 11:
#line 168 "test1.y"
	{}
break;
case 12:
#line 169 "test1.y"
	{}
break;
case 13:
#line 171 "test1.y"
	{ 
										/*printf("line parsed\n");*/
										getCommand(globalMode);
									 	readingCommandLine = 0;
									}
break;
case 14:
#line 176 "test1.y"
	{ 
										/*printf("line parsed\n");*/
										getCommand(globalMode);
								 		readingCommandLine = 0;
									}
break;
case 15:
#line 182 "test1.y"
	{}
break;
case 16:
#line 183 "test1.y"
	{}
break;
case 17:
#line 184 "test1.y"
	{}
break;
case 18:
#line 186 "test1.y"
	{}
break;
case 19:
#line 187 "test1.y"
	{}
break;
case 21:
#line 190 "test1.y"
	{}
break;
case 22:
#line 191 "test1.y"
	{ numArgAnalyze(yystack.l_mark[0].val); }
break;
case 23:
#line 193 "test1.y"
	{/*Потом отсюда расширим арифметику*/}
break;
case 24:
#line 195 "test1.y"
	{ operationAnalyze(yystack.l_mark[0].str); }
break;
case 25:
#line 197 "test1.y"
	{}
break;
case 26:
#line 198 "test1.y"
	{}
break;
case 27:
#line 200 "test1.y"
	{ yyval.val = toDecimalConvert(10, yystack.l_mark[0].str); }
break;
case 28:
#line 201 "test1.y"
	{ yyval.val = toDecimalConvert(16, yystack.l_mark[0].str); }
break;
case 29:
#line 202 "test1.y"
	{ yyval.val = toDecimalConvert(8, yystack.l_mark[0].str); }
break;
case 30:
#line 203 "test1.y"
	{ yyval.val = toDecimalConvert(2, yystack.l_mark[0].str); }
break;
#line 1082 "y.tab.c"
    }
    yystack.s_mark -= yym;
    yystate = *yystack.s_mark;
    yystack.l_mark -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yystack.s_mark = YYFINAL;
        *++yystack.l_mark = yyval;
        if (yychar < 0)
        {
            if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
            if (yydebug)
            {
                yys = yyname[YYTRANSLATE(yychar)];
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == YYEOF) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yystack.s_mark, yystate);
#endif
    if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
    {
        goto yyoverflow;
    }
    *++yystack.s_mark = (YYINT) yystate;
    *++yystack.l_mark = yyval;
    goto yyloop;

yyoverflow:
    YYERROR_CALL("yacc stack overflow");

yyabort:
    yyfreestack(&yystack);
    return (1);

yyaccept:
    yyfreestack(&yystack);
    return (0);
}
