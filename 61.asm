section .data

msg:db "       MENU",10
len:equ $-msg
msg1:db "1)Successive addition",10
len1:equ $-msg1
msg2:db "2)Add and shift method",10
len2:equ $-msg2
msg3:db "3)Exit",10
len3:equ $-msg3
msg4:db "Enter 1st 2 digit hex number",10
len4:equ $-msg4
msg5:db "Enter 2nd 2 digit hex number",10
len5:equ $-msg5
msg6:db "Answer is:"
len6:equ $-msg6
enter:db "",10
enterl:equ $-enter

section .bss

	chc:resb 2
	num:resb 3
	num1:resb 2
	num2:resb 2

	count:resb 1

	res:resb 4	

%macro print 2
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


section .text
global _start
_start:

print msg,len
print msg1,len1
print msg2,len2
print msg3,len3
read chc,2


cmp byte[chc],31h
je sector_1
cmp byte[chc],32h
je sector_2
cmp byte[chc],33h
je exit


sector_1:
	print msg4,len4
	read num,3

	mov rsi,num
	call convert		

	mov word[num1],bx

	print msg5,len5
	read num,3

	mov rsi,num
	call convert
	mov byte[count],bl

	mov bx,00
	mov cx,word[num1]
up1:
	add bx,cx
	dec byte[count]
jnz up1


	mov ax,00

	mov byte[count],04h
	mov rdi,res
up2:
	rol bx,04h		; ans is in the bx
	mov al,bl
	and al,0Fh
	cmp al,09h
	jbe l2
	add al,07h
l2:	add al,30h
	mov byte[rdi],al
	inc rdi
	dec byte[count]
jnz up2

print msg6,len6
print res,4
print enter,enterl
	jmp exit

convert:		;Procedure for ASCII to Hex conversion
	mov bx,00
	mov byte[count],02h
up:
	rol bx,04h
	mov al,byte[rsi]
	cmp al,39h
	jbe l1
	sub al,07h
l1:	sub al,30h
	add bx,ax
	inc rsi
	dec byte[count]
	jnz up
ret

sector_2:
	print msg4,len4
	read num1,3
	
	print msg5,len5
	read num2,3

	mov rsi,num1	
	call convert	
	mov dx,0
	mov dl,bl			;1st no stored in dl

	mov rsi,num2
	call convert			;2nd no stored in bl

	mov byte[count],08h
	mov cx,0			;result stored in cl
up3:
	shl cx,01h
	shl dl,01h
	jnc l3
	add cl,bl
l3:
	dec byte[count]
	jnz up3
		
	mov ax,00		;Hex to ASCII conversion

	mov byte[count],04h
	
	mov rdi,res
up_2:
	rol cx,04h
	mov al,cl
	and al,0Fh
	cmp al,09h
	jbe l_2
	add al,07h
l_2:
	add al,30h
	mov byte[rdi],al
	inc rdi
	dec byte[count]
	jnz up_2

print msg6,len6
print res,4
print enter,enterl
	jmp exit

exit:
	mov rax,60
	mov rdi,00
	syscall


