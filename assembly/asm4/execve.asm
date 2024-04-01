global _start

SYS_EXECVE equ 59
SYS_EXIT equ 60

section .text

_start:
    mov eax, SYS_EXECVE
    mov rdi, [rsp + 16] ; load address of the name of the program
    lea rsi, [rsp + 16] ; load address of argv (it has to include address to program name as first element)
    mov edx, 0
    syscall

    mov eax, SYS_EXIT
    mov edi, 0
    syscall
