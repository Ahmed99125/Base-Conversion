#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

// Function to convert any base to decimal
int baseToDecimal(char *number, int base) {
    int length = strlen(number);
    int decimal = 0;
    for (int i = 0; i < length; i++) {
        char digit = number[length - i - 1];
        int value;
        if (isdigit(digit)) {
            value = digit - '0';
        } else if (isalpha(digit)) {
            value = toupper(digit) - 'A' + 10;
        } else {
            return -1; // Invalid character
        }
        if (value >= base) {
            return -1; // Invalid digit for the base
        }
        decimal += value * pow(base, i);
    }
    return decimal;
}

// Function to convert decimal to any base
void decimalToBase(int decimal, int base, char *result) {
    char digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int index = 0;
    while (decimal > 0) {
        result[index++] = digits[decimal % base];
        decimal /= base;
    }
    result[index] = '\0';
    // Reverse the result
    for (int i = 0; i < index / 2; i++) {
        char temp = result[i];
        result[i] = result[index - i - 1];
        result[index - i - 1] = temp;
    }
}

// Function to control the program
void baseConversionController() {
    char number[100];
    int fromBase, toBase;
    printf("Enter the number: ");
    scanf("%s", number);
    printf("Enter the base to convert from: ");
    scanf("%d", &fromBase);
    printf("Enter the base to convert to: ");
    scanf("%d", &toBase);

    int decimal = baseToDecimal(number, fromBase);
    if (decimal == -1) {
        printf("Invalid number for the given base.\n");
        return;
    }

    char result[100];
    decimalToBase(decimal, toBase, result);
    printf("The number %s in base %d is %s in base %d.\n", number, fromBase, result, toBase);
}

int main() {
    baseConversionController();
    return 0;
}