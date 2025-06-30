.model small
.stack 100h

.data 
    enter_msg db 'Enter a$'        
    neg_msg db ' Negation : $'
    bin_msg db ' Binary # : $'   
    dec_msg db ' Decimal # : $'
    res db  0dh, 0ah, 'Result:', 0dh, 0ah, '$'
    signed_dec_msg db ' Sign Decimal # : $'  
    unsigned_dec_msg db ' Un-Sign Decimal # : $'
    hex_msg db ' HexaDecimal # : $'
    choice_msg db 0dh, 0ah, 'Conversion you want to preform?', 0dh, 0ah, '    (b) Binary' ,0dh, 0ah, '    (d) Decimal' ,0dh, 0ah, '    (h) Hexadecimal' ,0dh, 0ah, '    (e) Exit', 0dh, 0ah, 'Choose: $'
    done_msg db 0dh, 0ah, ' ===== Done Conversion =====$'
    GB db 0dh, 0ah, '    Good bye  :)$'
    choice db ? 
    num dw ? 
    d db 'd'
    b db 'b'
    h db 'h' 

.code   
; ------------------- Macro -------------------- 
symbol macro sym
    push ax
    push dx
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    mov ah, 02h
    mov dl, sym
    int 21h
    
    pop dx
    pop ax    
endm

main proc
    mov ax, @data
    mov ds, ax
restart:                        ; label for coversion start from begning
    lea dx, choice_msg
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    mov choice, al
    
    call newline
    call newline
    
    cmp choice, 'e'
    je terminate                ; agar 'e' press kar dia to finaly exit
    
    cmp choice, 'b'
    je binary
    cmp choice, 'd'
    je decimal
    cmp choice, 'h'
    je hexadecimal
    jmp done
    
    lea dx, enter_msg           ; you know user want any conversion
    mov ah, 09h
    int 21h  
    
binary:
    call input_binary  
    
    done_bin_input: 
    
    mov num, bx
    
    call newline
    call result
    call output_binary
    symbol b
    
    mov bx, num             
    call newline
    call negation
    symbol b
    
    call newline
    call unsigned_output_decimal
    symbol d  
    
    call newline
    call signed_output_decimal
    symbol d
        
    mov bx, num
    call newline
    call output_hexadecimal
    symbol h
    
    call newline
    call doneMessage
    call newline
    
    jmp done
    
decimal:
    call input_decimal
    
    mov bx, num 
    call newline
    call result
    call output_binary 
    symbol b
        
    mov bx, num            
    call newline
    call negation
    symbol b
    
    mov bx, num
    call newline
    call output_hexadecimal
    symbol h
     
    call newline
    call doneMessage
    call newline
    
    jmp done

hexadecimal:
    call input_hexadecimal
    
    mov num, bx
    
    call newline
    call result
    call output_binary  
    symbol b
    
    mov bx, num
    call newline
    call negation
    symbol b
    
    call newline
    call unsigned_output_decimal
    symbol d
     
    call newline
    call signed_output_decimal
    symbol d     
    
    call newline
    call doneMessage
    call newline
    
    jmp done

done:
    jmp restart
terminate:
    lea dx, GB
    mov ah, 09h
    int 21h
    
    mov ax, 4C00h
    int 21h
main endp  
 
;----------------------------------------------------------------------------- 

input_binary proc 
    st:
    mov ah, 09h
    lea dx, bin_msg
    int 21h
    
    xor bx,bx          
    
    mov cx,16 
    mov ah, 01h
    lable: 
        int 21H

        cmp al,13
        je done_bin_input   ; exit point 
        
        cmp al, '0'         
        je valid_input      
        cmp al, '1'         
        je valid_input      
        call newline
        jmp st          
        
        valid_input:                    
        and al, 0Fh         ; convert input in ASCII
        shl bx,1            ; create space for new inpur
        or bl,al            ; put in created space
        cmp cx,1
        je done_bin_input   ; exit point
        loop lable 
    
input_binary endp

;----------------------------------------------------------------------------- 

output_binary proc
    mov ah, 09h
    lea dx, bin_msg
    int 21h
    
    mov cx, 16
display:
    shl bx, 1              ; char goes to carry flag
    
    jnc next               ; check carry flag having 1 or 0
    mov dl, 49             ; if 1
    mov ah, 02h
    int 21h
    jmp end_display
next:
    mov dl, 48             ; if 0
    mov ah, 02h
    int 21h                                    
    

end_display:
; ------ space ka maslay 
    cmp cx, 5
    je add_space
    cmp cx, 9
    je add_space
    cmp cx, 13
    je add_space
    jmp skip_space
    
add_space:
    mov ah, 02h
    mov dl, ' '
    int 21h 
    skip_space:
    
    loop display
    ret
                                       
output_binary endp

;-----------------------------------------------------------------------------

input_decimal proc            ; range -32768 to 32767

    push bx                 ; save registers used
    push cx                   
    push dx                   
      
    mov ah, 09h
    lea dx, dec_msg
    int 21h
            
begin:                          
                       
      xor bx,bx               ; bx holds total
              
      xor cx,cx               ; for cx holds sign
;read a character               
      mov ah,1                  
      int 21h                 ; character in al
;case character of              
      cmp al,'-'              ; minus sign?
      je minus                ; yes, set sign
      cmp al,'+'              ; plus sign
      je plus                 ; yes, another character
      jmp repeat2             ; start processing characters
minus:                          
      mov cx,1                ; negative a gya hai true
plus:                           
      int 21h                 ; continue to read a character       

repeat2:

      cmp al, '0'              
      jnge not_digit          ; 0 >= al <= 9
      cmp al, '9'              
      jnle not_digit          
                              
      and ax, 0fh             ; convert to digit
      push ax                 ; save on stack
                              ; total = total * 10 + digit
      mov ax,10               ; get 10
      mul bx                  ; ax = total(bx) * 10 'result goes in ax'
      pop bx                  ; retrieve digit
      add bx,ax               ; total = total * 10 + digit
              
      mov ah,1                ; read a character   
      int 21h                   
      cmp al,0dh              ; is carriage return?
      jne repeat2             ; next input

; jab tak enter press nai ho ga (carriage return)                       
      mov ax,bx               ; store number in ax

      ; if negative                    
      or cx,cx                ; negative number
      je exit                 ; no, exit
      ; then                           
      neg ax                  ; yes, negate
;end_if                         
exit:                           
      pop dx                  ; restore registers
      pop cx
      mov num, bx
      pop bx
      ret                     ; and return

;here if illegal character entered
not_digit:
      call newline 
      push ax
      push dx
      mov ah, 09h
      lea dx, dec_msg
      int 21h
      pop dx
      pop ax
      jmp begin
   
input_decimal endp

;-----------------------------------------------------------------------------

unsigned_output_decimal proc
            
       push ax              ; save registers
       push bx                
       push cx                
       push dx
              
    mov ah, 09h
    lea dx, unsigned_dec_msg
    int 21h
    
       mov ax, num          ; output_decimal function works on AX
         
end_if1:                      
          
       xor cx,cx            ; cx counts digits
       mov bx,10d           ; bx has divisor 
repeat1:                      
       xor dx,dx            ; prepare high word of dividend
       div bx               ; gives ax = quotient, dx = remainder
       push dx              ; save remainder on stack
       inc cx               ; count++
                        
       or ax,ax             ; if quotient = 0              
       jne repeat1          ; no keep going

       mov ah,2             

; knock knock remainder cx           
print_loop:                   
       pop dx               ; digit in dl
       or dl,30h            ; convert to character
       int 21h             
       loop print_loop      
                     
       pop dx               
       pop cx
       pop bx  
       pop ax   
       ret
    
unsigned_output_decimal endp

;-----------------------------------------------------------------------------

signed_output_decimal proc
       push ax             
       push bx                
       push cx                
       push dx  
       
    mov ah, 09h
    lea dx, signed_dec_msg
    int 21h
        
       mov ax, num
                           
       or ax,ax             ; ax < 0
       jge end_if1_         ; no, > 0
      
       push ax              ; save number
       mov dl,'-'           ; get '-'
       mov ah,2             ; print char function
       int 21h              ; print '-'
       pop ax               ; get ax back  
       
       ;===============================
         neg ax            ; ax = -ax 
       ;===============================
            
end_if1_:                                                   
       xor cx,cx            ; counts digits
       mov bx,10d           ; bx has divisor 
repeat1_:                     
       xor dx,dx            ; prepare high word of dividend
       div bx               ; ax = quotient, dx = remainder
       push dx              ; save remainder on stack
       inc cx               ; count++
                        
       or ax,ax             ; quotient = 0              
       jne repeat1_         ; no keep going
                            
       mov ah,2              

; knock knock remainder cx           
print_loop_:                  
       pop dx               ; digit in dl
       or dl,30h            ; convert to character
       int 21h              
       loop print_loop_    
                     
       pop dx              
       pop cx
       pop bx  
       pop ax   
       ret
    
signed_output_decimal endp

;-----------------------------------------------------------------------------

input_hexadecimal proc 
       push ax                
       push cx                
       push dx  
       
    mov ah, 09h
    lea dx, hex_msg
    int 21h
    
    xor bx,bx
    mov cx, 4
    mov ah, 1
    int 21h
    
    while_:
        cmp al,0dh
        je end_while
        
        cmp al, 39h
        jg letter
        
        and al, 0fh
        jmp shift       
        
        letter:
            sub al, 37h
            
        shift:
            shl bx, cl
            or bl, al
            
            int 21h
            jmp while_
    end_while:
                         
       pop dx              
       pop cx
       pop ax 
       ret    
input_hexadecimal endp

;-----------------------------------------------------------------------------

output_hexadecimal proc 
       push ax                
       push cx                
       push dx  
       
    mov ah, 09h
    lea dx, hex_msg
    int 21h
    
    mov cx, 4
    mov ah, 2
    
    for:
        mov dl, bh
        shr dl, 4
        shl bx, 4
        
        cmp dl, 10
        jge alphabet
        
        add dl, 48    ; in case of digit
        int 21h
        jmp end_of_loop
        
        alphabet:
            add dl, 55
            int 21h
            end_of_loop:
        
        loop for
                         
       pop dx              
       pop cx  
       pop ax 
       ret
output_hexadecimal endp

;-----------------------------------------------------------------------------

NEWLINE PROC
    push AX
    Push DX
    
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    
    Pop DX
    Pop AX
    RET
    
NEWLINE ENDP

;-----------------------------------------------------------------------------

doneMessage PROC
    push AX
    Push DX
    
    lea dx, done_msg
    mov ah, 09h
    int 21h
    
    Pop DX
    Pop AX
    ret
doneMessage ENDP

;-----------------------------------------------------------------------------
 
 result PROC
    push AX
    Push DX
    
    lea dx, res
    mov ah, 09h
    int 21h
    
    Pop DX
    Pop AX
    ret
result ENDP

;-----------------------------------------------------------------------------

negation proc
    mov ah, 09h
    lea dx, neg_msg
    int 21h
    
    neg bx
    mov cx, 16
dis:
    shl bx, 1              ; print BX which stores number
    
    jnc next_
    mov dl, 49
    mov ah, 02h
    int 21h
    jmp end_display_
next_:
    mov dl, 48
    mov ah, 02h
    int 21h

end_display_:
        
    cmp cx, 5
    je add_space_
    cmp cx, 9
    je add_space_
    cmp cx, 13
    je add_space_
    jmp skip_space_
    
add_space_:
    mov ah, 02h
    mov dl, ' '
    int 21h                                      
skip_space_:                                    

    loop dis
    ret
                                       
negation endp 

;-----------------------------------------------------------------------------