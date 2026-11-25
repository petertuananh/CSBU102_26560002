# Full name: Phan Tran Tuan Anh
# Student ID: 26560002
# Purpose: Compute 4 * x using nested procedure calls while preserving $ra on the stack.

.data
msg:    .asciiz "Score out of 100: "

.text
.globl main
main:
    addi $a0, $zero, 18     # quiz score out of 25
    jal  times4             # $v0 = times4(18)
    add  $s0, $v0, $zero    # keep the result
    li   $v0, 4
    la   $a0, msg
    syscall
    li   $v0, 1
    add  $a0, $s0, $zero
    syscall
    li   $v0, 10
    syscall

# times4(x = $a0): returns 4 * x in $v0 by calling twice two times
times4:
    addi $sp, $sp, -4       # make room for one word
    sw   $ra, 0($sp)        # save $ra at 0($sp)
    jal  twice              # $v0 = 2 * x
    add  $a0, $v0, $zero    # argument of the second call
    jal  twice              # $v0 = 4 * x
    lw   $ra, 0($sp)        # restore $ra from 0($sp)
    addi $sp, $sp, 4        # give the room back
    jr   $ra

# twice(x = $a0): returns x + x in $v0 (a leaf procedure)
twice:
    add  $v0, $a0, $a0
    jr   $ra