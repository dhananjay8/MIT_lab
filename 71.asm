section .data
	 msg1 db 10, 'Mean:  '
	 msg1len equ $- msg1
	 msg2 db 10, 'Standard Deviation:'
	 msg2len equ $- msg2
	 msg3 db 10, 'Variance:'
	 msg3len equ $- msg3
	 nl db "",10
	 lenl equ $-nl

	 data dd 100.00,200.00,300.00
	 datacnt dw 03
	 hdec dq 100
	 decpt db '.'
	 
section .bss
	res rest 01
	mean resd 01
	var resd 01 
	dispbuff resb 01
	 
	%macro write 2
	 mov eax,04
	 mov ebx,01
	 mov ecx,%1
	 mov edx,%2
	 int 80h
	%endmacro
 
section .text
 global _start
_start:
	write msg1,msg1len
	 
	finit			;Initialize floating point processor
	fldz			;Load constant onto stack, 0.0		;FLDZ
	mov rbx,data
	mov rsi,00
	xor rcx,rcx
	mov cx,[datacnt]
	 
bk: 	fadd dword [rbx+rsi*4]	;Floating point add to st result in 
				;st stack pointer increased 		;FADD
	inc rsi
	loop bk
	 
	fidiv word[datacnt]	;Integer divide				;FIDIV
	fst dword[mean]		;store real to destination from st	;FST
	 
	call dispres
	 
	MOV RCX,00
	MOV CX,[datacnt]
	MOV RBX,data
	MOV RSI,00
	FLDZ
up1: 	FLDZ
	FLD DWORD[RBX+RSI*4]	;Floating point load source real to st	;FLD
	FSUB DWORD[mean]	;Floating point subtract		;FSUB
	FST ST1
	FMUL			;Floating point multiply st x st(1)=st	;FMUL
	FADD
	INC RSI
	LOOP up1
	FIDIV word[datacnt]
	FST dWORD[var]
	FSQRT			;Square root
 
	write msg2,msg2len
	CALL dispres
	 
	FLD dWORD[var]
	write msg3,msg3len
	CALL dispres
 	
	write nl,1
exit: 	mov eax,01
	mov ebx,00 
	int 80h
 
disp8_proc:
	mov rdi,dispbuff
	mov rcx,02
back: 	rol bl,04
	mov dl,bl
	and dl,0FH
	cmp dl,09
	jbe next1
	add dl,07H
next1: 	add dl,30H
	mov [rdi],dl
	inc rdi
	loop back
	ret
 
dispres:
	fimul dword[hdec]		;Integer multiply	;FIMUL
	fbstp tword[res]		;Store real BCD and pop	;FBSTP
	xor rcx,rcx
	mov rcx,09H
	mov rsi,res+9
up2: 	push rcx
	push rsi
	mov bl,[rsi]
	call disp8_proc
	write dispbuff,2 
	pop rsi
	dec rsi
	pop rcx
	loop up2
	write decpt,1
	 
	mov bl,[res]
	call disp8_proc
	write dispbuff,2 
	ret
