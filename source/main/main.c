#include <stdio.h>

// To trace parser, set yydebug = 1
// ... and call yacc with options -vtd
// To not trace, set yydebug = 0
// ... and call yacc with option -d
extern int yydebug;

extern int yyparse();

void yyerror(const char * s) {
	fprintf(stderr, "Error > %s\n", s);
}

int main() {
	yydebug = 0;
	return yyparse();
}
