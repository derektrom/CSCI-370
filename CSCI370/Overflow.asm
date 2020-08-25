.text
  li  $a0, 2147483647

   # largest signed word is
   #   0x7FFFFFFF = 231-1
   # = 2,147,483,647
   #   80 00 00 00 = 2^31
   #   -         1 
   #   -------------
   #$a0  = 7F FF FF FF = 2^31 -1
   #     +           1
   #     --------------
   #       80 00 00 00 = -2^31

  add $a0, $a0, 1
  li  $v0, 1
  syscall                 
  li  $v0, 10
  syscall
  
.text
  li   $a0, 2147483647

   # largest signed word is
   #   0x7FFFFFFF = 231-1
   # = 2,147,483,647
   #    80 00 00 00 = 2^31
   #   -          1 
   #   -------------
   #$a0  = 7F FF FF FF = 2^31 -1
   #     +           1
   #     --------------
   #       80 00 00 00 = 2^31 
   # -2147483648

  addu $a0, $a0, 1
  li   $v0, 1
  syscall                 
  li   $v0, 10
  syscall