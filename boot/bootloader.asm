; bootloader.asm
BITS 16
ORG 0x7C00

start:
    ; Настройка сегментных регистров
    cli
    cld
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Вывод сообщения
    mov si, message
print_loop:
    lodsb
    cmp al, 0
    je done
    mov ah, 0x0E
    int 0x10
    jmp print_loop
done:
    jmp $

message db 'Canfly LyraOS', 0

times 510-($-$$) db 0
dw 0xAA55

