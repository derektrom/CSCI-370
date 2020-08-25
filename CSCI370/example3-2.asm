.text 
      li    $t0, 0xFF
      li    $t1, -1
      seq   $t0, $t0, $t1
      beqz  $t0, T
      li    $a0, 1
      j     put
 T:   li    $a0, 2
 put: li    $v0, 1
      syscall
.text 
     li    $v0, 5 #$v0 = 5
     syscall
     # input ≥ 0
     li    $a0, 0 # $a0 = 
 L1: 
     slti $t0, $v0, 1

     bnez  $t0, L2
     add   $a0, $a0, $v0
     sub   $v0, $v0, 1
     j     L1
 L2: li    $v0, 1
     syscall
 .text 
     li    $v0, 5
     syscall
     # input ≥ 0
     li    $a0, 0
 L1: 
 slti $t0, $v0, 1

     bnez  $t0, L2
     add   $a0, $a0, $v0
     sub   $v0, $v0, 1
     j     L1
 L2: li    $v0, 1
     syscall
