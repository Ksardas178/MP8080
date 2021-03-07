#include <stdio.h>
#include <string.h>

// To trace parser, set yydebug = 1
// ... and call yacc with options -vtd
// To not trace, set yydebug = 0
// ... and call yacc with option -d
extern int yydebug;

extern int yyparse();

void yyerror(const char * s) {
	fprintf(stderr, "Error > %s\n", s);
}

extern int outputBase;
extern int showOpNames;

int main(int argc, char * argv[]) {
	for (int it = 0; it < argc; it++) {
		if (strcmp(argv[it], "--octal") == 0) {
			outputBase = 8;
		} else if (strcmp(argv[it], "--opnames") == 0) {
			showOpNames = 1;
		}
	}

	yydebug = 0;
	return yyparse();
}
