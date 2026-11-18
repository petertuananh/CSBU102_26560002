# Phan Tran Tuan Anh - 26560002
# Pp: A leaf routine named min_max that finds and returns the smallest ($v0) and largest ($v1) elements in an array.

# Add this inside your main procedure, replacing or adding to the Class A/B logic:

    # --- Call min_max for Class A ---
    la   $a0, classA            # argument 1: address of classA[0]
    addi $a1, $zero, 10         # argument 2: number of scores (n = 10)
    jal  min_max
    
    # Store results temporarily because show uses $a1
    add  $t8, $v0, $zero        # save min A in $t8
    add  $t9, $v1, $zero        # save max A in $t9
    
    la   $a0, msg_min           # assume msg_min: .asciiz "Class A Min: "
    add  $a1, $t8, $zero
    jal  show
    la   $a0, msg_max           # assume msg_max: .asciiz "Class A Max: "
    add  $a1, $t9, $zero
    jal  show

    # --- Call min_max for Class B ---
    la   $a0, classB            # argument 1: address of classB[0]
    addi $a1, $zero, 8          # argument 2: number of scores (n = 8)
    jal  min_max
    
    add  $t8, $v0, $zero        # save min B in $t8
    add  $t9, $v1, $zero        # save max B in $t9
    
    la   $a0, msg_minB          # assume msg_minB: .asciiz "Class B Min: "
    add  $a1, $t8, $zero
    jal  show
    la   $a0, msg_maxB          # assume msg_maxB: .asciiz "Class B Max: "
    add  $a1, $t9, $zero
    jal  show

# ... (syscall 10 to exit) ...

# =========================================================
# min_max(addr = $a0, n = $a1): returns min in $v0, max in $v1
# =========================================================
min_max:
    lw   $v0, 0($a0)            # min = array[0]
    lw   $v1, 0($a0)            # max = array[0]
    addi $t0, $zero, 1          # i = 1 (since 0 is already loaded)
    
mm_loop:
    slt  $t1, $t0, $a1          # $t1 = 1 if i < n
    beq  $t1, $zero, mm_end     # if i >= n, exit loop
    
    sll  $t2, $t0, 2            # $t2 = i * 4
    add  $t2, $t2, $a0          # $t2 = address of array[i]
    lw   $t3, 0($t2)            # $t3 = array[i]
    
    # check min: if array[i] < min, update min
    slt  $t4, $t3, $v0          # $t4 = 1 if array[i] < min
    beq  $t4, $zero, check_max
    add  $v0, $t3, $zero        # min = array[i]
    j    mm_next                # skip max check if it's the new minimum
    
check_max:
    # check max: if max < array[i], update max
    slt  $t4, $v1, $t3          # $t4 = 1 if max < array[i]
    beq  $t4, $zero, mm_next
    add  $v1, $t3, $zero        # max = array[i]
    
mm_next:
    addi $t0, $t0, 1            # i = i + 1
    j    mm_loop
    
mm_end:
    jr   $ra