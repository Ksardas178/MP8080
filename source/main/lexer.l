%{
#include <stdlib.h>
#include <string.h>
// #include "y.tab.h"
#include "parser.y.definitions.h"
#include <main/my.h>

//Global variables&flags
extern int lineCounter;

%}

%start sReadNum

%%
<INITIAL>\/\/.*					{/*Simple comments*/}

<INITIAL>[A-Z]+					{ yylval.str = yytext; return ID;}

<INITIAL>[a-zA-Z_]+[a-zA-Z0-9_]*:	{ yylval.str = yytext; return LABEL;}
<sReadNum>[0-9a-fA-F]+			{
									yylval.str = yytext;
									//printf ("read num: %s\n", yytext);
									BEGIN INITIAL;
								 	return VALUE;
								}
<sReadNum>.						{ printf("<ERROR> parsed smth not num\n"); }
<INITIAL>h[0-9a-fA-F]+   		{
									yyless(1);
									BEGIN sReadNum;
									return HEXADECIMAL;
								}
<INITIAL>b[0-1]+   				{
									yyless(1);
									BEGIN sReadNum;
									return BINARY;

								}
<INITIAL>o[0-7]+   				{
									yyless(1);
									BEGIN sReadNum;
									return OCTAL;
								}
<INITIAL>d[0-9]+   				{
									yyless(1);
									BEGIN sReadNum;
									return DECIMAL;
								}
<INITIAL>[0-9]+   				{
									yyless(0);
									BEGIN sReadNum;
									return DECIMAL;
								}
<INITIAL>[ \t]+					{ return DIVIDER; }
<INITIAL>\n+					{
									lineCounter+=yyleng;
									return NEWLINE;
								}
<INITIAL>(.)	    			return yytext[0];
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
