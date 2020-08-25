 .data
board:  .ascii   "\n        | |        1|2|3\n"
        .ascii   "       -----       -----\n"
        .ascii   "        | |        4|5|6\n"      
        .ascii   "       -----       -----\n"
        .asciiz  "        | |        7|8|9\n"

# player moves        
moves:  .byte 0,0,0,0,0,0,0,0,0   # 9 moves

# messages
msg1:   .asciiz   "Start a One-Player Tic-Tac-Toe Game.\n"
msg2:   .asciiz   "\nPick a piece to start (X/O):  "
msg3:   .asciiz   "\nInvalid piece "
msg4:    .asciiz   "X Make you move (1-9): "  
msg5:    .asciiz   "O Make you move (1-9): "
msg6:    .asciiz    "Bad number enterred\n"
msg7:    .asciiz    "Bad move\n"
msg8:    .asciiz    "\nNew Game (Y/N): "
msg9:    .asciiz    "X Wins!\n"
msg10:   .asciiz    "O Wins!\n"
msg11:   .asciiz    "Draw Game\n"
msg12:    .asciiz    "Hit the spacebar to start the System's next move.\n"  
msg13:    .asciiz    "My move is "
msg14:    .asciiz    "I am the System and play first and choose X\n"
msg15:    .asciiz    "I am the System and play first and choose O\n"



# variables
turn:    .byte   0
systurn: .byte   0
count:   .word   0

.text
     
      # print program title
      la   $a0, msg1        # point to msg1
      li   $v0, 4           # specify Print String service
      syscall               # print msg.  
     
     
# choose user or system move first
       li $a1,2
       xor  $a0,$a0,$a0     # get random number 0 to 2
       li   $v0,42
       syscall
       beq  $a0,$zero,system
         
# get start player
sloop:
      la   $a0, msg2        # point to msg2
      li   $v0, 4           # specify Print String service
      syscall               # print msg
     
# enter x or o
      li $v0,12
      syscall

      # validate entry
      beq $v0,'X',startx
      beq $v0,'x',startx
      beq $v0,'O',starto
      beq $v0,'o',starto

# invalid entry message
      la   $a0, msg3        # load address of print message
      li   $v0, 4           # specify Print String service
      syscall               # print message
      b sloop
 

# set tutn to X
startx:
        li   $t0,'X'
        sb   $t0,turn($zero)
        li   $t0,'O'
        sb   $t0,systurn($zero)
        b play
 
# set turn to O
starto:
        li   $t0,'O'
        sb   $t0,turn($zero)
        li   $t0,'X'
        sb   $t0,systurn($zero)
        b  play

# system cj=hooses x it o
system:
       li $a1,2
       xor  $a0,$a0,$a0     # get random number 0 to 2
       li   $v0,42
       syscall
       beq  $a0,$zero,sysx
       li   $t0,'O'
       sb   $t0,systurn($zero)
       li   $t0,'O'
       sb   $t0,turn($zero)
       la   $a0, msg15      # point to msg1
       li   $v0, 4           # specify Print String service
       syscall               # print msg.
       b play
 sysx:
        la   $a0, msg14       # point to msg1
      li   $v0, 4           # specify Print String service
      syscall               # print msg.
       li   $t0,'X'
       sb   $t0,systurn($zero)
       li   $t0,'X'
       sb   $t0,turn($zero)
       b play

# play tic tac toe game
play:
       lb   $t0,turn($zero)   # whose turn

# print board  
       la   $a0, board       # first argument for print (array)
       li   $v0, 4           # specify Print String service
       syscall               # print message
     
# get human turn
        lb   $t0,turn($zero)   # whose turn
        lb   $t1,systurn($zero)
        beq $t0,$t1,cmpturn
        jal getmove
        b   storemove

# get computer turn
cmpturn:

        la   $a0, msg12       # point to msg1
        li   $v0, 4           # specify Print String service
        syscall               # print msg.
     
        li   $v0, 12          # specify read char
        syscall               # print msg.  
     
        jal computer          # system turn
        move $t0,$v0
       
        la   $a0, msg13       # point to msg1
        li   $v0, 4           # specify Print String service
        syscall               # print msg.  
     
        move   $a0, $t0       # point to msg1
        addi   $a0,$a0,1
        li   $v0, 1           # specify Print String service
        syscall               # print msg.
       
        move $v0,$t0
       

#store move
storemove:
        lb  $a0,turn($zero)
        sb  $a0,moves($v0)      # store move

# place player    
        jal place
               
# check for winner
        jal   iswinner
        beq   $v0,1,winner
       
# check for draw
        lw    $t0,count($zero)
        addi  $t0,$t0,1
        sw    $t0,count($zero)
        beq  $t0,9,draw

# switch turn
        lb    $t0,turn($zero)
        beq   $t0,'X',too
        li    $t0,'X'
        sb    $t0,turn($zero)
       
         b     play # continue game

# o's turn        
too:        
        li    $t0,'O'
        sb    $t0,turn($zero)
        b play     # continue game
       
draw:
# print board  
        la   $a0, board       # first argument for print (array)
        li   $v0, 4           # specify Print String service
        syscall               # print message
     
        la   $a0, msg11        # point to msg2
        li   $v0, 4           # specify Print String service
        syscall               # print msg
        b done

# winner found
winner:

# print board  
      la   $a0, board       # first argument for print (array)
      li   $v0, 4           # specify Print String service
      syscall               # print message
     
      lb   $v0,turn($zero)

      beq $v0,'X',xwins     # go to winner
      beq $v0,'O',owins

# x wins
xwins:

      la   $a0, msg9        # point to msg2
      li   $v0, 4           # specify Print String service
      syscall               # print msg
        b done
       
# o wins
owins:

      la   $a0, msg10        # point to msg2
      li   $v0, 4           # specify Print String service
      syscall               # print msg
        b done
       
# ask to play another game  

# done
done:
      la   $a0, msg8        # point to msg1
      li   $v0, 4           # specify Print String service
      syscall               # print msg.  
       
      # enter y or n
      li $v0,12
      syscall

# validate entry
      beq $v0,'Y',newgame
      beq $v0,'y',newgame
      beq $v0,'N',exit
      beq $v0,'n',exit
      b done


# new game
newgame:  

      # clear bosard
      li  $a0,' '    
      sb  $a0, board+8($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+10($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+12($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+58($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+60($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+62($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+108($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+110($zero)  # Store the marker to the location, board+offset.
      sb  $a0, board+112($zero)  # Store the marker to the location, board+offset.
     
       
      # clear moves
      sb  $zero,moves($zero)
      sb  $zero,moves+1($zero)
      sb  $zero,moves+2($zero)
      sb  $zero,moves+3($zero)
      sb  $zero,moves+4($zero)
      sb  $zero,moves+5($zero)
      sb  $zero,moves+6($zero)
      sb  $zero,moves+7($zero)
      sb  $zero,moves+8($zero)

      # clr count
      sw  $zero,count($zero)
                 
      b play
         
# exit program                                    
exit:
        li   $v0, 10          # system call for exit
        syscall               # we are out of here.

# get player move
# return player move in $v0    
getmove:

        # constants
        li $t1,'X'
        li $t2,'O'
        li $t3,1
        li $t4,9
       
mloop:

        lb   $t0,turn($zero)    # get turn
       
# ask player to make move
        beq $v0,$t0,moveo

# asj player x to move
        la   $a0, msg4        # first argument for print (array)
        li   $v0, 4           # specify Print String service
        syscall               # print message
        b     moveit
     
# ask player o to move      
moveo:    
        la   $a0, msg5       # first argument for print (array)
        li   $v0, 4           # specify Print String service
        syscall               # print message
     
moveit:      
# enter number 1 to9
        li $v0,5
        syscall

# validate number
        blt  $v0,$t3,badnum
        bgt  $v0,$t4,badnum
        subi $v0,$v0,1
        lb   $t5,moves($v0)
        bne  $t5,$zero,badmove
        jr   $ra
       
# bad number entered
badnum:
        la   $a0, msg6      # first argument for print (array)
        li   $v0, 4           # specify Print String service
        syscall               # print message
        b mloop
         
# bsd move entered
badmove:
        la   $a0, msg7      # first argument for print (array)
        li   $v0, 4           # specify Print String service
        syscall               # print message
        b mloop
         
# computer move
computer:

        subu  $sp, $sp, 4     # Decrement the $sp to make space for $ra.
        sw    $ra, ($sp)      # Push the return address, $ra.


 #  look for wining move
       li    $t1,0              # start from move 0
wloop: 
       lb    $t2,moves($t1)     # check if move open
       bne   $t2,$zero,notw     # move open
       lb    $a0,turn($zero)
       sb    $a0,moves($t1)
       jal   iswinner           # check if winner for player
       sb    $zero,moves($t1)
       beq   $v0,0,notw
       move  $v0,$t1            # winner found
       b     cmprtn
notw:
        addu  $t1,$t1,1
        blt   $t1,9,wloop
       
# look for blockung move  
# find a blocking move
# switch winner player
        lb    $a0,turn($zero)
        beq   $a0,'X',isx
        b     notx
isx:   
        li    $a0,'O'  
# use opponent player
notx:  
        li    $t1,0           # start at move 0
bloop: lb    $t2,moves($t1)  # check move    
       bne   $t2,$zero,notb
       sb    $a0,moves($t1)
       jal   iswinner
       sb    $zero,moves($t1)
       beq   $v0,0,notb  
       move  $v0,$t1
       b     cmprtn
notb:
       addu  $t1,$t1,1
       blt   $t1,9,bloop
         
 # pick a random move
       li    $t1,9
       lb    $t0,count($zero)  # calculate n
       sub  $a1,$t1,$t0
       xor  $a0,$a0,$a0     # get random number 0 to n
       li   $v0,42
       syscall
       
       li    $t1,0             # count down random number
       move  $t0,$a0           # get random number
 # count down random number
rloop: 
        lb    $t2,moves($t1)        # check if a move  
        bne   $t2,$zero,notr
        move  $v0,$t1
        beq   $t0,$zero,cmprtn
        subi  $t0,$t0,1
notr:  
        addi  $t1,$t1,1
        b rloop


       
cmprtn: 
        lw    $ra, ($sp)       # Pop the return address, $ra.
        addu  $sp, $sp, 4      # Increment the $sp.
        jr    $ra

                       
# print player in board
# $v0 is board poisition
place:
        # load turn
        lb $a0,turn($zero)
        # calculte offet
#offset = 2×$v0 + 7 - [($v0-1)÷3]×6 + [($v0-1)÷3]×50
        #  = 2×$v0 + 7 + [($v0-1)÷3]×44:
        move $t1,$v0
        #sll  $t0,$t0,1
        #add  $t0,$t0,7
        divu $t1,$t1,3
        mulu $t1,$t1,44
        move  $t0,$t1
        add   $t0,$t0,8
        mulu  $t1,$v0,2
        add   $t0,$t0,$t1
        sb  $a0, board($t0)  # Store the marker to the location, board+offset.
        jr  $ra

# check for winner
# input $a0 = turn
# return $v0 = 1 if winner otherwise 0
iswinner:

      subu  $sp, $sp, 4     # Decrement the $sp to make space for $ra.
      sw    $ra, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t1, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t2, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t3, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t4, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t5, ($sp)      # Push the return address, $ra.
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t6, ($sp)      # Push the return address, $ra.
           
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t7, ($sp)      # Push the return address, $ra.      
     
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t8, ($sp)      # Push the return address, $ra.
           
      subu  $sp, $sp, 4     # Decrement the $sp to make space for $tx.
      sw    $t9, ($sp)      # Push the return address, $ra.
     
     
      li   $v0,1              # asume turn wins
     
      # get moves
      lb  $t1,moves($zero)
      lb  $t2,moves+1($zero)
      lb  $t3,moves+2($zero)
      lb  $t4,moves+3($zero)
      lb  $t5,moves+4($zero)
      lb  $t6,moves+5($zero)
      lb  $t7,moves+6($zero)
      lb  $t8,moves+7($zero)
      lb  $t9,moves+8($zero)

      # rows
row1:
      bne $a0,$t1,row2
      bne $a0,$t2,row2
      bne $a0,$t3,row2
      b winrtn
row2:
      bne $a0,$t4,row3
      bne $a0,$t5,row3
      bne $a0,$t6,row3
      b winrtn
row3:
      bne $a0,$t7,col1
      bne $a0,$t8,col1
      bne $a0,$t9,col1
      b winrtn
# cols
col1:
      bne $a0,$t1,col2
      bne $a0,$t4,col2
      bne $a0,$t7,col2
      b winrtn
col2:
      bne $a0,$t2,col3
      bne $a0,$t5,col3
      bne $a0,$t8,col3
      b winrtn
col3:
      bne $a0,$t3,dia1
      bne $a0,$t6,dia1
      bne $a0,$t9,dia1
      b winrtn
     
# diagonals
dia1:
      bne $a0,$t1,dia2
      bne $a0,$t5,dia2
      bne $a0,$t9,dia2
      b winrtn
dia2:
      bne $a0,$t3,nowinner
      bne $a0,$t5,nowinner
      bne $a0,$t7,nowinner
      b winrtn
     
# no winner yet
nowinner:
      li  $v0,0
     
winrtn:

     lw    $t9, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t8, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t7, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t6, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t5, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t4, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t3, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t2, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
     lw    $t1, ($sp)       # Pop the return address, $tx.
     addu  $sp, $sp, 4      # Increment the $sp.
     
      lw    $ra, ($sp)       # Pop the return address, $ra.
      addu  $sp, $sp, 4      # Increment the $sp.
     
      jr    $ra