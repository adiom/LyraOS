# Makefile

# Инструменты
AS := aarch64-elf-as
LD := aarch64-elf-ld
CC := aarch64-elf-gcc
OBJCOPY := aarch64-elf-objcopy
QEMU := qemu-system-aarch64

# Папки и файлы
BOOTLOADER_S := bootloader/aarch64/boot.s
BOOTLOADER_O := bootloader/aarch64/boot.o
KERNEL_C := kernel/aarch64/kernel.c
KERNEL_O := kernel/aarch64/kernel.o
KERNEL_ELF := kernel/aarch64/kernel.elf
LINKER_SCRIPT := kernel/aarch64/linker.ld
OS_IMG := os.img

# Цели
all: $(OS_IMG)

# Сборка загрузчика
$(BOOTLOADER_O): $(BOOTLOADER_S)
    $(AS) -o $@ $<

# Сборка ядра
$(KERNEL_O): $(KERNEL_C)
    $(CC) -c -o $@ $<

# Линковка Загрузчика и Ядра
$(KERNEL_ELF): $(BOOTLOADER_O) $(KERNEL_O)
    $(LD) -T $(LINKER_SCRIPT) -o $@ $^

# Создание Бинарного Образа
$(OS_IMG): $(KERNEL_ELF)
    $(OBJCOPY) -O binary $< $@

# Запуск в UTM (через QEMU)
run: $(OS_IMG)
    $(QEMU) \
      -machine virt \
      -cpu cortex-a53 \
      -m 1024 \
      -nographic \
      -kernel $(OS_IMG)

# Очистка сборки
clean:
    rm -f $(BOOTLOADER_O) $(KERNEL_O) $(KERNEL_ELF) $(OS_IMG)

.PHONY: all run clean