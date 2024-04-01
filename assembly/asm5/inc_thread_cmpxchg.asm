global inc_thread

section .bss
    busy: resb 4

section .text

align 8
inc_thread:
    mov             rsi, [rdi]      ; value
    mov             ecx, [rdi + 8]  ; count
    jmp             count_test
count_loop:
spin_lock:
    mov             edi, 1
busy_wait:
    xor             eax, eax
    lock cmpxchg    [rel busy], edi
    jnz             busy_wait
    inc             dword [rsi]     ; ++*value
spin_unlock:
    mov             eax, 1
    xor             edi, edi
    lock cmpxchg    [rel busy], edi
count_test:
    sub             ecx, 1          ; --count
    jge             count_loop      ; skok, gdy count >= 0
    xor             eax, eax        ; return NULL
    ret
