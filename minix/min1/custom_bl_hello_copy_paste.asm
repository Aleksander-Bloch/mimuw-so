mov ah, 0xe  ; argument - doprecyzowanie funkcji przerwania (wypisz znak i przesuń kursor)
mov al, 'H'  ; argument - znak do wypisania
int 0x10     ; wywołanie przerwania nr 16 - obsługa ekranu
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10
mov al, ' '
int 0x10
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10
mov al, '!'
int 0x10
mov al, 0x0d
int 0x10
mov al, 0x0a
int 0x10
loop:
    jmp loop
times 510 - ($ - $$) db 0
dw 0xaa55
