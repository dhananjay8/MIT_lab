section .data
msg1: db "Enter the 1st string 	:"
len1: equ $-msg1
msg2: db "Enter the 2nd string	:"
len2: equ $-msg2
msg3: db "Enter your choice	:"
len3: equ $-msg3
msg4: db "-------------MENU--------------",0x0A
      db "1.Concatenate the String",0x0A
      db "2.Total Occurences of Substring",0x0A
      db "3.Exit",0x0A
len4: equ $-msg4

msg5: db "concatenated string is	:"
len5: equ $-msg5
msg6: db "occurence of substring is:"
len6: equ $-msg6
n: db "",0x0A

section .bss

global l1,l2,cnt,str1,str2,str3	;write before memory allocation ,follow same order
extern concat,substr

	str1:	resq 4
	str2:	resq 4
	str3:	resq 4
	chc:	resb 2
	l1:	resb 1
	l2:	resb 1
	cnt:	resb 1
	
%macro write 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

global _start
section .text
_start:
list:
	write msg4,len4
	write msg3,len3
	read chc,2
cmp byte[chc],31h
je concatenation
cmp byte[chc],32h
je substring
jmp exit

concatenation:
	write msg1,len1
	read str1,32
	dec al
	mov byte[l1],al

	mov al,0
	write msg2,len2
	read str2,31
	mov byte[l2],al

	write msg5,len5
	call concat
	
	write str3,32
	write n,1
	jmp list

substring:
	write msg1,len1
	read str1,32
	dec al
	mov byte[l1],al

	mov al,0
	write msg2,len2
	read str2,31
	dec al
	mov byte[l2],al

	mov byte[cnt],0
	write msg6,len6
	call substr
	cmp byte[cnt],09h
	jbe add30
	add byte[cnt],07h
add30:	add byte[cnt],30h
	
	write cnt,2
	write n,1
	write n,1
	jmp list

exit:
mov rax,60
mov rdi,00
syscall
