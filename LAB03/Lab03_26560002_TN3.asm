# Phan Tran Tuan Anh - 26560002
# Pp: A gradebook module that calculates array sums and passing student counts for Classes A and B.

# Lab 02 - Experiment 3: Gradebook Library
# Student ID: 26560002 -> D = 2, M = 55 + (4 * 2) = 63

.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
msgA:   .asciiz "Class A total: "
msgB:   .asciiz "Class B total: "
msgAP:  .asciiz "Class A passed: "
msgBP:  .asciiz "Class B passed: "
nl:     .asciiz "\n"

.text
.globl main
main:
    # --- Class A Total ---
    la   $a0, classA            # argument 1: address of classA[0]
    addi $a1, $zero, 10         # argument 2: number of scores
    jal  sum_array              # $v0 = total of class A
    
    la   $a0, msgA              # print Class A total
    add  $a1, $v0, $zero
    jal  show
    
    # --- Class B Total ---
    la   $a0, classB            # argument 1: address of classB[0]
    addi $a1, $zero, 8          # argument 2: number of scores
    jal  sum_array              # $v0 = total of class B
    
    la   $a0, msgB              # print Class B total
    add  $a1, $v0, $zero
    jal  show

    # --- Class A Passed ---
    la   $a0, classA            # addr
    addi $a1, $zero, 10         # n
    addi $a2, $zero, 63         # mark (M = 63)
    jal  count_pass
    
    la   $a0, msgAP             # print Class A passed
    add  $a1, $v0, $zero
    jal  show

    # --- Class B Passed ---
    la   $a0, classB            # addr
    addi $a1, $zero, 8          # n
    addi $a2, $zero, 63         # mark (M = 63)
    jal  count_pass
    
    la   $a0, msgBP             # print Class B passed
    add  $a1, $v0, $zero
    jal  show

    # Exit program
    li   $v0, 10
    syscall
 
# =========================================================
# sum_array(addr = $a0, n = $a1): returns the sum of n words in $v0
# =========================================================
sum_array:
    addi $v0, $zero, 0          # sum = 0
    addi $t0, $zero, 0          # i = 0
sum_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, sum_end
    
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # $t2 = address of element i
    lw   $t3, 0($t2)
    
    add  $v0, $v0, $t3          # sum = sum + element i
    addi $t0, $t0, 1            # i = i + 1
    j    sum_loop
sum_end:
    jr   $ra

# =========================================================
# count_pass(addr = $a0, n = $a1, mark = $a2): count of words >= mark in $v0
# =========================================================
count_pass:
    addi $v0, $zero, 0          # count = 0
    addi $t0, $zero, 0          # i = 0
cp_loop:
    # check condition: leave loop when i >= n
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, cp_end
    
    # load element i
    sll  $t2, $t0, 2            # $t2 = 4 * i
    add  $t2, $t2, $a0          # $t2 = address of element i
    lw   $t3, 0($t2)            # $t3 = element i
    
    # if $t3 >= mark, count = count + 1
    slt  $t4, $t3, $a2          # $t4 = 1 if element < mark
    bne  $t4, $zero, cp_next    # if element < mark, skip increment
    
    addi $v0, $v0, 1            # count = count + 1
    
cp_next:
    addi $t0, $t0, 1            # i = i + 1
    j    cp_loop
cp_end:
    jr   $ra
 
# =========================================================
# show(msg = $a0, value = $a1): prints msg, value and a new line
# =========================================================
show:
    li   $v0, 4                 # print message (address already in $a0)
    syscall
    
    li   $v0, 1                 # print integer
    add  $a0, $a1, $zero
    syscall
    
    li   $v0, 4                 # print new line
    la   $a0, nl
    syscall
    
    jr   $ra