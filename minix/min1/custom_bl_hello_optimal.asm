org 0x7c00

; Wykonujemy skok, wymuszając ustawienie cs na wartość 0.
jmp 0:start

WELCOME_MSG: db 'Hello real world!', 0x0d, 0x0a, 0x0

; Inicjujemy rejestry segmentowe i stos.
start:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x8000

; Wypisujemy komunikat.
    mov ax, WELCOME_MSG
    call print

loop:
    jmp loop

; Wypisujemy bajty spod adresu w ax, aż do napotkania 0x0.
print:
    xor bx, bx
    mov si, ax
    mov ah, 0x0e
print_loop:
    mov al, byte [si]
    test al, al
    jz print_done
    int 0x10
    inc si
    jmp print_loop
print_done:
    ret

times 510 - ($ - $$) db 0
dw 0xaa55
