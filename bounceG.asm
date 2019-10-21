.Model Small
draw_row Macro x
    Local l1
    ; draws a line in row x from col 10 to col 320
    MOV AH, 0CH
    MOV AL, 4 ; red
    MOV CX, 0
    MOV DX, x
L1: INT 10h
    INC CX
    CMP CX, 320
    JL L1
    EndM
    
draw_col Macro y
    Local l2
; draws a line col y from row 10 to row 189
    MOV AH, 0CH
    MOV AL, 0
    MOV CX , y
    mov bx , 46
L2: INT 10h
    INC DX
    DEC bx
    CMP bx,0
    JG L2
    EndM
    


.Stack 100h
.Data
new_timer_vec   dw  ?,?
old_timer_vec   dw  ?,?
timer_flag  db  0
vel_x       dw  1
vel_y       dw  1
car_length  dw  66
car_width   dw  46
car_colomn  dw  0
car_colomn_1  dw  252
car_colomn_2  dw  252
car_colomn_3  dw  252
car_checker_1 dw 0
car_checker_2 dw 0
car_row     dw  0
my_car_row dw 0
my_car_colomn dw 0
user_row dw 76
count       dw  0
clear db 1
score db 'SCORE:-$'
scoring1 db 12
colour1 db 0Fh
end_game_checker db 0
final_score db 0

.Code
    
set_display_mode Proc
; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 13h; 320x200 4 color
    INT 10h
; select palette    
    ;MOV AH, 0BH
    ;MOV BH, 1
    ;MOV BL, 0
    ;INT 10h
; set bgd color
    MOV BH, 0
    MOV BL, 0; black
    INT 10h
    ; draw roads
    draw_row 66
    draw_row 133
    
    RET
set_display_mode EndP

car_structure Proc
    ; select palette
    ;MOV AH, 0BH
    ;MOV BH, 1
    ;MOV BL, 1
    ;INT 10h
    
    mov cx,car_width
    loop19:
    mov bx,cx
    MOV AH, 0CH
    MOV AL, colour1
    MOV CX, car_colomn
    mov count,0
    MOV DX, car_row
    L29: INT 10h
    INC CX
    inc count
    push cx
    push dx
    mov cx,count
    mov dx,car_length
    CMP cx,dx
    pop dx
    pop cx
    JL L29
    mov cx,bx
    inc car_row
    loop loop19
    

    RET
car_structure EndP

allBlack Proc
mov cx,200
MOV DX, 0
loop1:
    mov bx,cx
    MOV AH, 0CH
    MOV AL, 0
    MOV CX, 250
    mov count,322
L2: INT 10h
    INC CX
    cmp count,cx
    JG L2
    mov cx,bx
    inc dx
    loop loop1
    RET

allBlack endp



display_car Proc
    cmp car_colomn_1,-67
    jz car_colomn_11
    cmp car_colomn_2,-67
    jz car_colomn_21
    cmp car_colomn_3,-67
    jz car_colomn_31
    crazy:
    mov car_row,10
    mov bx,car_colomn_1
    mov car_colomn,bx
    call car_structure
    
    cmp car_colomn_1,75
    jz jao1
    cmp car_colomn_1,160
    jz jao2
    jeikhane_issa:
    cmp car_checker_1,0
    jz crazy1
    mov car_row,76
    mov bx,car_colomn_2
    mov car_colomn,bx
    call car_structure
    
    crazy1:
    cmp car_checker_2,0
    jz htp
    mov car_row,142
    mov bx,car_colomn_3
    mov car_colomn,bx
    call car_structure
    jmp htp
    car_colomn_11:
        mov car_colomn_1,250
        inc final_score
        jmp crazy
    car_colomn_21:
        mov car_colomn_2,250
        inc final_score
        jmp crazy
    
    car_colomn_31:    
        mov car_colomn_3,250
        inc final_score
        jmp crazy
        
    jao1:
        mov car_checker_1,1
        jmp jeikhane_issa  
    jao2:
        mov car_checker_2,1
        jmp jeikhane_issa
    htp:
        
    RET
display_car EndP


move_car Proc
    
dec car_colomn_1
cmp car_checker_2,0
jz go1
cmp car_checker_1,0
jz go2
dec car_colomn_2
go2:
dec car_colomn_3
go1:
call display_car
mov cx,car_colomn_1
add cx,car_length
mov dx,10
draw_col cx

mov cx,car_colomn_2
add cx,car_length
mov dx,76
draw_col cx

mov cx,car_colomn_3
add cx,car_length
mov dx,142
draw_col cx

    RET
move_car Endp


my_car Proc
    ;select palette
    ;MOV AH, 0BH
    ;MOV BH, 1
    ;MOV BL, 0
    ;INT 10h
    
    mov cx,car_width
loop11:
    mov bx,cx
    MOV AH, 0CH
    MOV AL, clear
    MOV CX, my_car_colomn
    mov count,0
    MOV DX, my_car_row
L22: INT 10h
    INC CX
    inc count
    push cx
    push dx
    mov cx,count
    mov dx,car_length
    CMP cx,dx
    pop dx
    pop cx
    JL L22
    mov cx,bx
    inc my_car_row
    loop loop11
    RET

my_car Endp

show_my_car Proc
    cmp car_colomn_1,250
    jz hosse
    cmp car_colomn_2,250
    jz hosse
    cmp car_colomn_3,250
    jz hosse
    jmp holo
    hosse:
    call allBlack
    draw_row 66
    draw_row 133

    holo:

    mov ax,user_row 
    mov my_car_row,ax
    mov my_car_colomn,10
    call my_car
    
    RET
show_my_car Endp

move_my_car Proc
mov ah,06h
mov dx,0fffh
int 21h
jz end_move_car

cmp al,48h
jz up
cmp al,50h
jz down
jmp end_move_car

up:
cmp user_row,10
jz end_move_car
mov clear,0
call show_my_car
mov ax,66
sub user_row,ax
mov clear,1
jmp end_move_car


down:
cmp user_row,142
jz end_move_car
mov clear,0
call show_my_car
mov ax,66
add user_row,ax
mov clear,1
jmp end_move_car


end_move_car:    
  
    RET
move_my_car Endp

score_game Proc
    ; set graphics mode 4
    MOV AH,0h
    MOV AL,4h
    INT 10h
; set bgd color to cyan
    MOV AH, 0BH
    MOV BH, 00h
    MOV BL, 10
    INT 10h
; select palette 0
    MOV BH, 1
    MOV BL, 0
    INT 10h
    ; move cursor to page 0, row x, col y
        MOV AH, 02
        MOV BH, 0
        MOV DH, 0
        MOV DL, 0
        INT 10h
; write char
        mov cx,7
        cld
        lea si,score
    print:
        ;push ax
        ;push bx
        push cx
        ;push dx
        MOV AH, 02
        MOV BH, 0
        MOV DH,12
        MOV DL,scoring1
        INT 10h
        lodsb
        MOV AH, 9
        MOV BL, 2
        MOV CX, 1
        INT 10h
        ;pop dx
        pop cx
        ;pop bx
        ;pop ax
        inc scoring1
        loop print
        
        mov cx,0
        mov bl,10
        cholbe:
        mov al,final_score
        cbw 
        div bl
        mov dx,0
        mov dl,ah
        push dx
        mov final_score,al
        inc cx
        cmp al,0
        jz holly
        jmp cholbe
        holly:
        
        mov count,cx
        print1:
        ;push ax
        ;push bx
        ;push cx
        ;push dx
        MOV AH, 02
        MOV BH, 0
        MOV DH,12
        MOV DL,scoring1
        INT 10h
        pop ax
        MOV AH, 9
        add al ,30h 
        MOV BL, 2
        MOV CX, 1
        INT 10h
        ;pop dx
        ;pop cx
        ;pop bx
        ;pop ax
        inc scoring1
        dec count
        cmp count , 0
        jz bacha_gelo
        jmp print1
        
        bacha_gelo:
        
; getch     
        MOV AH, 0
        INT 16h
; return to text mode
        MOV AX, 3
        INT 10h

    RET
score_game Endp

collision Proc
    cmp user_row,10
    jz road1
    cmp user_row,76
    jz road2
    cmp user_row,142
    jz road3
    
    road1:
        cmp car_colomn_1,76
        jle all_for_1
        jmp ber_hou_ekhon
    
    road2:
        cmp car_colomn_2,76
        jle all_for_1
        jmp ber_hou_ekhon
        
    road3:
        cmp car_colomn_3,76
        jle all_for_1
        jmp ber_hou_ekhon
        
    all_for_1:
        mov end_game_checker,1    
        
    ber_hou_ekhon:
    
    RET
collision endp


timer_tick Proc
    PUSH DS
    PUSH AX
    
    MOV AX, Seg timer_flag
    MOV DS, AX
    MOV timer_flag, 1
    
    POP AX
    POP DS
    
    IRET
timer_tick EndP
    
    
setup_int Proc
; save old vector and set up new vector
; input: al = interrupt number
;    di = address of buffer for old vector
;    si = address of buffer containing new vector
; save old interrupt vector
    MOV AH, 35h ; get vector
    INT 21h
    MOV [DI], BX    ; save offset
    MOV [DI+2], ES  ; save segment
; setup new vector
    MOV DX, [SI]    ; dx has offset
    PUSH DS     ; save ds
    MOV DS, [SI+2]  ; ds has the segment number
    MOV AH, 25h ; set vector
    INT 21h
    POP DS
    RET
setup_int EndP    









main Proc
    MOV AX, @data
    MOV DS, AX
    
    ; set graphics display mode & draw two red line
    CALL set_display_mode
    ; set up timer interrupt vector
    MOV new_timer_vec, offset timer_tick
    MOV new_timer_vec+2, CS
    MOV AL, 1CH; interrupt type
    LEA DI, old_timer_vec
    LEA SI, new_timer_vec
    CALL setup_int
    
    ;call display_car
    
tt:
    CMP timer_flag, 1
    JNE tt
    MOV timer_flag, 0
    cmp end_game_checker,1
    jz bachlam_code_shesh
    CALL move_car
    call show_my_car
    call move_my_car
    call collision
    ;call allBlack
tt2:
    CMP timer_flag, 1
    JNE tt2
    MOV timer_flag, 0
    JMP tt
    
    bachlam_code_shesh:
    call score_game
    
main EndP
End main   
