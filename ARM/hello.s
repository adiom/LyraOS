.global _start

.section __TEXT,__text

_start:
    // Вызов write для вывода строки на экран
    mov     x0, #1          // файловый дескриптор stdout
    adrp    x1, msg@PAGE    // загрузить базовый адрес страницы, на которой находится msg
    add     x1, x1, msg@PAGEOFF // добавить смещение от начала страницы до msg
    mov     x2, #len        // длина строки
    mov     w8, #0x4        // номер системного вызова write
    svc     #0x80           // вызов системного сервиса

    // Вызов exit для завершения программы
    mov     x0, #0          // код возврата 0
    mov     w8, #0x1        // номер системного вызова exit
    svc     #0x80           // вызов системного сервиса

.section __DATA,__data
msg:
    .ascii "Hello, World!\n"
len = . - msg