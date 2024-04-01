section .text
global mac2
mac2:
    ; a = rdi, x = rsi, y = rdx
    ; a, x, y to wskaźniki do struktury uint128_t
    ; a.lo = [rdi], a.hi = [rdi+8]
    ; x.lo = [rsi], x.hi = [rsi+8]
    ; y.lo = [rdx], y.hi = [rdx+8]
    mov rcx, [rsi]
    imul rcx, [rdx+8]
    mov r8, [rdx]
    imul r8, [rsi+8]
    mov rax, [rsi]
    mul qword [rdx]
    add rdx, rcx
    add rdx, r8
    add [rdi], rax
    adc [rdi+8], rdx
    ret

