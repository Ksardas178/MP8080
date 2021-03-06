%{
#include <stdlib.h>
#include <string.h>
// #include "y.tab.h"
#include "parser.y.definitions.h"
#include <main/my.h>

//Global variables&flags
extern int lineCounter;

%}

%start sReadNum sComment

%%
<INITIAL>\/\/.*					{/*Simple comments*/}
<INITIAL>"/*"					{ BEGIN sComment;	}

<sComment>[^*\n]*				{ /* eat anything that's not a '*' */ 	}
<sComment>"*"+[^*/\n]			{ /* eat up '*'s not followed by '/'s */}
<sComment>\n					{ lineCounter++;	}
<sComment>"*"+"/"				{ BEGIN INITIAL;	}

<INITIAL>[A-Z_]+[A-Z0-9_]*		{ yylval.str = yytext; return ID; }

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
<INITIAL>\*						{ return MULT; 	}
<INITIAL>\/						{ return DIV; 	}
<INITIAL>%						{ return MOD;	}
<INITIAL>\+\+					{ return INC; 	}
<INITIAL>\+						{ return PLUS; 	}
<INITIAL>--						{ return DEC;	}
<INITIAL>-						{ return MINUS; }
<INITIAL>\(						{ return OPEN; 	}
<INITIAL>\)						{ return CLOSE; }
<INITIAL><<						{ return SHL; 	}
<INITIAL>>>						{ return SHR; 	}
<INITIAL>[\n\r]					{ lineCounter++;}
<INITIAL>[ \t]+					{}
<INITIAL>(.)	    			return yytext[0];
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
