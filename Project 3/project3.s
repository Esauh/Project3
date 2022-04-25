#02936343 % 11 = 3
#base: 26 + 3 = 29
.globl main
.data

str: .space 1001 #makes space for the 1000 char input
error: .asciiz "-" #invalid input message

.text

main:
addi $s0, $zero, 29
addi $s1, $zero, 19 #bases used for rest of program

get_input:
li $v0, 8 #number of char to read from input
la $a0, str #space for input
li $a1, 1001
syscall

li $s2, 0 #counter
add $s3, $s2, $zero #initializing counter further

check_first:
li $t0, 1000
beq $s3, $t0, enter_after
la $a1, str	#load input into register
add $a1, $a1, $s3
lb $a1, 0($a1) #load char into a1
beq $a1, 10, enter_after #goes to after enter
addi $s3, $s3, 1
j check_first

enter_after:
addi $s3, $s3, -1
add $t0, $s3, $zero #count set to t0
addi $s4, $sp, 0 #stack head

check_null:
slt $t1, $t0, $s2 #checks count
bne $t1, $zero, after_null
addi $sp, $sp, -4
la $a1, str
add $a1, $a1, $t0
lb $a1, 0($a1) #makes a1 the current char
sw $a1, 0($sp)
addi $t0, $t0, -1
j check_null

after_null:
jal sub_a

exit:
li $v0, 10
syscall

sub_a:
addi $s5, $sp, 0 #head of the stack
add, $t0, $s5, $zero #counter set
move $t9, $ra

get_char:
beq $t0, $s4, after_char
lw $a1, 0($t0) #places the current char into register for arugment
li $t1, 59 #stores the decimal value for semicolon into t1
bne $a1, $t1, again #sees if char is equal to 59 then goes to again procedure

