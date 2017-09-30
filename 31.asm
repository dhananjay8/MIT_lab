section .data
msg1: db "enter choice",10
	db "1.hex to bcd",10
	db "2.bcd to hex",10
	db "3.exit",10

len1:equ $-msg1
msg2: 	db "enter 4 digit hex no:"
len2: equ $-msg2
msg3: 	db "enter 5 digit BCD no:"
len3: equ $-msg3
msg4: 	db "BCD no	:"
len4: equ $-msg4
msg5: 	db "hex no 	:"
len5: equ $-msg5
n: db "",10

section .bss

	num:	resb 6
	res:	resb 8
	chc:	resb 2
	cnt:	resb 1
	cnt1:	resb 1

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
menu:
	write msg1,len1
	read chc,2
cmp byte[chc],31h
je hextobcd
cmp byte[chc],32h
je bcdtohex
jmp exit

hextobcd:
	write msg2,len2
	read num,5
	mov byte[cnt],5
	mov byte[cnt1],04;for conversin to ascii
	call asc_hex	;store result in rax
	
	
	mov rbx,0Ah	;divide by 10

up2:	mov rdx,00
	div rbx		;rax/rbx quo in rax ,rem in rdx
	push rdx
	dec byte[cnt]
	jnz up2

	mov ecx,0
	mov esi,res
	mov byte[cnt],5

above:	pop rcx		;h_a
	cmp cl,09h
	jbe add30
	add cl,07h
add30:	add cl,30h
	mov byte[esi],cl
	inc esi
	dec byte[cnt]
	jnz above
	mov byte[esi],10	;set end to new line

	write res,5	
	write n,1
		
	jmp menu

bcdtohex:

	write msg3,len3
	read num,6

	mov qword[res],0

	mov byte[cnt1],05	;for conversion 5 digit
	call asc_hex
	mov rcx,0

	mov rcx,rax
	
	mov rax,0
	mov rbx,0
	mov al,cl
	and al,0Fh
	mov bx,01h
	mul bx
	adc qword[res],rax
	
	mov rax,0
	mov rbx,0	
	ror rcx,04		;ror
	mov al,cl		;dont forget to and
	and al,0Fh
	mov bx,0Ah
	mul bx
	adc qword[res],rax

	mov rax,0
	mov rbx,0	
	ror rcx,04
	mov al,cl
	and al,0Fh
	mov bx,64h
	mul bx
	adc qword[res],rax

	mov rax,0
	mov rbx,0	
	ror rcx,04
	mov al,cl
	and al,0Fh
	mov bx,3E8h
	mul bx
	adc qword[res],rax

	mov rax,0
	mov rbx,0	
	ror rcx,04
	mov al,cl
	and al,0Fh
	mov bx,2710h
	mul bx
	adc qword[res],rax

	mov rcx,0
	mov rcx,qword[res]
	mov byte[cnt1],05h

	mov rsi,res
	rol ecx,16		; from ecx=00065535 to ecx=65535000
up3:	
	rol ecx,4		;con to hex to ascii
	mov bl,cl
	and bl,0Fh
	cmp bl,09h
	jbe add3
	add bl,07h
add3:	add bl,30h

	mov [rsi],bl
	inc rsi
	dec byte[cnt1]
	jnz up3

	mov byte[rsi],10	;;dont forget
	write msg5,len5
	
	write res,4
	write n,1
	
	jmp menu
	
	


asc_hex:
	mov rsi,num
	
	mov rax,0
up1:
	rol rax,04
	mov bl,[rsi]
	cmp bl,39h
	jbe sub30
	sub bl,07h
sub30:	sub bl,30h
	add al,bl

	inc rsi
	dec byte[cnt1]
	jnz up1			;in eax
	
	ret



exit:
	mov rax,60
	mov rdi,00
	syscall
