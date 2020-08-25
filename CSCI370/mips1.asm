.text
  li    $a0, 14
  divu  $a0, $a0, -4
  mfhi  $a0
  li    $v0, 1 
  syscall 
  mflo  $a0
  li    $v0, 1
  syscall
  #$a0 = 14 / -4 =   0(quotient) lo
  #              =  14(remainder) hi 
  #  00 00 00 04
  #  FF FF FF FB
  #+           1
  #-------------
  #  FF FF FF FC = -4
#.data
 #val:  .word   0 

       #.text 
       #li  $v0, 5
       #syscall 
       # Enter 12345.
       #sw  $v0, val
       #lw  $a0, val
       #li  $v0, 1
       #syscall

.data
 val:  .word  0x00100100
 # 0xnn: hexadecimal nn

       .text 
       lh  $a0, val
       li  $v0, 1
       syscall

.data
 s1:  .asciiz  "abc" 

     .text 
     li    $t0, 2
     la    $a0, s1($t0) 
     addi  $t0, $t0, 1
 # addi: add immediate
     
     li    $v0, 4
     syscall
.data
 val2:  .byte  0x01
       .half  0x0302
       .word  0x07060504

       .text 
       la  $t0, val2+1
       lb  $a0, 2($t0) 
       li  $v0, 1
       syscall
.text 
   lui  $a0, 1
   li   $v0, 1
   syscall