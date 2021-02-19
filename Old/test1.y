//=====================================================
%{
#include <malloc.h>
#include "my.h"
#include <string.h>
#include <stdio.h>
	
/*Информация об одном операнде*/
typedef struct {
	char name[NAME_LENGTH];
	int type;
} tuple;

typedef struct {
	int elType;
	char element[NAME_LENGTH];
} stackElement;

typedef struct {
	int size;
	int stored;
	stackElement *p;
} stack;

typedef struct {
	char content[MSG_LENGTH];
} message;	

typedef struct {
	int size;
	int stored;
	message *p;
} analyzeBuffer;
	
/*Хранение используемых переменных (Си)*/
typedef struct {
	int stored;
	int size;
	tuple *p;	/*pointer to tuple*/
} variablesInfo;
	
/*Информация об операциях (трехоператорная запись)*/
typedef struct {
	int size;
	int stored;
	int allOperatorsCounter;
} threeOpNotation;

/*Общая информация о рассматриваемой функции*/
typedef struct {
	int retExists;
	int hasName;
	int operandType;
	int retType;
	char * name;
} functionAnalizeInfo;
	
functionAnalizeInfo fun;			/*function analize info*/
variablesInfo vars;					/*variables info*/
threeOpNotation simpleOperationData;/*operation info*/

/*Variables*/
int tempNamingCounter = 0;
int errorFlag = 0;
int initCompleted = 0;
	
/*Data storages*/
stack exprStack;
analyzeBuffer analyzeBuf;
	
/*Global variables&flags*/
int lineCounter = 1;	
int inReturnState = 0;
char * valueView = "<empty>";
%}
//=====================================================
%union
{
	int val;
	char * str;
}

%token 	<val>INT
%token 	<val>T_INT
%token 	<val>CHAR 
%token 	<val>T_CHAR 
%token 	<val>AND 
%token 	<val>OR 
%token 	<val>NOT 
%token 	<val>RETURN	
%token 	<str>NAME

%start _manyFunc													

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
_manyFunc: manyFunc	;

//######################################
//<MANY_FUNC>::=<FUNC>|<FUNC><MANY_FUNC>
//######################################
manyFunc: func			;
		| func manyFunc	;

//############################
//<FUNC>::=<HEADER>'{'<OPS>'}'	
//############################
func: header '{' ops '}'  	{ 
								/*Drop data init indicator*/
								initCompleted = 0; 
								if (!fun.retExists) {
									ECHO_MISSING_RETURN;
									errorFlag = 1;
								}
								if (errorFlag == 0) {
									/*Print function analyze results*/
									printSymTable();
									printAnalyzeBuf();
								} else ECHO_ERR;			
								/*Drop check results*/
								errorFlag = 0;
							}

//##############################################
//<HEADER>::=<PARAM>'('<PARAMS>')'|<PARAM>'('')'
//##############################################
header	: param '(' params ')'	;
		| param '(' ')'			;

//#####################################
//<PARAMS>::=<PARAM>|<PARAM>','<PARAMS>
//#####################################
params	: param				;	
		| param ',' params	;

//######################
//<PARAM>::=<TYPE><NAME>
//######################
param	: type NAME	{ initFunctionData($2, $<val>1); $<str>$ = $2; }

//#########################
//<TYPE>::=<T_INT>|<T_CHAR>
//#########################
type: T_INT		;
	| T_CHAR	;

//############################
//<OPS>::=<OP>';'|<OPS><OP>';'
//############################
ops	: op ';'		{ fun.operandType = 0; }
	| op ';' ops	{ fun.operandType = 0; }
	| 				{ ECHO_EMPTY_BODY; errorFlag = 1; }

//#####################################################
//<OP>::=<PARAM>|<PARAM>'='<EXPR>|<NAME>'='<EXPR>|<RET>
//#####################################################
op	: param				;
	| param '=' orExpr	{ 
							exprArrayAdd($<str>1, TYPE_OPERAND);
						 	addOp(EQUAL_OPCODE);		
						}
	| NAME '=' orExpr	{ 
							nameCheck($1); 
							exprArrayAdd($1, TYPE_OPERAND);
							addOp(EQUAL_OPCODE);
						}			
	| ret				{ 
							fun.retExists = 1; 
							fun.operandType = vars.p[0].type; 
							inReturnState = 0; 
							exprArrayAdd(fun.name, TYPE_OPERAND);
							addOp(EQUAL_OPCODE);
						}

//###########################################
//<RET>::=<RETURN>'('<EXPR>')'|<RETURN><EXPR>
//###########################################
ret	: RETURN '(' orExpr ')'	;
	| RETURN orExpr			;

//######################
//<VALUE>::=<INT>|<CHAR>
//######################
value	: INT	;
		| CHAR	;

//##########################
//<OPERAND>::=<NAME>|<VALUE>
//##########################
operand	: NAME	{ nameCheck($1); 			}
		| value { checkTypeMatch($<val>1); 	}

//##############################################
//<OR_EXPR>::=<OR_EXPR><OR><AND_EXPR>|<AND_EXPR>
//##############################################
orExpr	: orExpr OR andExpr		{ addOp($<val>2);  }
		| andExpr				;

//#################################################
//<AND_EXPR>::=<AND_EXPR><AND><NOT_EXPR>|<NOT_EXPR>
//#################################################
andExpr	: andExpr AND notExpr	{ addOp($<val>2); }
		| notExpr				;

//###########################################################
//<NOT_EXPR>::=<NOT><NOT><NOT_EXPR>|<NOT><NOT_EXPR>|<OPERAND>
//###########################################################
notExpr	: NOT NOT notExpr		;
		| NOT notExpr			{ addOp($<val>1); }	
		| operand				{ exprArrayAdd(valueView, TYPE_OPERAND); }

%%//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
void addVariableSafe(char * varName, int type){
	/*Check if already exists*/
	if (checkInVars(varName) != 0) {
		errorFlag = 1;
		fprintf(stderr, ">line %d: Variable redefinition '%s'\n", lineCounter, varName);
	} else {							
		addVariable(varName, type);
	}
}

void addVariable(char * varName, int type){
	/*Remember variable*/
	vars.stored++;
	if (vars.stored > vars.size) {
		/*Inc array size*/
		vars.size++;
		vars.p = (tuple*)realloc(vars.p, vars.stored * sizeof(tuple));
	}
	/*Add to array*/
	strcpy(vars.p[vars.stored-1].name, varName);
	vars.p[vars.stored-1].type = type;
}
	
void printFunName(char * fName) {
	fun.name = fName; 
	printf("\x1b[32;1m\nAnalysing fun named '%s':\n\x1b[0m", fun.name);	
	fun.hasName = 1; 
}
	
int nameCheck(char * varName){
	int type = checkInVars(varName);
	if (type == 0) {
		errorFlag = 1;
		fprintf(stderr, ">line %d: Undefined variable '%s'\n", lineCounter, varName);
	} else checkTypeMatch(type);
	return type;
}
	
int checkInVars(char * varName) {
	for (int i = 0; i < vars.stored; i++) {
		if (strcmp(vars.p[i].name, varName) == 0) return vars.p[i].type;
	}
	return 0;
}

void checkTypeMatch(int type){
	/*In return statement we should check if result matches function return type*/
	int refId = (inReturnState) ? fun.retType : fun.operandType;
	if (refId == 0) refId = type;
	/*Type mismatch case*/
	else if (refId != type) {
		errorFlag = 1;
		if (inReturnState) fprintf(stderr, ">line %d: Return type mismatch. ", lineCounter);
		else fprintf(stderr, ">line %d: Operand type mismatch. ", lineCounter);		
		switch(refId) {
			case INT_CODE:
				fprintf(stderr, "Expected 'int'\n"); break;
			case CHAR_CODE:
				fprintf(stderr, "Expected 'char'\n"); break;
			default:
				printf("ERROR: undefined operand type");
		}
	}
	/*Anyways it'll be dropped even if we were in return statement*/
	fun.operandType = refId;
}

void initFunctionData(char * varName, int type){
	addVariableSafe(varName, type); 
	if (!initCompleted) {
		/*Drop flags:*/
		inReturnState = 0;
		fun.retExists = 0;	
		fun.retType = type;
		//Display function name
		printFunName(varName);
		//Init section
		varArrayInit();
		exprArrayInit();
		analyzeBufInit();
		//Drop naming counters
		tempNamingCounter = 0;
		//Set init flag
		initCompleted = 1;
	} else fun.operandType = type;
}

char* getType(int type){
	switch(type) {
		case CHAR_CODE: return "char"; break;
		case INT_CODE: return "int"; break;
		case UNDEF_CODE: return "ndef"; break;
		default: return "ERROR: undefined type code";
	}
}

void printSymTable(){
	if (errorFlag == 0) {
		printf("\n\x1b[34;1mSymbol Table:\n\x1b[0m----------------------\n");
		printf("Addr\t|Type\t|Name\n");
		printf("0\t|%s\t|%s\n", getType(fun.retType), fun.name);
		for (int i = 0; i < vars.stored; i++) {			
			printf("%d\t|%s\t|%s\n", i+1, getType(vars.p[i].type), vars.p[i].name);
		}
	}
}

void varArrayInit(){
	/*Initializing storage*/
	free(vars.p);
	vars.stored = 0;
	vars.size = 5;
	vars.p = (tuple*)calloc(5, sizeof(tuple));	
}

void analyzeBufInit(){
	/*Initializing storage*/
	free(analyzeBuf.p);
	analyzeBuf.stored = 0;
	analyzeBuf.size = ANALYZE_BUF_INIT_SIZE;
	analyzeBuf.p = (message *)calloc(ANALYZE_BUF_INIT_SIZE, sizeof(message));
}

void exprArrayInit(){
	/*Initializing storage*/
	free(exprStack.p);
	exprStack.stored = 0;
	exprStack.size = EXPR_STACK_INIT_SIZE;
	exprStack.p = (stackElement*)calloc(EXPR_STACK_INIT_SIZE, sizeof(stackElement));	
}

void storeAnalizeBuf(char * msg) {
	analyzeBuf.stored++;
	if (analyzeBuf.stored > analyzeBuf.size) {
		/*Inc array size by const*/
		analyzeBuf.size+=ANALYZE_BUF_ALLOCATE_SIZE;
		analyzeBuf.p = (message*)realloc(analyzeBuf.p, analyzeBuf.size * sizeof(message));
	}
	/*Add element to buffer*/
	strcpy(analyzeBuf.p[analyzeBuf.stored-1].content, msg);
}

void printAnalyzeBuf(){
	printf("\n\x1b[34;1mThree operations table:\n\x1b[0m------------------------------------------------------------------\n");
	for (int i = 0; i < analyzeBuf.stored; i++) {
		printf("%s", analyzeBuf.p[i].content);
	}
	printf("\n");
}

void storeExpr(char * reciever, char * op1, char * op2, char * operation) {
	char temp[MSG_LENGTH];
	sprintf(temp, "dest:  %s\t|op1:  %s\t|operation: %s\t|op2:  %s\n", reciever, op1, operation, op2);
	storeAnalizeBuf(temp);
	if (checkInVars(reciever) == 0 && strcmp(reciever, fun.name) !=0) addVariable(reciever, UNDEF_CODE);
}

void exprArrayAdd(char * el, int elType) {
	char tempName[10];
	switch (elType) {
		/*Implement the operation*/
		case TYPE_UNARY_OPERATION:
			sprintf(tempName, "t_%d", tempNamingCounter);
			tempNamingCounter++;
			storeExpr(tempName, exprStack.p[exprStack.stored-1].element, "", el);
			//Free space
			exprStack.stored = exprStack.stored - 1;
			//Add temp element to its place
			exprArrayAdd(tempName, TYPE_OPERAND);
			break;
		/*Implement the operation*/
		case TYPE_BINARY_OPERATION:
			sprintf(tempName, "t_%d", tempNamingCounter);
			tempNamingCounter++;
			storeExpr(tempName, exprStack.p[exprStack.stored-1].element, exprStack.p[exprStack.stored-2].element, el);
			//Free space
			exprStack.stored = exprStack.stored - 2;
			//Add temp element to its place
			exprArrayAdd(tempName, TYPE_OPERAND);
			break;
		/*Save operand*/
		case TYPE_OPERAND:
			exprStack.stored++;
			if (exprStack.stored > exprStack.size) {
				/*Inc array size*/
				exprStack.size++;
				exprStack.p = (stackElement*)realloc(exprStack.p, exprStack.stored * sizeof(stackElement));
			}
			/*Add element to array*/
			strcpy(exprStack.p[exprStack.stored-1].element, el);
			exprStack.p[exprStack.stored-1].elType = elType;
			break;
		/*Free stack and type resulting equal*/
		case TYPE_EQUAL_OPERATION:
			storeExpr(exprStack.p[exprStack.stored-1].element, exprStack.p[exprStack.stored-2].element, "", el);
			exprStack.stored = 0;
			break;
		default: printf("ERROR: unexpected element type recieved\n");
	}	
}

void addOp(int operationCode){
	/*threeOpNotation fields: size, stored, allOperatorsCounter*/
	switch (operationCode) {
		case AND_OPCODE: 
			exprArrayAdd("&&", TYPE_BINARY_OPERATION);
			break;
		case OR_OPCODE:
			exprArrayAdd("||", TYPE_BINARY_OPERATION);
			break;
		case NOT_OPCODE:
			exprArrayAdd("!", TYPE_UNARY_OPERATION);
			break;
		case EQUAL_OPCODE:
			exprArrayAdd("=", TYPE_EQUAL_OPERATION);
			tempNamingCounter = 0;
			break;
		default: printf("ERROR: Wrong opCode recieved\n");
	}
}