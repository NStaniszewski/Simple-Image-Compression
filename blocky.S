.data
.balign 8
zero: .double 0
sixtyfour: .double 8 

.text

.global blocky
//
// void *blocky(void *src)
//
blocky:
  fp .req x29
  lr .req x30

  .equ f_src,16
  .equ f_dest,24
  .equ f_wid,32
  .equ f_hit,36
  .equ f_size,48

  stp fp,lr,[sp,#-f_size]!
  mov fp,sp

  stp x19,x20,[sp,#-16]!
  stp x21,x22,[sp,#-16]!
   
  str x0,[fp,#f_src] 
 
  ldr x0,[fp,#f_src] 
  bl get_width
  str w0,[fp,#f_wid]

  ldr x0,[fp,#f_src]
  bl get_height
  str w0,[fp,#f_hit]

  ldr w0,[fp,#f_wid]
  ldr w1,[fp,#f_hit]
  bl create_image
  str x0,[fp,#f_dest] 

  ldr x7,=zero
  ldr d1,[x7] //sum starts on 0
  ldr d3,[x7] //extra zero to reset sum

  ldr x7,=sixtyfour
  ldr d2,[x7] //64 to divide by for average
  //make local stack on fp with all the needed stuff to do the project
  mov w19,#0
  mov w20,#0

make_image:
  ldr w7,[fp,#f_wid]
  cmp w19,w7
  bge blocky_end

  mov w20,#0
make_col:
  ldr w7,[fp,#f_hit]
  cmp w20,w7
  bge make_col_end
  
  mov w21,#0
  
get_loop:
  cmp w21,#8
  beq get_loop_end
  mov w22,#0

get_loop_inner:
  cmp w22,#8
  beq set_loop_inner_end
  add w2,w19,w21
  ldr w7,[fp,#f_wid]
  cmp w2,w7
  blt get_wid_cont
  sub w2,w7,#1

get_wid_cont:
  add w1,w20,w22
  ldr w7,[fp,#f_hit]
  cmp w1,w7
  blt get_hit_cont
  sub w1,w7,#1

get_hit_cont:
  ldr x0,[fp,#f_src]
  bl get_pixel
  fadd d1,d1,d0

get_loop_inner_end:
  add w21,w21,#1
  b get_loop 
  
get_loop_end:
  fdiv d0,d1,d2
  fmov d1,d3
  mov w21,#0
  mov w22,#0
set_loop:
  cmp w21,#8
  beq set_loop_end
  mov w22,#0

set_loop_inner:
  cmp w22,#8
  beq set_loop_inner_end
  add w2,w19,w21
  ldr w7,[fp,#f_wid]
  cmp w2,w7
  blt set_wid_cont
  sub w2,w7,#1

set_wid_cont:
  add w1,w20,w22
  ldr w7,[fp,#f_hit]
  cmp w1,w7
  blt set_hit_cont
  sub w1,w7,#1

set_hit_cont:
  ldr x0,[fp,#f_dest]
  bl set_pixel
  
  add w22,w22,#1
  b set_loop_inner
   
set_loop_inner_end:
  add w21,w21,#1
  b set_loop

set_loop_end:
  add w20,w20,#8
  b make_col

make_col_end:
  add w19,w19,#8
  b make_image

blocky_end:
  ldr x0,[fp,#f_dest]

  ldp x21,x22,[sp],#16
  ldp x19,x20,[sp],#16
  ldp fp,lr,[sp],#f_size 
  ret
