global inc_thread

section .bss
    busy: resb 4

section .text

align 8
inc_thread:
    mov         rsi, [rdi]      ; value
    mov         ecx, [rdi + 8]  ; count
    jmp         count_test
count_loop:
spin_lock:
busy_wait:
    lock bts    dword [rel busy], 0
    jc          busy_wait
    inc         dword [rsi]     ; ++*value
spin_unlock:
    lock btr    dword [rel busy], 0
count_test:
    sub         ecx, 1          ; --count
    jge         count_loop      ; skok, gdy count >= 0
    xor         eax, eax        ; return NULL
    ret
