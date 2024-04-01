%ifndef MACRO_PRINT_ASM
%define MACRO_PRINT_ASM

SYS_WRITE equ 1
STDOUT equ 1

%macro print 2
  jmp     %%begin

%%hex_digits: db "0123456789abcdef"
%%descr: db %1, "0x"
%%begin:
  push    %2      ; Wartość do wypisania będzie na stosie. To działa również dla %2 = rsp.
  sub     rsp, 16 ; Zrób miejsce na stosie na bufor.
  pushf
  push    rax
  push    rcx
  push    rdx
  push    rsi
  push    rdi
  push    r11

  mov eax, SYS_WRITE
  mov edi, STDOUT
  mov rsi, %%descr
  mov edx, %%begin - %%descr
  syscall

  mov rax, [rsp + 72] ; value of the register we have to print
  lea rsi, [rsp + 64] ; start address of buffer in which we will store hex digits
  mov ecx, 16 ; we will traverse 16 * 4 bits
%%.loop:
  mov rdx, rax
  shr rdx, 60 ; we only want 4 oldest bits
  mov dil, byte [%%hex_digits + rdx] ; use hex digit that corresponds to 4 found bits
  mov [rsi], dil
  shl rax, 4 ; discard 4 oldest bits
  inc rsi ; move address of buffer by one byte
  loop %%.loop

  mov eax, SYS_WRITE ; we want to print contents of buffer we created
  mov edi, STDOUT ; provide file descriptor
  lea rsi, [rsp + 64] ; start address of buffer
  mov edx, 16 ; length of buffer
  syscall

  mov eax, SYS_WRITE
  mov edi, STDOUT
  push `\n`
  mov rsi, rsp
  mov edx, 1
  syscall
  add rsp, 0x8

  pop     r11
  pop     rdi
  pop     rsi
  pop     rdx
  pop     rcx
  pop     rax
  popf
  add     rsp, 24

%endmacro

%endif
