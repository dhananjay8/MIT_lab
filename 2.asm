section .data
num dd 30303030h,31313131h,32323232h,33333333h,34343434h,00000000h,00000000h,00000000h,00000000h
space db " "
lensp equ $-space
nl db "",10
lennl equ $-nl
msg1 db "Before copying:",10
len1 equ $-msg1
msg2 db "After copying:",10
len2 equ $-msg2
msgol db "Non-overlapping case:",10
lenol equ $-msgol
msgnol db "Overlapping case:",10
lennol equ $-msgnol
msgoff db "Enter an offset between 0 to 4",10
lenoff equ $-msgoff
msgch db "Enter choice:",10,"1.Without string instructions",10,"2.With string instructions",10
lench equ $-msgch

section .bss
	num1 resd 5
	count resb 1
	addr resb 8
	number resb 8
	cnt resb 1
	offset resb 2
	choice resb 2

%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

%macro read 2
	mov eax,3
	mov ebx,0
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

section .text
global _start
_start:
	print msgch,lench
	read choice,2
cmp byte[choice],31h
jne string

	mov esi,num
	mov byte[count],5

	print msgol,lenol
	print msg1,len1
	call printloop

	mov esi,num
	mov edi,num1
	;;for copying
	mov byte[count],5
label1:
	mov ebx,dword[esi]
	mov dword[edi],ebx
	add esi,4
	add edi,4
	dec byte[count]
	jnz label1
	;;copy done

	mov esi,num1
	mov byte[count],5

	print msg2,len2
	call printloop

	print nl,lennl
	print msgnol,lennol
	print msgoff,lenoff

	read offset,2

	mov esi,num
	mov byte[count],5	
	print msg1,len1
	call printloop

	mov esi,num
	add esi,16
	mov al,byte[offset]
	cmp al,30h
	je l0
	cmp al,31h
	je l1
	cmp al,32h
	je l2
	cmp al,33h
	je l3
	cmp al,34h
	je l4
	
	jmp exit

l0:
	mov edi,esi
	jmp copy
l1:
	mov edi,esi
	add edi,4
	jmp copy
l2:
	mov edi,esi
	add edi,8
	jmp copy
l3:
	mov edi,esi
	add edi,12
	jmp copy
l4:
	mov edi,esi
	add edi,16
	jmp copy

copy:
	mov byte[count],5
copy2:
	mov ebx,dword[esi]
	mov dword[edi],ebx
	sub esi,4
	sub edi,4
	dec byte[count]
	jnz copy2

	add esi,4

	mov byte[count],5
	print msg2,len2
	mov al,byte[offset]
	cmp al,30h
	je ll0
	cmp al,31h
	je ll1
	cmp al,32h
	je ll2
	cmp al,33h
	je ll3
	cmp al,34h
	je ll4
	jmp exit

ll0:
	jmp printloop4
ll1:
	add esi,4
	jmp printloop4
ll2:
	add esi,8
	jmp printloop4
ll3:
	add esi,12
	jmp printloop4
ll4:
	add esi,16
	jmp printloop4

printloop4:
	call printloop

exit:
	mov eax,1
	mov ebx,0
int 80h

string:
	mov esi,num
	mov byte[count],5
	
	print msgol,lenol
	print msg1,len1
	call printloop

	mov esi,num
	mov edi,num1
	
	mov byte[count],5
	cld
back:
	movsd
	dec byte[count]
	jnz back

	mov esi,num1
	mov byte[count],5

	print msg2,len2
	call printloop


	print nl,lennl
	print msgnol,lennol
	print msgoff,lenoff

	read offset,2

	mov esi,num
	mov byte[count],5
	print msg1,len1
	call printloop

	mov esi,num
	add esi,16
	mov al,byte[offset]
	cmp al,30h
	je ls0
	cmp al,31h
	je ls1
	cmp al,32h
	je ls2
	cmp al,33h
	je ls3
	cmp al,34h
	je ls4
	jmp exit

ls0:
	mov edi,esi
	jmp copys
ls1:
	mov edi,esi
	add edi,4
	jmp copys
ls2:
	mov edi,esi
	add edi,8
	jmp copys
ls3:
	mov edi,esi
	add edi,12
	jmp copys
ls4:
	mov edi,esi
	add edi,16
	jmp copys

copys:
	mov byte[count],5
	std
	copy2s:
	movsd
	dec byte[count]
	jnz copy2s

	add esi,4

	mov byte[count],5
	print msg2,len2
	mov al,byte[offset]
	cmp al,30h
	je lls0
	cmp al,31h
	je lls1
	cmp al,32h
	je lls2
	cmp al,33h
	je lls3
	cmp al,34h
	je lls4
	jmp exit

lls0:
	jmp printloop8
lls1:
	add esi,4
	jmp printloop8
lls2:
	add esi,8
	jmp printloop8
lls3:
	add esi,12
	jmp printloop8
lls4:
	add esi,16
	jmp printloop8

printloop8:
	call printloop

	mov eax,1
	mov ebx,0
	int 80h

convaddr:
	mov eax,dword[addr]
	mov byte[cnt],8
	mov edi,addr
	
up:
	rol eax,04
	mov bl,al
	AND bl,0xF
	cmp bl,0x9
	jbe loop
	add bl,0x7
loop:
	add bl,0x30
	mov byte[edi],bl
	inc edi
	dec byte[cnt]
jnz up
RET

convnum:
	mov byte[cnt],8
	mov edi,number

up1:
	rol eax,04
	mov bl,al
	AND bl,0xF
	cmp bl,0x9
	jbe loop1
	add bl,0x7
loop1:
	add bl,0x30
	mov byte[edi],bl
	inc edi
	dec byte[cnt]
	jnz up1
	RET

printloop:

	mov dword[addr],esi
	print space,lensp
	mov eax,dword[esi]
	call convnum
	print number,8
	print space,lensp
	call convaddr
	print addr,8
	print nl,lennl
	add esi,4
	dec byte[count]
	jnz printloop
	RET
