.global _start

.section .text
_start:
    // Адрес UART (PL011 UART, стандартный для QEMU)
    ldr x0, =0x09000000 // Адрес первого регистра UART
    ldr x1, =msg        // Адрес сообщения
    ldr x2, =msg_end    // Конец сообщения

print_char:
    ldrb w3, [x1], #1   // Загрузка одного символа и увеличение указателя
    cmp x1, x2          // Проверка на конец строки
    b.eq halt           // Если дошли до конца, завершить
    strb w3, [x0]       // Отправить символ в UART
    b print_char         // Цикл

halt:
    wfi                 // Ждём прерывания (можно заменить на бесконечный цикл)
    b halt

.section .rodata
msg:
    .asciz "Hello, QEMU!\n" // Сообщение
msg_end:
