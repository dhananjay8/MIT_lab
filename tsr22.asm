.model tiny		
.stack 100 		

.code 			;start of code segment

org 100h		
jmp init		
resident_part:	

push ax			
push bx
push cx
push dx
push es
push di

mov ax,0b800h 	;start of DOS display RAM.
mov es,ax		;position on screen.
mov di,3660		


mov ah,02h		;gives RTC time 
int 1ah			

mov al,ch       	;hours                                     
mov bh,cl 			;minutes
mov bl,dh 			;seconds

mov ah,12			;

call disp 			;disp works on data in AL, 

mov al,':' 			;
mov es:[di],ax 		;AH = attribute of pixel, AL = ASCII of stuff to print
add di,02 			;move cursor ahead by 2

mov al,bh			;disp will work on minutes
call disp

mov al,':' 			;print : separately
mov es:[di],ax
add di,02

mov al,bl 			;disp will work on seconds
call disp

pop di 	;restore  
pop es
pop dx
pop cx
pop bx
pop ax

jmp dword ptr cs:old_ip		;If this line is removed, clock is static and terminal hangs.

disp proc near	

mov cl,04h 		
mov ch,02h		
mov dl,al 		 

l1: 
rol dl,cl 		
mov al,dl
and al,0fh		
add al,30h		

mov es:[di],ax
add di,02 		

dec ch
jnz l1
ret
endp
 
old_ip dw ?		
old_cs dw ?


init:		;transient part, 

push cs 	
pop ds 		

mov ah,35h	
mov al,08h 	
int 21h
mov old_cs,es	;of original interrupt handler.
mov old_ip,bx	

mov ah,25h		;set interrupt handler. replace resident part of our TSR.
mov al,08h
lea dx,resident_part	
int 21h

mov ah,31h		
mov al,00h
lea dx,init		
int 21h

end

%% offset = [ (no. of rows completed * no. of total colmuns)+no. of present colmun] * 2.
