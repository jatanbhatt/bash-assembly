%include "asm_io.inc"

SECTION .data

err1: db "incorrect number of command line arguments",10,0
err2: db "incorrect command line argument",10,0

SECTION .bss

size: resb 80

SECTION .text
   global  asm_main

display_shape:
   enter 0,0             ; setup routine
   pusha                 ; save all registers

   mov eax, dword [ebp+8]      ; the parameter
   sub eax, '0'
   mov [size], eax

   mov ecx, dword [ebp+12] ;ebx holds char

   mov edx,0
   mov ebx,0

   ;eax = number of letters
   ;ebx = number of spaces
   ;ecx = character
   ;edx = counter

   LOOP1: ;first half of loop

   push ecx
   push ebx
   push eax

   call display_line

   add esp,12

   dec eax
   inc ebx

   cmp eax, dword 1
   jne LOOP1

   LOOP2: ;second half of loop

   push ecx
   push ebx
   push eax

   call display_line

   add esp,12

   inc eax
   dec ebx

   cmp eax, dword [size]
   jbe LOOP2

   popa
   leave
   ret

display_line:
   enter 0,0
   pusha

   mov edx, dword [ebp+8]     ;number of letters
   mov ebx, dword [ebp+12]     ;number of spaces
   mov ecx, dword [ebp+16]     ;character to print


   space:
   cmp ebx, dword 0
   je letter
   mov al,' '
   call print_char
   dec ebx
   jmp space

   letter:
   cmp edx, dword 0
   je done
   mov eax,ecx
   call print_char
   dec edx
   jmp letter

   done:
   call print_nl

   popa
   leave
   ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
   enter 0,0             ; setup routine
   pusha                 ; save all registers

   mov eax, dword [ebp+8]   ; argc
   cmp eax, dword 2         ; argc should be 2
   jne ERR1
   ; so we have the right number of arguments
   mov ebx, dword [ebp+12]  ; address of argv[]
   mov eax, dword [ebx+4]   ; argv[1]
   ; check that the string is either "1" or "2"
   ; check the first byte, should be '1' or '2'
   ; check the second byte, should be 0
   mov bl, byte [eax]       ; 1st byte of argv[1]
   cmp bl, byte 0
   je ERR2
   cmp bl, '0'
   jl ERR2
   cmp bl, '9'
   jg ERR2
   cmp bl, '1'
   je ERR2
   ; byte 1 is number
   sub bl, '0' ; convert ASCII to number
   test bl, 1 ; check if lowest bit is set, will show if odd or not
   JZ ERR2 ; if even goto error

   ; check the second byte
   mov bl, byte [eax+1]     ; 2nd byte of argv[1]
   cmp bl, byte 0
   je ERR2
   cmp bl, 'A'
   jl ERR2
   cmp bl, 'Z'
   jg ERR2
   cmp byte [eax+2], byte 0
   jne ERR2
   ; hence the argument is correct and its numeric value

   mov ecx, 0
   mov ebx, 0
   mov cl, byte [eax]
   mov bl, byte [eax+1]
   push ebx
   push ecx

   call display_shape
   add esp, 8
   jmp asm_main_end

 ERR1:
   mov eax, err1
   call print_string
   jmp asm_main_end

 ERR2:
   mov eax, err2
   call print_string
   jmp asm_main_end

 asm_main_end:
   popa                  ; restore all registers
   leave
   ret
