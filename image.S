
.data
.equ img_wid,0
.equ img_hit,4
.equ img_array,8
.equ img_size,16

.equ pixel,0
.equ pixel_size,8

.text
 
.global create_image
//
// void *create_image(int wid, int hit)
// Create an image ADT and return it.
//
create_image:
  stp x29,x30,[sp,#-16]!
  stp x19,x20,[sp,#-16]!
  stp x21,x22,[sp,#-16]!

  //sub w19,w0,#1
  //sub w20,w1,#1
  mov w19,w0
  mov w20,w1

  mov w0,#1
  mov w1,#img_size
  bl calloc

  str w19,[x0,#img_wid]
  str w20,[x0,#img_hit]

  mov x21,x0

  mul w0,w19,w20
  mov w1,#pixel_size
  bl calloc

  str x0,[x21,#img_array]
  mov x0,x21

  ldp x21,x22,[sp],#16
  ldp x19,x20,[sp],#16
  ldp x29,x30,[sp],#16
  ret
    
    
.global destroy_image   
//
// void destroy_image(void *image)
// Destroy image, freeing memory
//
destroy_image:
  stp x29,x30,[sp,#-16]!
  stp x19,x20,[sp,#-16]!

  mov x19,x0
  

  
  ldr x0,[x0,#img_array]
  bl free

  mov x0,x19
  bl free

  ldp x19,x20,[sp],#16
  ldp x29,x30,[sp],#16 
  ret
    
    
.global get_width
//
// int get_width(void *image)
// Get the width of the image
//
get_width:
    ldr w0,[x0,#img_wid]
    ret
    
.global get_height
//
// int get_height(void *image)
// Get the height of the image
//
get_height:
    ldr w0,[x0,#img_hit]
    ret
    
        
.global set_pixel
//
// void set_pixel(void *image, int row, int col, double value)
//
set_pixel:
    stp x29,x30,[sp,#-16]!
    stp x19,x20,[sp,#-16]!

    //mov d19,d3
    bl pixel_index

    str d0,[x0,#pixel]

    ldp x19,x20,[sp],#16
    ldp x29,x30,[sp],#16 
    ret

.global get_pixel
//
// double get_pixel(void *image, int row, int col)
//
get_pixel:
  stp x29,x30,[sp,#-16]!
  
  bl pixel_index
  ldr d0,[x0,#pixel]
    
  ldp x29,x30,[sp],#16
    ret

.global pixel_index
pixel_index:
  stp x29,x30,[sp,#-16]!

  ldr w7,[x0,#img_wid]
  
  mul w5,w1,w7
  add w5,w5,w2
  mov w6,#pixel_size
  mul w5,w5,w6

  ldr x4,[x0,#img_array]
  add x4,x4,w5,uxtw

  mov x0,x4

  ldp x29,x30,[sp],#16
  ret
