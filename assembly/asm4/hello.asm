global _start

; Register rax stores system function number.
; Parameters are stored (max. 6) in rdi, rsi, rdx, r10, r8, r9 in that order.

SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1

section .rodata
hello_txt: db `Hello World!\n`

HELLO_LEN equ $ - hello_txt

section .text
_start:
    ; system function write has 3 arguments
    ; file descriptor, buffer and count of bytes
    mov eax, SYS_WRITE ; we will use write system call
    mov edi, STDOUT ; file descriptor for write
    mov rsi, hello_txt ; buffer for write
    mov edx, HELLO_LEN ; length of a string
    syscall

    mov eax, SYS_EXIT
    mov edi, 0 ; error code
    syscall

