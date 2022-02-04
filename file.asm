;----------------------------------------------------------- 
; Printing ASCII in a loop around the wall
; Printing ASCII character * on the screen in infinite loop
[org 0x100]
jmp start
clrscr: 	
    push es
		push ax
		push di 

		mov ax, 0xb800
		mov es, ax 	; point es to video base
		mov di, 0 	; point di to top left column

nextloc: 	
    mov word [es:di], 0x0720 	; clear next char on screen
		add di, 2  	 ; move to next screen location
		cmp di, 4000 			; has the whole screen cleared
		jne nextloc 			; if no clear next position
	
		pop di
		pop ax
		pop es
		ret 
printstar:
		push bp
		mov bp, sp
		push es
		push ax
		push cx
		push si
		push di
		mov ax, 0xb800
		mov es, ax 		; point es to video base
		mov al, 80 		; load al with columns per row
		mul byte [bp+10]	; multiply with row number
		add ax, [bp+8]; add col
		shl ax, 1 		; turn into byte offset
		mov di, ax 		; point di to required location
		mov cx, [bp+4]
		sub cx, [bp+8]
topLine:	
    mov ax, 0x072A           
		mov [es:di], ax 	; show this char on screen
		add di, 2 		; move to next screen location 
		loop topLine		; repeat the operation cx times
		mov cx, [bp+6]
		sub cx, [bp+10]
		add di, 160
rightLine:	
    mov ax,0x072A      ; Ascii of *      
		mov [es:di], ax 	; show this char on screen
		add di, 160 		; move to next screen location 		
		loop rightLine		; repeat the operation cx times
		mov cx, [bp+4]
		sub cx, [bp+8]
		sub di, 2
bottomLine:	 
    mov ax,0x072A; Ascii of *
		mov [es:di], ax 	; show this char on screen
		sub di, 2 		; move to next screen location 
		loop bottomLine		; repeat the operation cx times
		mov cx, [bp+6]
		sub cx, [bp+10]
		sub di, 160
leftLine:	
    mov ax,0x072A      ; Ascii of *
		mov [es:di], ax 	; show this char on screen
		sub di, 160 		; move to next screen location 		
		loop leftLine		; repeat the operation cx time
		pop di
		pop si
		pop cx
		pop ax
		pop es
		pop bp
		ret 8
start:
    call clrscr
		mov ax, 0
		push ax 		; push top
		mov ax, 1
		push ax 		; push left
		mov ax, 23
		push ax 		; push bottom
		mov ax, 79
		push ax 		; push right number
		call printstar
		mov ax, 0x4c00
		int 0x21         ; programme terminated
;--------------------------------------------------------------------------
