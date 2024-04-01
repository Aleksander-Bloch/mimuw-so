global hello
extern putchar

section .rodata
hello_text: db `Hello World!\n\0`
hello_len: equ $ - hello_text

; Wersja z licznikiem na indeks znaku, przy którym jesteśmy.
;section .text
;hello:
;    sub rsp, 0x8
;    push rbx
;    xor rbx, rbx
;    push rbp
;    lea rbp, [rel hello_text]
;next_char:
;    mov dil, byte [rbp + rbx]
;    call [rel putchar wrt ..got]
;    inc rbx
;    cmp rbx, hello_len
;    jne next_char
;    pop rbp
;    pop rbx
;    add rsp, 0x8
;    ret

; Wersja z bezpośrednim przesuwaniem wskaźnika na tekst.
section .text
hello:
    push rbx
    lea rbx, [rel hello_text]
.next_char:
    mov dil, byte [rbx]
    call putchar wrt ..plt
    inc rbx
    cmp byte [rbx], 0
    jne .next_char
    pop rbx
    ret
