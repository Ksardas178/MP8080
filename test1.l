%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "my.h"
	
//Global variables&flags
extern int lineCounter;
	
%}

%%
\/\/.*					{/*Simple comments*/}

[A-Z]+					{ yylval.str = yytext; return ID;}

[a-zA-Z_]+[a-zA-Z0-9_]*:	{ yylval.str = yytext; return LABEL;}

h[0-9a-fA-F]+   		{ 	
							yylval.str = yytext;
							return HEXADECIMAL;			
						}
b[0-1]+   				{ 	
							yylval.str = yytext;
							return BINARY;		
						}
o[0-7]+   				{ 	
							yylval.str = yytext;
							return OCTAL;			
						}
d*[0-9]+   				{ 	
							yylval.val = atoi(yytext);
							return DECIMAL;			
						}
[ \t]+					{ return DIVIDER; }
\n+						{ 
							lineCounter+=yyleng;
							return NEWLINE;
						}
(.)	    				return yytext[0];
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
