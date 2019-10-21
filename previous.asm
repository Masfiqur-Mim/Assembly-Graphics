.Model Small
draw_row Macro x
    Local l1
    ; draws a line in row x from col 10 to col 320
    mov ah, 0ch
    mov al, 0 ; red
    mov cx, 276
    mov dx, x
    L1: int 10h
    inc cx
    cmp cx, 320
    jl L1
    endM
    
    
.stack 100h
.data
game_flag dw 0
score dw 0
len dw 40
color1 db ?
color2 db ?
color3 db ?
u_col dw 05h
u_row dw 48h
m1_col dw 280;upper car coloumn value
m2_col dw 90;middle car coloumn value
m3_col dw 130;lower car coloumn value
wid dw 45
temp dw 0
temp2 dw 0
.code
lane proc
;upper border drawing

mov ah,0ch
mov al,04h
;coloumn start value in cx
;row value in dx 
a:
int 10h
inc cx
cmp cx, 310
jne a
ret
lane endP

draw_car proc
;cx has coloumn value
;dx has row value
;variable len has length of car
;variable wid has width of car
mov al,color1
mov ah,0ch
mov bx,cx
add bx,len
mov temp,dx
mov temp2,dx
push dx
mov dx,wid
add temp,dx
dec temp
pop dx
car:
int 10h
inc dx
cmp dx,temp

jle car
inc cx
mov dx,temp2
cmp cx,bx
jle car
ret
draw_car endP

 
;car moving procedure
move_car proc
cmp m1_col,-41
jle set_car11
after_set_car1:
cmp m2_col,-41
jle set_car22
after_set_car2:
cmp m3_col,-41
jle set_car33
after_set_car3:

mov color1,0
mov cx,m1_col
mov dx,48h
mov al,color1
call draw_car
mov color1,15
sub m1_col,3
mov cx,m1_col
mov dx,48h
mov al,color1
call draw_car
jmp after_draw_car1

set_car11:
inc score
jmp set_car1

after_draw_car1:
mov color1,0
mov cx,m2_col
mov dx,10
mov al,color1
call draw_car
mov color1,15
sub m2_col,2
mov cx,m2_col
mov dx,10
mov al,color1
call draw_car
jmp after_draw_car2
set_car22:
inc score
jmp set_car2

set_car33:
inc score
jmp set_car3

after_draw_car2:
mov color1,0
mov cx,m3_col
mov dx,146
mov al,color1
call draw_car
mov color1,15
sub m3_col,3
mov cx,m3_col
mov dx,146
mov al,color1
call draw_car
jmp finish

set_car1:
mov m1_col,280
draw_row 47h
jmp after_set_car1

set_car2:
mov m2_col,280
draw_row 9
jmp after_set_car2

set_car3:
mov m3_col,280
draw_row 145
jmp after_set_car3

finish: 

ret
move_car endP

;this will check if user has lost the game or not by colliding with a car
lost proc
cmp u_row,48h
je lane2
cmp u_row,10
je lane1
cmp u_row,146
je lane3

lane1:
cmp m2_col,45
jle game_over
jmp play_game

lane2:
cmp m1_col,45
jle game_over
jmp play_game

lane3:
cmp m3_col,45
jle game_over
jmp play_game

game_over:
mov game_flag,1

play_game:
ret
lost endP

;playing this game with keyboard
play_with_key proc
mov color1,01h
mov al,color1
mov cx, u_col
mov dx,u_row
call draw_car
mov color1,15

mov ah,06h
mov dx,0fffh
int 21h
je faltu_press

cmp al,48h;go upside
je above
cmp al,50h;go downside
je below
jmp faltu_press


above:
cmp u_row,10
je faltu_press
mov color1,0
mov al,color1
mov cx, u_col
mov dx,u_row
call draw_car
mov color1,15
mov al,color1
cmp u_row,48h
je go_lane1
cmp u_row,146
je go_lane2
go_lane1:
mov u_row,10
jmp done
go_lane2:
mov u_row,48h
jmp done


faltu_press:
jmp done

below:
cmp u_row,146
je faltu_press
mov color1,0
mov al,color1
mov cx, u_col
mov dx,u_row
call draw_car
mov color1,15
mov al,color1
cmp u_row,48h
je go_lane3
cmp u_row,10
je go_lane2

go_lane3:
mov u_row,146

done:
ret
play_with_key endP

main proc
mov ax,@data
mov ds,ax
;setting display mode
mov ah,0h
mov al,13h
int 10h
mov ah,0bh
mov bh,0
mov bl,0
int 10h

;lane_1
mov cx,0h
mov dx,40h
call lane

;lane_2
mov cx,0h
mov dx, 80h
call lane
game:
;drawing 3 cars and 1 user car
;user car
call play_with_key

;moving all cars
call move_car
call play_with_key
call lost
cmp game_flag,1
je game_off
jmp game 

game_off:


main endP

end main