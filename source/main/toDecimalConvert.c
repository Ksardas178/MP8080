#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int toDecimalConvert(int base, const char* sum) {
    int answer = 0;
    int power;
    switch (base) {
        case 2:
            power = 0;
            for (int i = strlen(sum) - 1; i >= 0; i--) {
                switch (sum[i]) {
                    case '0':
                        break;
                    case '1':
                        answer += pow(base, power);
                        break;
                    default:
                        printf("Error: Invalid digit.\n");
                        answer = -1;
                        break;
                }
                power++;
            }
            break;
        case 8:
            power = 0;
            for (int i = strlen(sum) - 1; i >= 0; i--) {
                int digit = (int)sum[i] - (int)('0');
                if (digit > 7) {
                    printf("Error: Invalid digit.\n");
                    answer = -1;
                    break;
                }
                else {
                    answer += digit * pow(base, power);
                    power++;
                }
            }
            break;
        case 10:
            answer = atoi(sum);
            break;
        case 16:
            power = 0;
            for (int i = strlen(sum) - 1; i >= 0; i--) {
                char asciiC = (int)sum[i];
                if ((asciiC >= 48 && asciiC <= 57) ||
                    (asciiC >= 65 && asciiC <= 70) ||
                    (asciiC >= 97 && asciiC <= 102)
                    ) {
                    int digit = 0;
                    switch (sum[i]) {
                        case 'A':
                        case 'a':
                            digit = 10;
                            break;
                        case 'B':
                        case 'b':
                            digit = 11;
                            break;
                        case 'C':
                        case 'c':
                            digit = 12;
                            break;
                        case 'D':
                        case 'd':
                            digit = 13;
                            break;
                        case 'E':
                        case 'e':
                            digit = 14;
                            break;
                        case 'F':
                        case 'f':
                            digit = 15;
                            break;
                        default:
                            digit = (int)sum[i] - (int)'0';
                            break;
                    }
                    answer += digit * pow(base, power);
                    power++;
                }
                else {
                    printf("Error: Invalid digit.\n");
                    answer = -1;
                    break;
                }
            }
            break;
        default:
            printf("Error: Invalid base.\n");
            answer = -1;
            break;
    }
    return answer;
}