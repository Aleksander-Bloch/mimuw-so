    section .text
    global mac0
mac0:
    ; rdi = a, rsi = x, rdx = y
    ; 1. rozwiązanie
    ; mov rax, rsi
    ; mul rdx
    ; add rax, rdi
    ; ret

    ; 2. rozwiązanie z użyciem lea
    imul rsi, rdx
    lea rax, [rdi + rsi]
    ret
