.section .data
hello_str:
    .ascii "Hello, World!\n"
    .set hello_len, . - hello_str

.section .text
.globl _start

_start:
    # Системный вызов для write
    li a0, 1       # file descriptor 1 is stdout
    la a1, hello_str # load address of string to print
    li a2, hello_len # length of string
    li a7, 64      # write syscall number for RISC-V (on Linux)
    ecall          # make the system call

    # Системный вызов для exit
    li a0, 0       # exit code 0
    li a7, 93      # exit syscall number for RISC-V (on Linux)
    ecall          # make the system call
