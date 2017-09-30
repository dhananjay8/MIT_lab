section .bss
extern l1,l2,cnt,str1,str2,str3
global concat,substr

lencnt: resb 1	;temp len count

section .text

concat:
	mov rsi,str1
	mov rdi,str3
	
up1:	mov bl,[rsi]
	mov [rdi],bl
	inc rsi
	inc rdi
	
	dec byte[l1]
	jnz up1

	mov rsi,str2
up2:	
	mov bl,[rsi]
	mov [rdi],bl
	inc rsi
	inc rdi
	
	dec byte[l2]	
	jnz up2

	ret

substr:
	mov rsi,str1
	mov rdi,str2
	

loop1:	mov al,[rsi]
	cmp [rdi],al
	jne loop4

	mov cl,byte[l2]

	mov byte[lencnt],cl
	dec byte[lencnt]
	jz loop3

loop2:	inc rsi
	inc rdi
	dec byte[l1]

	mov al,[rsi]
	cmp [rdi],al
	jne loop4

	dec byte[lencnt]
	jnz loop2

loop3:	inc byte[cnt]

loop4:	mov rdi,str2
	inc rsi
	
	dec byte[l1]
	jnz loop1	

	ret
	

	
