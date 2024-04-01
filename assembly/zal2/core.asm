global core
                                            ; We will call externally defined functions
                                            ; with the following signatures:
extern get_value                            ; uint64_t get_value(uint64_t n)
extern put_value                            ; void put_value(uint64_t n, uint64_t w)

%macro CALL_WITH_STACK_ALIGN16 1            ; Calls %1 function with address of the stack
                                            ; congruent to 0 mod 16 to respect the ABI.
                                            ; Modified registers: [r12]

    push rdi                                ; rdi has to be unchanged through the call
                                            ; because it holds the value of n throughout the whole program.
    mov r12, rsp                            ; Save initial stack pointer address.
    and spl, STACK_ALIGN16                  ; Zero out the lower 4 bits of the stack pointer.
    call %1
    mov rsp, r12
    pop rdi
%endmacro

STACK_ALIGN16 equ 0xf0                      ; Constant to be used with spl, to align the stack to 16.

section .data
align 8                                     ; We will use 8-byte aligned data, so that mov will be atomic.
wanted_core_num: times N dq -1              ; wanted_core_num[i] \in {-1, i} means that core i is
                                            ; not waiting for synchronization.
                                            ; wanted_core_num[i] = j, where i \neq j means that core i is
                                            ; waiting for a trade with core j.

section .bss
trade_offer: resq N                         ; trade_offer[i] is the value that core i wants to trade.

section .text
core:                                       ; uint64_t core(uint64_t n, char const *p)
                                            ; It simulates a distributed stack machine.
                                            ; Details: https://moodle.mimuw.edu.pl/mod/assign/view.php?id=108971
                                            ; Arguments: rdi = n (core number)
                                            ;            rsi = p (pointer to the computation string)
                                            ; Returns:   rax = result (value at the top of the stack
                                            ;                          after computation)
                                            ; Modified registers: [rax, rcx, rdx, rsi]
    push        rbx
    push        rbp
    push        r12

    mov         rbx, rsi                    ; We will use safe register to store the current value of p,
                                            ; because we will modify it when calling put_value.
    mov         rbp, rsp                    ; Save initial stack pointer to base pointer register,
                                            ; so we can restore it to follow the ABI.
    jmp         .next_operation             ; Jump to the first operation, main loop is in between,
                                            ; so the jumps will not be far and will require less bytes.

.add:                                       ; Removes a value from the stack and increases value at
                                            ; the top of the stack by it.
    pop         rax
    add         [rsp], rax
    jmp         .inc_pointer

.mul:                                       ; Same as .add, but multiplies.
    pop         rax
    mul         qword [rsp]
    mov         [rsp], rax
    jmp         .inc_pointer

.neg:                                       ; Negates the value at the top of the stack.
    neg         qword [rsp]
    jmp         .inc_pointer

.shift_p:                                   ; Shifts the pointer p by the value at the top of the stack,
                                            ; if the next value is not 0.
    pop         rax
    cmp         qword [rsp], 0
    jz          .inc_pointer
    add         rbx, rax
    jmp         .inc_pointer

.pop:
    pop         rax
    jmp         .inc_pointer

.end:
    pop         rax                         ; Save the result of core function.
    mov         rsp, rbp                    ; Restore the stack pointer to the initial value.
    pop         r12                         ; Restore the safe registers.
    pop         rbp
    pop         rbx
    ret

.next_operation:
    xor         eax, eax                    ; We will use al which has one byte to store the operation
                                            ; symbol, so we need to zero out the register rax first.
    mov         al, byte [rbx]              ; Store the operation symbol
.not_digit:
    cmp         al, '+'
    je          .add
    cmp         al, '*'
    jl          .end                        ; Only '\0' is less than '*'.
    je          .mul
    cmp         al, '-'
    je          .neg
    cmp         al, 'B'
    je          .shift_p
    cmp         al, 'C'
    je          .pop
    cmp         al, 'D'
    je          .dup
    cmp         al, 'E'
    je          .xchg
    cmp         al, 'G'
    je          .get_push
    cmp         al, 'P'
    je          .pop_put
    cmp         al, 'S'                     ; Only 'n' has greater ASCII code than 'S'.
    jg          .push_n
    je          .sync_swap
.push_digit:                                ; At this point, the current character has to be a digit,
                                            ; if the computation is valid.
    sub         al, '0'                     ; Convert the digit to a number.
    push        rax
.inc_pointer:
    inc         rbx
    jmp         .next_operation

.push_n:                                    ; Pushes the value of n to the stack.
    push        rdi
    jmp         .inc_pointer

.dup:                                       ; Duplicates the value at the top of the stack.
    push        qword [rsp]
    jmp         .inc_pointer

.xchg:                                      ; Swaps the values at the top of the stack.
    pop         rax
    pop         rcx
    push        rax
    push        rcx
    jmp         .inc_pointer

.get_push:                                  ; Calls get_value(n) and pushes the result to the stack.
    CALL_WITH_STACK_ALIGN16 get_value
    push        rax
    jmp         .inc_pointer

.pop_put:                                   ; Pops the value `w` from the stack and calls put_value(n, w).
    pop         rsi
    CALL_WITH_STACK_ALIGN16 put_value
    jmp         .inc_pointer

.sync_swap:
    pop         rcx                         ; Value interpreted as core number m,
                                            ; with which core n wants to trade.
    lea         rax, [rel trade_offer]      ; Store the addresses of arrays declared in .data and .bss.
    lea         rdx, [rel wanted_core_num]
    mov         rsi, [rsp]                  ; Core n wants to trade value at the top of its stack.
    mov         qword [rax + 8*rdi], rsi    ; Store the value for trade in trade_offer[n].
    mov         qword [rdx + 8*rdi], rcx    ; Store the core number m in wanted_core_num[n].
                                            ; This explicitly states that n wants to synchronize
                                            ; and trade with m.
.sync_wait:                                 ; Wait until core m wants to synchronize and trade with n.
    cmp         qword [rdx + 8*rcx], rdi
    jne         .sync_wait

    mov         rsi, [rax + 8*rcx]          ; Store the value that core m wants to trade.
    mov         qword [rsp], rsi            ; Perform trade.
    mov         qword [rdx + 8*rcx], rcx    ; We will set wanted_core_num[m] to m, since sync with self is
                                            ; undefined, to indicate that m does not want to synchronize
                                            ; and trade with anyone.
.trade_wait:
    cmp         qword [rdx + 8*rdi], rdi    ; When wanted_core_num[n] == n, it means that trade was performed.
    jne         .trade_wait
    jmp         .inc_pointer
