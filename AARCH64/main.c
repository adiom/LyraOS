#include <stdint.h>

void putchar(char c) {
    volatile char* uart = (char*)0x3F8; // Адрес UART для вывода
    while (*(uart + 5) & 0x20) {} // Ждем, пока не будет готово
    *(uart) = c; // Печатаем символ
}

void puts(const char* str) {
    while (*str) {
        putchar(*str++);
    }
}

void main() {
    puts("Hello, World!\n");
}
