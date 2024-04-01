global _start

SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1
MAX_LEN equ 9

section .text
_start:
    mov rcx, [rsp]
    mov rdx, [rsp + 8*rcx] ; load address of last parameter

    xor al, al ; set target value in string to 0, cause we're looking for '\0'
    mov ecx, MAX_LEN + 1 ; set upper bound for number of characters we're scanning
    mov rdi, rdx
    repne scasb

    mov r8, rdi ; store address of '\0'
    sub r8, rdx ; calculate length (end address - start address)
    dec r8
    add r8, '0'

    push r8
    mov eax, SYS_WRITE
    mov edi, STDOUT
    mov rsi, rsp
    mov edx, 1
    syscall
    add rsp, 0x8

    push `\n`
    mov eax, SYS_WRITE
    mov edi, STDOUT
    MOV rsi, rsp
    mov edx, 1
    syscall
    add rsp, 0x8

    mov eax, SYS_EXIT
    mov edi, 0
    syscall

