%include "asm_io.inc"

SECTION .data

err1: db "incorrect number of command line arguments",10,0
err2: db "incorrect command line argument",10,0
str_base: db "XXXXXXXXXXXXXXXXXXXXXXX",10,0
str_init: db "initial configuration",10,10,0
str_final: db "final configuration",10,10,0

array: dd 0,0,0,0,0,0,0,0,0

SECTION .bss

disks: resb 80
spa: resb 80
let: resb 80
temp1: resb 80
temp2: resb 80
count1: resb 80
count2: resb 80
change: resb 80

SECTION .text
   global  asm_main

asm_main:
   enter 0,0			; setup routine
   pusha			; save all registers

; INPUT ARGUMENT CHECKS

   mov eax, dword [ebp+8]	; argc
   cmp eax, dword 2		; argc should be 2 (1 command line arg)
   jne ERR1
  
   mov ebx, dword [ebp+12]	; address of argv[]
   mov eax, dword [ebx+4]	; argv[1]
   mov ebx, 0 
   				; check first byte, should be between 2 and 9
   mov bl, byte [eax]		; 1st byte of argv[1]
   cmp bl, byte 0
   je ERR2
   cmp bl, '2'
   jl ERR2
   cmp bl, '9'
   jg ERR2
   sub bl, '0'			; convert ASCII to number
     				; check second byte
   cmp byte [eax+1], byte 0	; make sure input argument only contains one character
   jne ERR2

; INITIALIZE
   
   mov [disks], ebx		; store input as global, num of disks
   mov eax, str_init
   call print_string
 
   push ebx			; push num disks
   push array			; push adress of array

   call rconf   		; randomize array
   call showp			; show initial configuartion
   
; SORT

   call sorthem			
   add esp, 8
   
; FINAL CASE

   mov eax, str_final
   call print_string

   mov [change], dword 1	; force printing the last config even if already sorted
   mov ecx, dword [disks]
   mov ebx, array
  
   push ecx
   push ebx
  
   call swap			; sort first element of array
   add esp,8


   jmp asm_main_end
 
 showp:
   enter 0,0
   pusha

   mov ebx, dword [ebp+8]	; address of array
   mov ecx, dword [ebp+12]	; number of disks
   
   mov edx, 1			; init counter
   
   S_LastArray:			; returns address of last non-zero element of array,
   cmp edx, ecx			; as this is the first to be printed
   je E_LastArray
   inc edx
   add ebx, 4
   jmp S_LastArray   
   E_LastArray:

   mov [count1], dword 0	; reset counter   
   S_Disk:			; runs once for every disk
   mov eax, dword [count1]
   cmp eax, dword [disks]
   je showp_end
   inc dword [count1]		; increment counter
   mov eax, [ebx]		; value of curent element in array   
  
   push eax
  
   call print_line		; print line depending on value of current element
  
   add esp,4
 
   call print_nl

   sub ebx, 4			; traverse to previous element in the array, 
   jmp S_Disk			; as this is the next one to be printed
  
   showp_end:
   mov eax, str_base		; print X's, representing the base of the peg
   call print_string
   call read_char		; waits for user to press space before exiting

   popa
   leave
   ret

 print_line:
   enter 0,0
   pusha

   mov edx, dword [ebp+8]	; number of o's (n)
   mov ebx, 11
   sub ebx, edx			; number of spaces (11-n)
   
   mov [let], edx		; store input values in global variables
   mov [spa], ebx

   mov ecx, 0			; initialize state to 0
   space:			; prints (11-n) spaces
   cmp ebx, dword 0
   je select
   mov al,' '
   call print_char
   dec ebx
   jmp space

   letter:			; prints (n) o's
   cmp edx, dword 0
   je select
   mov al,'o'
   call print_char
   dec edx
   jmp letter
   
   select:			; decide what to do next, logic similar to FSM
   inc ecx			; inc state
   mov edx, dword [let]		; reset registers to input
   mov ebx, dword [spa]

   cmp ecx, 1			; goto letter after space is done
   je letter
   cmp ecx, 3			; done when it has done 3 actions
   je print_line_end		; counter = 2, so space and letter has been printed once each
   mov al,'|'			; print "|" and then goto print letter
   call print_char
   jmp letter

   print_line_end:
   popa
   leave
   ret

 sorthem:
   enter 0,0
   pusha

   mov ebx, dword [ebp+8]	; address of array
   mov ecx, dword [ebp+12] 	; n disks
   
   cmp ecx, 1			; base case to end recursion (if n = 1)
   je sorthem_end
   
   add ebx,4			; pass A+1
   dec ecx			; pass n-1
   
   push ecx
   push ebx

   call sorthem			; recursive call
 
   pop ebx
   pop ecx
   
   mov [change], dword 0	; reset counter
				; defined here so its possible to force state in main
   push ebx
   push ecx
   
   call swap			; swap function
   
   add esp,8
   
   sorthem_end:
   popa
   leave
   ret

 swap:
   enter 0,0
   pusha
 
   mov [count2], dword 0	; reset counter every time
 
   S_Swap:

   mov edx, ecx
   dec edx
   cmp edx, dword [count2]	; base case to end loop (if count2 = n-1)
   je E_Swap   
   
   mov edx, ebx
   add edx, 4
   mov eax, [edx]
   
   cmp eax, [ebx]		; if a[curr] > a[next] already sorted, jump end
   jl E_Swap
   				; this means a[curr] < a[next] therefore swap
   mov esi, [ebx]		; temp = a[curr]
   mov [ebx], eax		; a[curr] = a[next]
   mov [edx], esi		; a[next] = temp
  
   inc dword [count2]		; inc counter
   mov [change], dword 1	; flag that values have been changed
   add ebx, 4			; inc next value in array
   
   jmp S_Swap

   E_Swap:
   
   cmp [change],dword 1		; if values have been changed, show new config
   jne swap_end			; else skip showp
   mov eax, dword [disks]
 
   push eax			; push values for showp
   push array

   call showp

   add esp, 8

   swap_end:
   popa
   leave
   ret

 ERR1:				; incorrect number of commnad line arguments
   mov eax, err1
   call print_string
   jmp asm_main_end

 ERR2:				; incorrect command line argument
   mov eax, err2
   call print_string
   jmp asm_main_end

 asm_main_end:
   popa				; restore all registers
   leave
   ret
