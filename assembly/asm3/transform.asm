extern putchar
global transform

section .text

transform:
    push rbx ; Wartość, która jest w rbx należy zachować.
    mov rbx, rdi ; W rdi mamy wskaźnik na napis s.
    mov dil, byte [rbx]
    cmp dil, 0
    je .return
.check_if_letter:
    cmp dil, 'a'
    jb .not_letter
    cmp dil, 'z'
    ja .not_letter

    call putchar wrt ..plt
    inc rbx
    jmp .return

.not_letter:

    ; Wypisz znak '('.
    mov dil, '('
    call putchar wrt ..plt

    ; Zwiększ s o jeden.
    inc rbx

    ; Wywołaj rekurencyjnie transform z aktualną wartością s.
    mov rdi, rbx
    call transform

    ; Ustaw s na zwróconą wartość.
    mov rbx, rax

    ; Wypisz znak '+'
    mov dil, '+'
    call putchar wrt ..plt

    ; Wywołaj rekurencyjnie transform z aktualną wartością s.
    mov rdi, rbx
    call transform

    ; Ustaw s na zwróconą wartość.
    mov rbx, rax

    ; Wypisz znak ')'
    mov dil, ')'
    call putchar wrt ..plt
.return:
    mov rax, rbx
    pop rbx
    ret


