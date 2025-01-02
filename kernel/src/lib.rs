// kernel/src/lib.rs
#![no_std]
#![no_main]

use core::panic::PanicInfo;

// UART0 базовый адрес
const UART0_BASE: usize = 0x10000000;

// Регистры UART
const UART_DR: usize = UART0_BASE + 0x00;
const UART_FR: usize = UART0_BASE + 0x18;

// Флаги
const UART_FR_TXFF: u32 = 1 << 5;
const UART_FR_RXFE: u32 = 1 << 4;

// Функция отправки одного символа
fn uart_send(c: u8) {
    unsafe {
        // Ожидание, пока FIFO передачи не будет полон
        while (core::ptr::read_volatile(UART_FR as *const u32) & UART_FR_TXFF) != 0 {}
        // Запись символа в UART_DR
        core::ptr::write_volatile(UART_DR as *mut u32, c as u32);
    }
}

// Функция получения одного символа
fn uart_receive() -> u8 {
    unsafe {
        // Ожидание, пока FIFO приёма не будет пуст
        while (core::ptr::read_volatile(UART_FR as *const u32) & UART_FR_RXFE) != 0 {}
        // Чтение символа из UART_DR
        (core::ptr::read_volatile(UART_DR as *const u32) & 0xFF) as u8
    }
}

// Функция отправки строки
fn uart_send_string(s: &str) {
    for c in s.bytes() {
        uart_send(c);
    }
}

// Простая функция шелла
fn shell() -> ! {
    uart_send_string("LyraOS shell\n> ");
    loop {
        let c = uart_receive();
        match c {
            b'\n' | b'\r' => {
                uart_send('\n' as u8);
                uart_send_string("> ");
            }
            b'd' => {
                uart_send_string("Hello from LyraOS!\n> ");
            }
            b'c' => {
                uart_send_string("Executing 'clear'\n> ");
            }
            _ => {
                uart_send(c); // Эхо
            }
        }
    }
}

// Точка входа ядра
#[no_mangle]
pub extern "C" fn kernel_entry() -> ! {
    shell()
}

// Обработчик паники
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
