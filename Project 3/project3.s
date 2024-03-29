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
li $v0, 8
la $a0, str #space for input
li $a1, 1001 #number of char to read from input 1001-1 = 1000
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
jal sub_b #jump to sub_b and saves position to $ra
li $v0, 11
la $a0, 44 #44 corresponds to the comma which will be outputted
syscall

addi $t0, $t0, 4
j get_char

again:
addi $sp, $sp, -4
sw $a1, 0($sp) #stores a1 onto top of the stack
addi $t0, $t0, 4
j get_char

after_char:
jal sub_b
move $ra, $t9
jr $ra

sub_b:
addi $s6, $sp, 0 #make $s6 a faux stack
add $t2, $s5, $zero
addi $t3, $s6, -4 #moves faux stack
addi $t2, $t2, -4 #moves $t2
add $t4, $t2, $zero
add $t5, $s6, $zero

check_leading:
beq $t4, $t3, after_leading
lw $a1, 0($t4) #loads the current character into argument
seq $t6, $a1, 32 #space
seq $t7, $a1, 9 #tab
beq $t6, $zero, after_leading
addi $t4, $t4, -4
j check_leading

after_leading: #needed to implement space for stack nothing needed inside

before_trailing:
beq $t5, $s5, after_trail
lw $a1, 0($t5)
seq $t6, $a1, 32 #space
seq $t7, $a1, 9	#tab
or $t6, $t6, $t7
beq $t6, $zero, after_trail
addi $t5, $t5, 4
j before_trailing

after_trail:
sub $t6, $t4, $t5 #length of substring
slt $t7, $t6, 0	#substring less than 0
sgt $t8, $t6, 12 #substring greater than 12
or $t7, $t7, $t8
bne $t7, $zero, invalid
add $t6, $t4, $zero #counter
li $t7, 0  #total
addi $t5, $t5, -4

convert:
beq $t6, $t5, after_convert
lw $a1, 0($t6) #head of faux stack pointer
sgt $t1, $a1, 64 #uppercase convert
addi $a2, $s1, 65
slt $t8, $a1, $a2
and $a3, $t1, $t8
sgt $t1, $a1, 96 #if greater than 96 its lowercase
addi $a2, $s1, 97 #converts
slt $t8, $a1, $a2
and $s7, $t1, $t8
sgt $t1, $a1, 47 #if greater than 47 its a number
li $a2, 58
slt $t8, $a1, $a2
and $t1, $t1, $t8
or $a3, $a3, $s7
or $a3, $a3, $t1
beq $a3, $zero, invalid
move $a0, $t6
move $t1, $ra #set $t1 to return address
li $a2, 0
addi $a2, $t5, 4
sub $a2, $t6, $a2 #length
li $s7, 4
div $a2, $s7
mflo $v1
jal checker
move $ra, $t1 #change the return address
add $t7, $t7, $v0
addi $t6, $t6, -4 #increment
j convert

after_convert:
li $t6, 1
j end #jump to end procedure

invalid:
add $t6, $zero, $zero
j end #jump to end procedure

end:

pop:
beq $sp, $s5, fin_pop
addi $sp, $sp, 4
j pop

fin_pop:
beq $t6, $zero, disp #space added after pop
j add_total

disp: #procedure to print out the error message "-"
li $v0, 4
la $a0, error
syscall
j return_to

add_total:
li $v0, 1 #add to grant total
move $a0, $t7
syscall
j return_to

return_to:
jr $ra

checker:
li $s7, 65
add $s7, $s1, $s7
sgt $t8, $a1, 64
slt $a3, $a1, $s7
and $t8, $t8, $a3
bne $t8, $zero, upper
li $s7, 97
add $s7, $s7, $s1
sgt $t8, $a1, 96
slt $a3, $a1, $s7
and $t8, $t8, $a3
bne $t8, $zero, lower
sgt $t8, $a1, 47
slt $a3, $a1, 58
and $t8, $t8, $a3
bne $t8, $zero, num
j num

lower:
addiu $a1, $a1, -87	#convert for lowercase
j finished

upper:
addiu $a1, $a1, -55	#convert for uppercase
j finished
num:
addiu $a1, $a1, -48	#convert for numbers
j finished

finished:
li $t8, 0  #count initialized
li $v0, 1
slt $a3, $t8, $v1
beq $a3, $zero, after

base_total:
mult $v0, $s0
mflo $v0
addi $t8, $t8, 1
slt $a3, $t8, $v1
bne $a3, $zero, base_total	#if 0, do again

after:
mult $a1, $v0
mflo $v0
jr $ra
