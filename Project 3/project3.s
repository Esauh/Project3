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
