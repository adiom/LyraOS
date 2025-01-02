// kernel/kernel.c

#define UART0_BASE 0x10000000
#define UART_DR    (*(volatile unsigned int *)(UART0_BASE + 0x00))
#define UART_FR    (*(volatile unsigned int *)(UART0_BASE + 0x18))
#define UART_FR_TXFF (1 << 5)

void uart_send(char c) {
    // Ожидание, пока FIFO передачи не будет полон
    while (UART_FR & UART_FR_TXFF);
    // Запись символа в UART_DR
    UART_DR = c;
}

void uart_send_string(const char *str) {
    while (*str) {
        uart_send(*str++);
    }
}

void kernel_entry() {
    uart_send_string("Hello from kernel\n");
    while (1) {}
}

// Обработчик паники (необходим для корректной компиляции)
void __attribute__((noreturn)) panic_handler() {
    while (1) {}
}
