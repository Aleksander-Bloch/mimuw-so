section .text
global smax
global umax
smax:
    cmp edi, esi
    mov eax, esi
    cmovg eax, edi
    ret
umax:
    cmp edi, esi
    mov eax, esi
    cmova eax, edi
    ret
