%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "my.h"
	
//Global variables&flags
extern lineCounter;
	
%}

%%
\/\/.*					{/*Simple comments*/}

[A-Z]+					{ yylval.str = yytext; return ID;}

[a-zA-Z_]+[a-zA-Z0-9_]*:	{ yylval.str = yytext; return LABEL;}
[0-7]    				{ 	
							yylval.val = atoi(yytext);
							return NUM; 			
						}
[ \t]+					{ return DIVIDER; }
\n						{ 
							lineCounter++;
							return yytext[0];
						}
(.)	    				return yytext[0];
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
