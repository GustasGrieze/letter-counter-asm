.model small               
.stack 100h                

.data                       
	input db "Iveskite teksta: $" 
	output db 10,13,"ivestu raidziu skaicius: $" 
	ten dw 10                   

.code                       
start:
	mov ax, @data               ; Load address of the data segment into AX.
	mov ds, ax                  ; Move the data segment address into DS.

	lea dx, input                ; Load effective address of input into DX.
	mov ah, 09h                 ;print string 
	int 21h                     

	mov cx, 0                  

readString:                     
	mov ah, 01h                 
	int 21h                     ; read character.
	cmp al, 13                  ; Compare the input character with line brake.
	je endReading                 
	cmp al, 'A'                 
	jb checkLower               ; If character < 'A', check if it's a lowercase.
	cmp al, 'Z'                 
	ja checkLower               ; If character > 'Z', check if it's lowercase.
	inc cx                      
	jmp readString              

checkLower:                 
	cmp al, 'a'                 
	jb readString                   ; If character < 'a', return to readString.
	cmp al, 'z'                 
	ja readString                   ; If character > 'z', return to readString.
	inc cx                      ; If it's a lowercase letter, increment the counter.
	jmp readString                  

endReading:                    
	lea dx, output                ; Load effective address of output into DX.
	mov ah, 09h                 ; print string
	int 21h                     

	mov ax, cx                  
	mov cx, 0                  

convertToInt:                     
	mov dx, 0                  
	div ten                     ; Divide AX by ten. Number in AX, remainder in DX.
	add dx, 30h                 ; Convert remainder to ASCII.
	push dx                     ; Push the ASCII character onto stack.
	inc cx                      
	cmp ax, 0                   
	ja convertToInt                   ; If not, repeat the conversion for next digit.

printInt:                   
	pop dx                      ; Pop the top of the stack into DX.
	mov ah, 02h                 ; Function code for print character in DOS interrupt.
	int 21h                     
	loop printInt              

	mov ax, 4C00h               
	int 21h                     
end start                   

