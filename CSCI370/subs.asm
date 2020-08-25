.data
 n:    .word   0
 ans:  .word   0

       .text
 main: li    $v0, 5
       syscall
       sw    $v0, n
       j     calc
 ret:  lw    $a0, ans
       li    $v0, 1
       syscall

 end:  li    $v0, 10
       syscall


 ###### calc routine ######

 calc: lw    $t0, n
       li    $t1, 0
       sw    $t1, ans
 next: 
       beqz $t0, ret

       add   $t1, $t1, $t0
       sw    $t1, ans
       sub   $t0, $t0, 1
       j     next
.data
 n:    .word   0
 ans:  .word   0

       .text
 main: li    $v0, 5
       syscall
       sw    $v0, n
       jal   calc
       lw    $a0, ans
       li    $v0, 1
       syscall

 end:  li    $v0, 10
       syscall


 ###### calc subroutine ######

 calc: lw    $t0, n
       li    $t1, 0
       sw    $t1, ans
 next: 
       bnez $t0, cont

       jr    $31

 cont: add   $t1, $t1, $t0
       sw    $t1, ans
       sub   $t0, $t0, 1
       j     next
