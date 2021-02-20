int main() {
	char * temp = "RP";
	printf("%d\n", isCommandName("RP"));
}

int inArray(char * a[], char * arg, int l) {
	//int length = sizeof(a)/sizeof(a[0]);
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
				int length = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, length);
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
				int length = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, length);
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
				int length = sizeof(a)/sizeof(a[0]);
				return inArray(a, arg, length);
			}
		default:
			printf("<ERROR> wrong argument amount\n");
			return 0;
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