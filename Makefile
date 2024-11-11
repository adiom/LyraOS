# Makefile

# Инструменты
AS=nasm
CC=gcc
LD=ld
CFLAGS=-ffreestanding -m32 -O2 -Wall
LDFLAGS=-T linker.ld -m elf_i386

# Файлы
BOOT=boot/bootloader.asm
KERNEL=kernel/kernel.c
LINKER=linker.ld
OUT=bin/myos.bin

all: $(OUT)

$(OUT): bootloader.bin kernel.bin
	cat bootloader.bin kernel.bin > $(OUT)

bootloader.bin: $(BOOT)
	$(AS) -f bin $< -o $@

kernel.bin: $(KERNEL) $(LINKER)
	$(CC) $(CFLAGS) -c $< -o kernel/kernel.o
	$(LD) $(LDFLAGS) kernel/kernel.o -o kernel/kernel.elf
	objcopy -O binary kernel/kernel.elf kernel/kernel.bin

linker.ld:
	echo 'ENTRY(kernel_main)\nSECTIONS {\n . = 0x1000;\n .text ALIGN(4):\n { *(.text) }\n .data ALIGN(4):\n { *(.data) }\n .bss ALIGN(4):\n { *(.bss) }\n}' > linker.ld

clean:
	rm -f bootloader.bin kernel/kernel.o kernel/kernel.elf kernel/kernel.bin $(OUT) linker.ld

run: all
	qemu-system-i386 -fda $(OUT)

.PHONY: all clean run
