section .text
global delay
; Rozwiązanie z jz i jnz
;align 16
;delay:
;    test rdi, rdi
;    jz .exit
;    rdtsc ; liczba cykli zegara w parze rejestrów edx, eax
;    shl rdx, 0x20
;    or rax, rdx ; liczba cykli zegara w rejestrze rax
;    mov rsi, rax
;.loop:
;    dec rdi
;    jnz .loop
;.exit:
;    rdtsc ; liczba cykli zegara w parze rejestrów edx, eax
;    shl rdx, 0x20
;    or rax, rdx ; liczba cykli zegara w rejestrze rax
;    sub rax, rsi
;    ret
;.exit0:
;    xor rax, rax
;    ret

; Rozwiązanie z jrcxz i loop
align 16
delay:
    mov rcx, rdi
    jrcxz .exit0
    rdtsc ; liczba cykli zegara w parze rejestrów edx, eax
    shl rdx, 0x20
    or rax, rdx ; liczba cykli zegara w rejestrze rax
    mov rsi, rax
.loop:
    loop .loop
.exit:
    rdtsc ; liczba cykli zegara w parze rejestrów edx, eax
    shl rdx, 0x20
    or rax, rdx ; liczba cykli zegara w rejestrze rax
    sub rax, rsi
    ret
.exit0:
    xor rax, rax
    ret
