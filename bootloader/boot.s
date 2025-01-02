.global _start

.section .text
_start:
    ldr x0, =0x09000000      // Базовый адрес UART
    ldr x1, =msg             // Указатель на сообщение
    ldr x2, =msg_end         // Указатель на конец сообщения

print_char:
    ldrb w3, [x1], #1        // Загрузить один символ и увеличить указатель
    cmp x1, x2               // Проверить, достигли ли конца сообщения
    b.eq halt                // Если конец, завершить

wait_uart:
    ldr w4, [x0, #0x18]      // Загрузить регистр флагов UARTFR
    and w4, w4, #0x20        // Проверить флаг TXFF (бит 5)
    cbnz w4, wait_uart       // Если буфер передатчика полный, ждать

    strb w3, [x0, #0x00]     // Записать символ в регистр данных UARTDR
    b print_char             // Повторить

halt:
    b halt                   // Бесконечный цикл

.section .rodata
msg:
    .asciz "Hello, UART!\n"
msg_end:
