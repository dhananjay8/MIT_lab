section .data
msg1: db "enter string	:"
len1: equ $-msg1
msg2: db "enter choice",10
	db "1.cal lenght",10
	db "2.cal rev",10
	db "3.cal pal",10
	db "4.exit",10
len2:equ $-msg2
msg3: db "lenght::"
len3: equ $-msg3
msg4: db "reverse:"
len4: equ $-msg4
msg5: db "entered string is pal	:",10
len5: equ $-msg5
msg6: db "entered string is not pal	:",10
len6: equ $-msg6

n: db "",10

section .bss
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

	str1: resq 4
	str2: resq 4
	len:	resb 1
	chc:	resb 2
	cnt:	resb 1
	bool:	resb 1

global _start

section .text
_start:
list:
	write msg2,len2
	read chc,2
cmp byte[chc],31h
je length
cmp byte[chc],32h
je reverse
cmp byte[chc],33h
je palindrom
jmp exit

length:
	write msg1,len1
	read str1,32
	call lencall
	write msg3,len3	
	write len,1
	write n,1
	jmp list

reverse:
	write msg1,len1
	read str1,32
	call lencall
	call revcall
	write msg4,len4
	write str2,32
	write n,1
	jmp list

palindrom:
	write msg1,len1
	read str1,32
	call lencall
	call revcall
	call palcall
	cmp byte[bool],30h
	jbe true
	cmp byte[bool],31h		
	jbe false
true:	write msg5,len5
	jmp list
false:	write msg6,len6
	jmp list

lencall:
	mov rsi,str1
	mov byte[len],0
up:	cmp byte[rsi],0xA
	je bellow
	inc rsi
	inc byte[len]
	jmp up
bellow:
	mov bl,byte[len]
	cmp bl,09h
	jbe add30
	add bl,07h
add30:	add bl,30h

	mov byte[len],bl
	ret

revcall:
	mov bl,byte[len]
	cmp bl,39h
	jbe sub30
	sub bl,07h
sub30:	sub bl,30h

	mov byte[len],bl
	mov byte[cnt],bl
	dec byte[cnt]
	mov rsi,str1
	mov rdi,str2

	
		
	mov rcx,00
	mov cl,byte[cnt]
	add rsi,rcx
	inc byte[cnt]

up2:	mov al,byte[rsi]
	mov byte[rdi],al
	inc rdi
	dec rsi
	dec byte[cnt]
	jnz up2

	ret

palcall:
	mov rsi,str1
	mov rdi,str2
up3:
	mov al,byte[rsi]
	cmp byte[rdi],al
	jz t
	
f:	mov byte[bool],31h
	jmp a

t:	inc rsi
	inc rdi
	dec byte[len]
	jnz up3
	mov byte[bool],30h

a:
	ret

exit:
mov rax,60
mov rdi,00
syscall
