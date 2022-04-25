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
