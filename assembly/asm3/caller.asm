global caller

; rdi = callback
; rsi = x
section .text
caller:
    ; Wersja 1.
    ; Musimy gdzieś zapamiętać wskaźnik przechowywany w rdi,
    ; bo w rdi musimy zapisać argument x dla wołanej funkcji.
    ; Robimy call, więc rozmiar stosu musi przystawać do 8 (modulo 16).
;    sub rsp, 0x8
;    mov rax, rdi
;    mov rdi, rsi
;    call rax
;    add rsp, 0x8
;    ret

    ; Wersja 2.
    ; Podmieniamy wartości rdi i rsi (xchg to swap)
    ; Teraz rdi = x, rsi = callback
    xchg rdi, rsi
    jmp rsi


