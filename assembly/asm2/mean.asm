global mean

section .text

mean:
    add rdi, rsi ; Jeżeli jest overflow, ustawia się CF.
    rcr rdi, 1 ; Przesuń bity z rdi o 1 prawo i ustaw CF na początek.
    mov rax, rdi
    ret
