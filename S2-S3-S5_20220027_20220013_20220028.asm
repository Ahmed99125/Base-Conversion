.data
prompt1: .asciiz "Enter the number: "
prompt2: .asciiz "Enter the base to convert from: "
prompt3: .asciiz "Enter the base to convert to: "
error:   .asciiz "Invalid number for the given base.\n"
invalid_base_msg: .asciiz "Invalid base number, please enter a valid base"
result:  .asciiz "Result: "
number:  .space 32

.text
.globl main

main:
    # Get number input
    li $v0, 4
    la $a0, prompt1
    syscall
    
    li $v0, 8
    la $a0, number
    li $a1, 32
    syscall

    # Get base to convert from
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # $t0 = base_from
    
    ble $t0, 1, invalid_base

    # Get base to convert to
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5
    syscall
    move $a2, $v0  # $t1 = base_to
    
    ble $a2, 1, invalid_base

    # Call base to decimal function
    la $a0, number
    move $a1, $t0
    jal base_to_decimal
    
    # call decimal to base function
    move $a0, $v0
    move $a1, $a2
    jal decimal_to_base
    
    j exit
    
base_to_decimal:
    li $v0, 0	# decimal result
loop:
    lb $t1, ($a0)
    beq $t1, '\n', done	# newline character
    beq $t1, 0, done	# null characater
    bgt $t1, '9', get_character
    ble $t1, '9', get_digit
continue:
    mul $v0, $v0, $a1
    add $v0, $v0, $t1
    addi $a0, $a0, 1
    j loop
    
get_digit:
    sub $t1, $t1, '0'
    bge $t1, $a1, invalid_number
    j continue
    
get_character:
    sub $t1, $t1, 'A'
    addi $t1, $t1, 10
    bge $t1, $a1, invalid_number
    j continue

invalid_number:
    li $v0, 4
    la $a0, error
    syscall
    j exit

done:
    jr $ra
    
invalid_base:
    li $v0, 4
    la $a0, invalid_base_msg
    syscall
    j exit
    
exit:
    li $v0, 10
    syscall
    
to_character:
    addi $t1, $t1, 55
    j continue_convert_loop
    
decimal_to_base:
    la $t0, number
    addi $t0, $t0, 32
    
convert_loop:
    sub $t0, $t0, 1
    bltz $t0, print_result
    beqz $a0, print_result
    div $a0, $a1
    mfhi $t1	# remainder
    mflo $a0	# quotient
    bgt $t1, 9, to_character
    addi $t1, $t1, '0'
continue_convert_loop:
    sb $t1, ($t0)
    j convert_loop
    
print_result:
    li $v0, 4
    la $a0, result
    syscall
    la $t2, number
    addi $t2, $t2, 31
print_loop:
    addi $t0, $t0, 1
    lb $a0, ($t0)
    li $v0, 11
    syscall
    bne $t0, $t2, print_loop
    jr $ra
    
    
    
    
    
    
    
    
