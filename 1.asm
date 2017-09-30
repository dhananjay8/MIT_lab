section .data
msg1: db "enter no::",10
len1: equ $-msg1
msg2: db "enter count of numbers::",10
len2: equ $-msg2
msg3: db "Addition Result::",10
len3: equ $-msg3
n: db "",10

section .bss
	a: resq 2	;accept no
	res: resq 2	;result
	temp_res: resq 2;runtime res
	no: resb 2	;counter
	cnt:resb 1	;hex counter
	cnt1:resb 1	;calculation cnt

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
	write msg2,len2
	read no,2
	
	mov bl,byte[no]
	cmp bl,39h
	jbe sub1
	sub bl,07h
sub1:	sub bl,30h

	mov byte[cnt],bl

	mov qword[temp_res],0
loopr:	write msg1,len1
	read a,20
	
	mov r8,a
	mov rcx,0
	mov byte[cnt1],16
up:	mov bl,[r8]
	cmp bl,39h
	jbe sub30
	sub bl,07h
sub30:	sub bl,30h
	
	rol rcx,04
	add cl,bl
	inc r8
	dec byte[cnt1]
	jnz up

	adc qword[temp_res],rcx
	dec byte[cnt]
	jnz loopr

	write msg3,len3
	
	mov rsi,res
	mov rax,qword[temp_res]
	mov byte[cnt1],16

up2:	rol rax,04h
	mov bl,al
	and bl,0Fh
	cmp bl,09h
	jbe add30
	add bl,07h
add30:	add bl,30h

	mov [rsi],bl
	inc rsi
	dec byte[cnt1]
	jnz up2
	
	write res,16
	write n,1

mov rax,60
mov rdi,0
syscall
	

