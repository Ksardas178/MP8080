#define DECIMAL 257
#define HEXADECIMAL 258
#define OCTAL 259
#define BINARY 260
#define VALUE 261
#define ID 262
#define DIVIDER 263
#define NEWLINE 264
#define LABEL 265
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
extern YYSTYPE yylval;
