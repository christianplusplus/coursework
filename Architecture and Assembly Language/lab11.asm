#=======================================================================
# Description: Showcases assembly procedure conventions.
# Author: Christian Wendlandt
# Date: 5/12/17
#=======================================================================
#========== Data segment
.data
	x: .word 1
#========== Code segment
.text
.globl MAIN
#int main()
MAIN:
	#if (x > 0)
	lw $t0, x
	bgt $t0, $zero, MAIN_THEN
	b MAIN_ELSE
	
MAIN_THEN:
	#{
	#int x = 5;
	li $t1, 5
	add $sp, $sp, -4
	sw $t1, ($sp)
	
	# 3

	add $sp, $sp, 4

	b MAIN_IF_END
	
	#}
	
MAIN_ELSE:
	#else
	#{
	
	# 4
	
	#f(6);
	add $sp, $sp, -40
	sw $t9, 36($sp)
	sw $t8, 32($sp)
	sw $t7, 28($sp)
	sw $t6, 24($sp)
	sw $t5, 20($sp)
	sw $t4, 16($sp)
	sw $t3, 12($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	li $a0, 6
	jal F
	lw $t9, 36($sp)
	lw $t8, 32($sp)
	lw $t7, 28($sp)
	lw $t6, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	add $sp, $sp, 40
	
	# 5

	#}
	
MAIN_IF_END:

EXIT:
	#return 0;
	li $v0, 10
	syscall

#=======================================================================

#void f(int y)
F:
	add $sp, $sp, -56
	sw $a3, 52($sp)
	sw $a2, 48($sp)
	sw $a1, 44($sp)
	sw $a0, 40($sp)
	sw $ra, 36($sp)
	sw $fp, 32($sp)
	sw $s7, 28($sp)
	sw $s7, 24($sp)
	sw $s7, 20($sp)
	sw $s7, 16($sp)
	sw $s7, 12($sp)
	sw $s7, 8($sp)
	sw $s7, 4($sp)
	sw $s7, 0($sp)
	add $fp, $sp, 56

	#int x = y + 1;
	lw $t0, -16($fp)
	add $t1, $t0, 1
	add $sp, $sp, -4
	sw $t1, ($sp)
	
	#g();
	add $sp, $sp, -40
	sw $t9, 36($sp)
	sw $t8, 32($sp)
	sw $t7, 28($sp)
	sw $t6, 24($sp)
	sw $t5, 20($sp)
	sw $t4, 16($sp)
	sw $t3, 12($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	jal G
	lw $t9, 36($sp)
	lw $t8, 32($sp)
	lw $t7, 28($sp)
	lw $t6, 24($sp)
	lw $t5, 20($sp)
	lw $t4, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	add $sp, $sp, 40
	
	#int z = 4;
	li $t2, 4
	add $sp, $sp, -4
	sw $t2, ($sp)

	# 2
	
	add $sp, $sp, 8
	
	lw $a3, 52($sp)
	lw $a2, 48($sp)
	lw $a1, 44($sp)
	lw $a0, 40($sp)
	lw $ra, 36($sp)
	lw $fp, 32($sp)
	lw $s7, 28($sp)
	lw $s7, 24($sp)
	lw $s7, 20($sp)
	lw $s7, 16($sp)
	lw $s7, 12($sp)
	lw $s7, 8($sp)
	lw $s7, 4($sp)
	lw $s7, 0($sp)
	add $sp, $sp, 56
	jr $ra

#=======================================================================

#void g()
G:
	add $sp, $sp, -56
	sw $a3, 52($sp)
	sw $a2, 48($sp)
	sw $a1, 44($sp)
	sw $a0, 40($sp)
	sw $ra, 36($sp)
	sw $fp, 32($sp)
	sw $s7, 28($sp)
	sw $s7, 24($sp)
	sw $s7, 20($sp)
	sw $s7, 16($sp)
	sw $s7, 12($sp)
	sw $s7, 8($sp)
	sw $s7, 4($sp)
	sw $s7, 0($sp)
	add $fp, $sp, 56

	# 1
	
	lw $a3, 52($sp)
	lw $a2, 48($sp)
	lw $a1, 44($sp)
	lw $a0, 40($sp)
	lw $ra, 36($sp)
	lw $fp, 32($sp)
	lw $s7, 28($sp)
	lw $s7, 24($sp)
	lw $s7, 20($sp)
	lw $s7, 16($sp)
	lw $s7, 12($sp)
	lw $s7, 8($sp)
	lw $s7, 4($sp)
	lw $s7, 0($sp)
	add $sp, $sp, 56
	jr $ra