MAX_N equ (1<<31)                       ; Maximal permutation size, that is INT_MAX+1.
                                        ; Constant MAX_N will be used to validate argument n and,
                                        ; as bitmask to set 31. bit (indexed from 0) that will
                                        ; determine whether given number was already visited.

global inverse_permutation              ; Procedure will be called from C-file.

section .text
                                        ; Procedure inverse_permutation takes two arguments:
                                        ; pointer to non-empty array of numbers `p` and its size,
                                        ; `n`. If the numbers are a permutation of numbers in range
                                        ; [0, n-1], then the procedure inverts the permutation
                                        ; in place and returns true. In the other case, it leaves
                                        ; the array in the original state and returns false.
                                        ; Valid permutation size is in range of [1, INT_MAX+1].
                                        ; If the argument `n` does not fulfill this requirement,
                                        ; then the procedure returns false.
                                        ; Passing of the parameters:
                                        ; `n` is passed through register rdi and `p` through rsi.
                                        ; Passing of the return value:
                                        ; Return value is passed through register rax.
                                        ; Modified registers:
                                        ; [rcx, rdx, rax, r8, r9]
inverse_permutation:
                                        ; SIZE VALIDATION
                                        ; Constant has to be moved to register, so it can be
                                        ; compared with `n`.
        mov     ecx, MAX_N
        cmp     rdi, rcx                ; n > MAX_N ?
        ja      .exit_false
        cmp     edi, 0                  ; n == 0 ?
        jz      .exit_false

                                        ; RANGE VALIDATION
        xor     ecx, ecx                ; Initialize array iterator to 0 (uint32_t i = 0).
.check_range:
        lea     rdx, [rsi + 4*rcx]      ; Store address of array element (rdx = &p[i]).
                                        ; All numbers have type of int, so the address will
                                        ; be moved by 4 bytes each time we move to another number.
        cmp     [rdx], edi              ; In order to detect numbers outside of range [0, n-1],
                                        ; it is enough to check if p[i] >= n using unsigned commands,
                                        ; because if the number is negative then 31. bit is set,
                                        ; so it is interpreted as >= INT_MAX+1.
        jae     .exit_false
        inc     ecx                     ; Increment iterator (i++).
        cmp     ecx, edi                ; Check if we traversed through all elements (i != n ?).
        jne     .check_range            ; Go to next element in the array.

                                        ; DUPLICATES VALIDATION
        xor     ecx, ecx                ; Initialize the iterator (i = 0).
.check_duplicates:
        lea     rdx, [rsi + 4*rcx]      ; rdx = &p[i]
        test    dword [rdx], MAX_N      ; p[i] & (1<<31) (check 31st bit)
                                        ; If the result is not zero, then we cycled through
                                        ; that element already, so we can go further.
        jnz     .next_iteration
.permutation_cycle:
        mov     eax, [rdx]              ; uint32_t j = *(rdx)
        or      dword [rdx], MAX_N      ; p[j] |= (1<<31) (set 31st bit)
        cmp     eax, ecx                ; If j == i, then we ended the cycle.
        je      .next_iteration
        lea     rdx, [rsi + 4*rax]      ; rdx = &p[j]
        test    dword [rdx], MAX_N      ; p[j] & (1<<31)
                                        ; If we visited number with set 31st bit before
                                        ; ending the cycle, it means there is a duplicate.
        jnz     .clean_exit_false
        jmp     .permutation_cycle      ; Move to the next element in the cycle.
.next_iteration:
        inc     ecx                     ; Increment iterator (i++).
        cmp     ecx, edi                ; Check if we traversed through all the elements (i != n).
        jne     .check_duplicates

                                        ; PERMUTATION INVERSION
                                        ; By this point, we know we've got a valid permutation.
        xor     ecx, ecx                ; Initialize the array iterator (i = 0).
.find_cycle:
        lea     rdx, [rsi + 4*rcx]      ; rdx = &p[i]
        test    dword [rdx], MAX_N      ; p[i] & (1<<31) (check 31st bit)
        jz      .next_element
        and     dword [rdx], ~MAX_N     ; p[i] & (1<<31) (unset 31st bit)
                                        ; All the numbers have set 31st bit after duplicates check
                                        ; loop, so know we will treat numbers with unset 31st bit
                                        ; as visited.
        mov     r8d, ecx                ; curr_index = i
        mov     r9d, [rdx]              ; next_index = *(rdx)
                                        ; next_index is the number at curr_index in the array.
.reverse_cycle:
        lea     rdx, [rsi + 4*r9]       ; Load address of the element at next_index.
        cmp     r9d, ecx                ; If next_index is equal to i, so the index we started with,
                                        ; then we ended the cycle.
        je      .end_cycle
        and     dword [rdx], ~MAX_N     ; Visit the number, that is p[i] & (1<<31) (unset 31st bit).
        mov     eax, [rdx]              ; Store the value at next_index in temporary register.
        mov     [rdx], r8d              ; p[curr_index] = next_index, so p^(-1)[next_index] = curr_index
        mov     r8d, r9d                ; curr_index = next_index
        mov     r9d, eax                ; Bring back the original value at next_index.
        jmp     .reverse_cycle
.end_cycle:
        mov     [rdx], r8d              ; Last visited value is at curr_index, so it will end the cycle.
.next_element:
        inc     ecx                     ; Increment array iterator (i++).
        cmp     ecx, edi                ; Check if all the elements have been traversed (i != n).
        jne     .find_cycle
        mov     al, 1
        ret                             ; Return true.

.clean_exit_false:
        xor     ecx, ecx                ; Initialize array iterator (i = 0).
.clean:
        lea     rdx, [rsi + 4*rcx]      ; Store current element's address (rdx = &p[i]).
        and     dword [rdx], ~MAX_N     ; Unset 31st bit which was set during duplicates check.
        inc     ecx                     ; Increment array iterator (i++).
        cmp     ecx, edi                ; Check if we passed through all the elements (i == n ?).
        jne     .clean
.exit_false:
        xor     al, al                  ; Put false into result register.
        ret                             ; Return false.
