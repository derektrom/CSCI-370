.text 
   li    $t0, -20
   move  $t1, $t0
   neg   $t1, $t1
   sub   $a0, $t1, $t0
   li    $v0, 1
   syscall