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
	CMC,
};	

/*Типы аргументов*/
enum ARGTYPE
{
	NAME,
	VALUE
};

/*Описание команды:*/
typedef struct {
	int args;
	enum OPCODE opCode;
} commandInfo;

typedef struct {
	int val;
	char * str;
} variousInfo;	

/*Описание аргумента:*/
typedef struct {
	enum ARGTYPE argType;
	variousInfo * arg;/*Число либо строка в зависимости от типа*/
} argumentInfo;


	
#line 125 "test1.y"
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
#line 152 "y.tab.c"

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
    0,    0,    0,    2,    2,    2,    2,    2,    1,    1,
    4,    4,    6,    6,    7,    7,    8,    5,    3,    3,
    9,    9,    9,    9,
};
static const YYINT yylen[] = {                            2,
    3,    2,    1,    1,    2,    2,    3,    2,    1,    1,
    3,    1,    3,    1,    1,    1,    1,    1,    2,    1,
    2,    2,    2,    2,
};
static const YYINT yydefred[] = {                         0,
   18,   10,    0,    0,    9,    0,    0,    0,    0,    0,
    0,   19,    0,    1,    6,    0,    0,    0,    0,    0,
   15,   11,    0,   16,   17,    6,   21,   22,   23,   24,
    0,   13,
};
static const YYINT yydgoto[] = {                          3,
    4,    9,   10,    5,    6,   22,   23,   24,   25,
};
static const YYINT yysindex[] = {                      -257,
    0,    0,    0, -260,    0, -250, -250, -260, -246, -260,
 -235,    0, -250,    0,    0, -250, -231, -229, -228, -227,
    0,    0, -250,    0,    0,    0,    0,    0,    0,    0,
 -235,    0,
};
static const YYINT yyrindex[] = {                         0,
    0,    0,    0,   15,    0,    9,    1,    2,   26,    0,
    0,    0,    6,    0,    0,    7,    0,    0,    0,    0,
    0,    0,   10,    0,    0,    0,    0,    0,    0,    0,
    0,    0,
};
static const YYINT yygindex[] = {                        27,
    0,   21,    5,    0,  -11,    4,    0,    0,    0,
};
#define YYTABLESIZE 274
static const YYINT yytable[] = {                         21,
   20,    4,    7,    8,    1,    8,    5,    2,   12,   14,
   11,   12,    7,   15,    3,    1,    7,   15,    2,   21,
   26,   17,   18,   19,   20,    2,    1,   31,   13,   27,
   16,   28,   29,   30,   32,   14,    0,    0,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   20,   20,   20,
   20,    0,   20,    4,   20,   20,    4,    8,    5,    0,
    8,    5,   12,   14,
};
static const YYINT yycheck[] = {                         11,
    0,    0,  263,  264,  262,    0,    0,  265,    0,    0,
    6,    7,  263,    9,    0,  262,  263,   13,  265,   31,
   16,  257,  258,  259,  260,    0,  262,   23,    8,  261,
   10,  261,  261,  261,   31,    9,   -1,   -1,   -1,   -1,
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
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,  259,
  260,   -1,  262,  262,  264,  265,  265,  262,  262,   -1,
  265,  265,  264,  264,
};
#define YYFINAL 3
#ifndef YYDEBUG
#define YYDEBUG 1
#endif
#define YYMAXTOKEN 265
#define YYUNDFTOKEN 277
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
"BINARY","VALUE","ID","DIVIDER","NEWLINE","LABEL",0,0,0,0,0,0,0,0,0,0,0,
"illegal-symbol",
};
static const char *const yyrule[] = {
"$accept : text",
"text : line newLine text",
"text : line newLine",
"text : line",
"newLine : NEWLINE",
"newLine : divider newLine",
"newLine : newLine divider",
"newLine : divider newLine divider",
"newLine : NEWLINE newLine",
"line : command",
"line : LABEL",
"command : id divider arguments",
"command : id",
"arguments : arg divider arguments",
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
#line 179 "test1.y"
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

int toDecimalConvert(int base, char * num) {
	
	return 0;
	/*TODO конвертер по разным основаниям в 10-чную систему*/
}

int toBaseConvert(int base, int num) {
	/*Надо ли это нам? Как будем хранить не десятичные числа? Мб вообще в строках? А работать с 10-м представлением?*/
	/*TODO конвертер по разным основаниям в 8-чную систему*/
}

int inArray(char * a[], char * arg) {
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
				return inArray(a, arg);
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
				return inArray(a, arg);
			}
		case 2:
			{
				char * a[] =
					{"MOV", "MVI", "LXI", "LXISP", 
					 "LDA", "STA", "LHLD", "SHLD", 
					 "JMP", "CALL", "JNZ", "JZ", 
					 "JNC", "JC", "JPO", "JPE", 
					 "JP", "JM", "CNZ", "CZ", 
					 "CNC", "CC", "CPO", "CPE", 
					 "CP", "CM"};
				return inArray(a, arg);
			}
		default:
			printf("<ERROR> wrong argument amount\n");
			return 0;
	}
}

//После прогонки тестов можно убрать отладочную ошибку
//и переписать return в цикл for
//Встречена команда?
int isCommandName(char * arg) {
	int result = 0;
	//Цикл по возможному количеству арг-в
	for (int i = 0; i <= 2; i++)
	{
		result+=isNArgCommand(arg, i);
	}
	if (result > 1) 
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
		return 0;
	}
}

/*Full command list*/
/*XCHG|XTHL|SPHL|PCHL|RET|RNZ|RZ|RNC|RC|RPO|RPE|RP|RM|EI|DI|NOP|HLT|DAA|CMA|RLC|RRC|RAL|RAR|STC|CMC;

LDAX|STAX|IN|OUT|PUSH|POP|PCHL|RST|ADD|ADI|ADC|ACI|SUB|SUI|SBB|SBI|CMP|CPI|INR|INX|DCR|DCX|DAD|ANA|ANI|XRA|XRI|ORA|ORI;

MOV|MVI|LXI|LXISP|LDA|STA|LHLD|SHLD|JMP|CALL|JNZ|JZ|JNC|JC|JPO|JPE|JP|JM|CNZ|CZ|CNC|CC|CPO|CPE|CP|CM;*/
#line 530 "y.tab.c"

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
#line 144 "test1.y"
	{}
break;
case 2:
#line 145 "test1.y"
	{}
break;
case 3:
#line 146 "test1.y"
	{}
break;
case 4:
#line 148 "test1.y"
	{}
break;
case 5:
#line 149 "test1.y"
	{}
break;
case 6:
#line 150 "test1.y"
	{}
break;
case 7:
#line 151 "test1.y"
	{}
break;
case 8:
#line 152 "test1.y"
	{}
break;
case 9:
#line 154 "test1.y"
	{ printf("line parsed\n");}
break;
case 10:
#line 155 "test1.y"
	{ printf("line parsed\n");}
break;
case 11:
#line 157 "test1.y"
	{}
break;
case 12:
#line 158 "test1.y"
	{}
break;
case 13:
#line 160 "test1.y"
	{}
break;
case 15:
#line 163 "test1.y"
	{ if (isRegisterName(yystack.l_mark[0].str) == 1) printf("found\n");}
break;
case 16:
#line 164 "test1.y"
	{}
break;
case 17:
#line 166 "test1.y"
	{/*Потом отсюда расширим арифметику*/}
break;
case 18:
#line 168 "test1.y"
	{ printf("%s\n", yystack.l_mark[0].str); }
break;
case 19:
#line 170 "test1.y"
	{}
break;
case 20:
#line 171 "test1.y"
	{}
break;
case 21:
#line 173 "test1.y"
	{ yyval.val = toDecimalConvert(10, yystack.l_mark[0].str); }
break;
case 22:
#line 174 "test1.y"
	{ yyval.val = toDecimalConvert(16, yystack.l_mark[0].str); }
break;
case 23:
#line 175 "test1.y"
	{ yyval.val = toDecimalConvert(8, yystack.l_mark[0].str); }
break;
case 24:
#line 176 "test1.y"
	{ yyval.val = toDecimalConvert(2, yystack.l_mark[0].str); }
break;
#line 824 "y.tab.c"
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
