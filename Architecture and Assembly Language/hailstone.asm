#=======================================================================
# Descriptions: Prints a given hailstone sequence.
# Author: Christian Wendlandt
# Date: 4/28/17
#=======================================================================
#========== Data segment
.data
	val: .word 0
	message1: .asciiz "Enter a positive integer: "
	message2: .asciiz "Done. Normal termination."
#========== Code segment
.text
.globl MAIN
#void main()
MAIN:
	#get_positive_value(&val);
	la $a0, val
	jal GET_POSITIVE_VALUE

	#hail(val);
	lw $a0, val
	jal HAIL

	#printf("Done. Normal termination.");
	la $a0, message2
	li $v0, 4
	syscall

#end main
EXIT:
	li $v0, 10
	syscall

#void get_positive_value(int *in_val)//$t0 = *in_val
GET_POSITIVE_VALUE:
	move $t0, $a0

#do
GET_POSITIVE_VALUE_LOOP:

	#printf("Enter a positive integer: ");
	la $a0, message1
	li $v0, 4
	syscall

	#scanf("%d", in_val);
	li $v0, 5
	syscall
	sw $v0, ($t0)

	#while(*in_val <= 0);
	blt $v0 , 1, GET_POSITIVE_VALUE_LOOP

	#return void;
	jr $ra

#void hail(int stone)
#//$t0 = stone, $t1 = stone & 1, $t0 and $t1 are left unsaved.
HAIL:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	move $t0, $a0
	
	#printf("%d\n", stone);
	li $v0, 1
	syscall
	li $a0, 10
	li $v0, 11
	syscall

#while(stone > 1)
HAIL_LOOP_START:	
	ble $t0, 1, HAIL_LOOP_END

	#if(stone & 1 == 1)
	andi $t1, $t0, 1
	bne $t1, 1, HAIL_IF_ELSE
	
#if true

	#stone = multiply_by_three_and_add_one(stone);
	move $a0 , $t0
	jal MULTIPLY_BY_THREE_AND_ADD_ONE
	move $t0 , $v0
	
	b HAIL_IF_END

#if else
HAIL_IF_ELSE:

	#stone = divide_by_two(stone);
	move $a0 , $t0
	jal DIVIDE_BY_TWO
	move $t0, $v0
	
	b HAIL_IF_END

HAIL_IF_END:

	#printf("%d\n", stone);
	move $a0, $t0
	li $v0, 1
	syscall
	li $a0, 10
	li $v0, 11
	syscall
	
	b HAIL_LOOP_START

HAIL_LOOP_END:

	#return void;
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#int multiply_by_three_and_add_one(int val)//$t0 = val
MULTIPLY_BY_THREE_AND_ADD_ONE:

	#register temp = val;
	#temp = temp + (val << 1);
	sll $t0, $a0, 1
	add $t0, $t0, $a0

	#temp = temp + 1;
	#return temp;
	addi $v0, $t0, 1
	jr $ra

#int divide_by_two(int val)
DIVIDE_BY_TWO:

	#register temp = val;
	#temp = val >> 1;
	#return temp;
	srl $v0, $a0, 1
	jr $ra
