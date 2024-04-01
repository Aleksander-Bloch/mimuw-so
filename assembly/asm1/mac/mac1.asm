section .text
global mac1
mac1:
    ; rdi = a.lo, rsi = a.hi, rdx = x, rcx = y
    mov rax, rdx
    mul rcx ; Teraz wynik jest w rax (młodsze bity) i rdx (starsze bity).
    add rax, rdi
    adc rdx, rsi ; Używamy reszty (carry, c) uzyskanej w powyższym dodawaniu.
    ret
