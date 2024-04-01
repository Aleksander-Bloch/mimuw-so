%include "macro_print.asm"

global _start

SYS_EXIT equ 60
RETURN_CODE equ 0

section .text
_start:
    mov   rax, rsp
    print "rsp = ", rsp ; Te dwa użycia makra
    print "rsp = ", rax ; powinny wypisać to samo.
    mov   rax, 0x0123456789abcdef
    print "rax = ", rax
    mov   rbx, 0xfedcba9876543210
    print "rbx = ", rbx
    mov eax, SYS_EXIT
    mov edi, RETURN_CODE
    syscall
