#=======================================================================
# Description: Implements a game of BINGO in the command terminal.
# Author: Christian Wendlandt
# Date: 5/8/17
#=======================================================================
#========== Data segment
.data
	size: .word 5
	successful: .word 0
	marked: .word 1
	invalid: .word 2
	col: .byte 0
	.align 2
	row: .word 0
	table: .word 0, 0, 0, 0, 0,
		     0, 0, 0, 0, 0,
		     0, 0, 0, 0, 0,
		     0, 0, 0, 0, 0,
		     0, 0, 0, 0, 0
	welcomeMessage: .asciiz "Welcome to bingo.\n\n"
	promptMessage: .asciiz "Enter your choice (Q to quit): "
	markedMessage: .asciiz "\nPosition marked.\n"
	invalidMessage: .asciiz "\nInvalid position.\n"
	alreadyMarkedMessage: .asciiz "\nPosition already marked.\n"
	winMessage: .asciiz "\n\n!! BINGO !!"
	bingoColumns: .asciiz "\n  B I N G O\n"
#========== Code segment
.text
.globl MAIN
#void main()
MAIN:
	#prints welcome message
	la $a0, welcomeMessage
	li $v0, 4
	syscall
	
	#displays board
	jal DISPLAY_BOARD
	
	#reads input
	la $a0, col
	la $a1, row
	jal READ_INPUT

MAIN_LOOP:
	#while(col != 'Q')
	lw $t0, col
	beq $t0, 81, MAIN_LOOP_END
	
	#marks input position on board
	lw $a0, col
	lw $a1, row
	jal MARK_POSITION
	
	#displays board
	jal DISPLAY_BOARD
	
	#reads input
	la $a0, col
	la $a1, row
	jal READ_INPUT
	
	b MAIN_LOOP
MAIN_LOOP_END:

	#prints BINGO if you've won
	jal CHECK_BINGO

EXIT:
	li $v0, 10
	syscall

#=======================================================================

#void displayRow()
DISPLAY_BOARD:
	#prologue
	add $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	#prints BINGO column names
	la $a0, bingoColumns
	li $v0, 4
	syscall

	#preps $s0 as a loop index and $s1 as the number of iterations
	li $s0, 0
	lw $s1, size
	
DISPLAY_BOARD_LOOP:
	#while(index < size)
	bge $s0, $s1, DISPLAY_BOARD_LOOP_END
	
	#prints current row
	move $a0, $s0
	jal DISPLAY_ROW
	
	#increments loop
	add $s0, $s0, 1
	
	#returns to loop condition
	b DISPLAY_BOARD_LOOP
DISPLAY_BOARD_LOOP_END:

	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	add $sp, $sp, 12
	jr $ra
	#epilogue

#=======================================================================

#void displayRow(int row)
DISPLAY_ROW:
	#prologue
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#sets $s0 as the current row
	move $s0, $a0

	#prints row number
	add $a0, $s0, 1
	li $v0, 1
	syscall
	
	#preps $s1 as column index and $s2 as the number of iterations
	li $s1, 0
	lw $s2, size
	
DISPLAY_ROW_LOOP:
	#while(index < size)
	bge $s1, $s2, DISPLAY_ROW_LOOP_END
	
	#prints a space
	li $a0, 32
	li $v0, 11
	syscall
	
	#gets table[row][col]
	move $a0, $s0
	move $a1, $s1
	jal GET_VAL_AT_ROW_AND_COL
	
	#prints table[row][col]
	move $a0, $v0
	jal PRINT_TILE
	
	#increments loop
	add $s1, $s1, 1
	
	#returns to loop condition
	b DISPLAY_ROW_LOOP
DISPLAY_ROW_LOOP_END:

	#prints new line character
	li $a0, 10
	li $v0, 11
	syscall

	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra

#=======================================================================

#int getValAtRowAndCol(int row, int col)
GET_VAL_AT_ROW_AND_COL:
	#sets offset = size * row + col
	lw $t0, size
	mul $t0, $t0, $a0
	add $t0, $t0, $a1
	sll $t0, $t0, 2
	
	#sets $t1 = table + offset
	la $t1, table
	add $t1, $t1, $t0

	#sets $v0 = table[row][col]
	lw $v0, ($t1)
	
	#epilogue
	jr $ra

#=======================================================================

#void printTile(int tileValue)
PRINT_TILE:
	#if(tileValue == marked) go to PRINT_TILE_PRINT_X
	lw $t0, marked
	beq $a0, $t0, PRINT_TILE_PRINT_X
	#else go to PRINT_TILE_PRINT_DASH
	
PRINT_TILE_PRINT_DASH:
	#prints '-'
	li $a0, 45
	li $v0, 11
	syscall
	
	b PRINT_TILE_DONE
	
PRINT_TILE_PRINT_X:
	#prints 'X'
	li $a0, 88
	li $v0, 11
	syscall
	
PRINT_TILE_DONE:

	#epilogue
	jr $ra

#=======================================================================

#void readInput(char* col, int* row)
READ_INPUT:
	#catches parameters
	move $t0, $a0
	move $t1, $a1

	#prints prompt
	la $a0, promptMessage
	li $v0, 4
	syscall

	#reads next char into col
	li $v0, 12
	syscall
	sb $v0, ($t0)
	
	#if(col == 'Q') skip reading int
	beq $v0, 81, READ_INPUT_EXIT
	
	#reads next int - 1 into row
	li $v0, 5
	syscall
	sub $v0, $v0, 1
	sw $v0, row

READ_INPUT_EXIT:

	#epilogue
	jr $ra

#=======================================================================

#int charToInt(char c)
CHAR_TO_INT:
	#if(c == 'B')
	beq $a0, 66, CHAR_TO_INT_B
	#else if(c == 'I')
	beq $a0, 73, CHAR_TO_INT_I
	#else if(c == 'N')
	beq $a0, 78, CHAR_TO_INT_N
	#else if(c == 'G')
	beq $a0, 71, CHAR_TO_INT_G
	#else if(c == 'O')
	beq $a0, 79, CHAR_TO_INT_O
	
	#else return -1
	li $v0, -1
	b CHAR_TO_INT_EXIT

#return 0
CHAR_TO_INT_B:
	li $v0, 0
	b CHAR_TO_INT_EXIT

#return 1
CHAR_TO_INT_I:
	li $v0, 1
	b CHAR_TO_INT_EXIT

#return 2
CHAR_TO_INT_N:
	li $v0, 2
	b CHAR_TO_INT_EXIT

#return 3
CHAR_TO_INT_G:
	li $v0, 3
	b CHAR_TO_INT_EXIT

#return 4
CHAR_TO_INT_O:
	li $v0, 4
	b CHAR_TO_INT_EXIT

CHAR_TO_INT_EXIT:

	#epilogue
	jr $ra

#=======================================================================

#void markPosition(char col, int row)
MARK_POSITION:
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#catches row
	move $s1, $a1	
	
	#catches col but first converts into number
	jal CHAR_TO_INT
	move $s0, $v0
	
	#checks for invalid position
	lw $s2, size
	blt $s0, $zero, MARK_POSITION_INVALID
	bge $s0, $s2, MARK_POSITION_INVALID
	blt $s1, $zero, MARK_POSITION_INVALID
	bge $s1, $s2, MARK_POSITION_INVALID
	
	#checks tile for already marked
	lw $s2, marked
	move $a1, $s0
	move $a0, $s1
	jal GET_VAL_AT_ROW_AND_COL
	beq $v0, $s2, MARK_POSIITON_ALREADY_MARKED
	
	#marks position at table[row][col]
	move $a1, $s0
	move $a0, $s1
	jal MARK_LOCATION
	
	#sets status code to marked successful
	lw $a0, successful
	b MARK_POSITION_DISPLAY_STATUS
	
MARK_POSIITON_ALREADY_MARKED:
	#sets status code to position already marked
	lw $a0, marked
	b MARK_POSITION_DISPLAY_STATUS

MARK_POSITION_INVALID:
	#sets status code to invalid position
	lw $a0, invalid
	b MARK_POSITION_DISPLAY_STATUS

MARK_POSITION_DISPLAY_STATUS:
	#prints status code in $a0
	jal DISPLAY_STATUS
	
	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra

#=======================================================================

#void markLocation(int row, int col)
MARK_LOCATION:
	#sets offset = size * row + col
	lw $t0, size
	mul $t0, $t0, $a0
	add $t0, $t0, $a1
	sll $t0, $t0, 2
	
	#sets $t1 = table + offset
	la $t1, table
	add $t1, $t1, $t0

	#marks table[row][col]
	lw $t2, marked
	sw $t2, ($t1)
	
	#epilogue
	jr $ra

#=======================================================================

#void displayStatus(int status)
DISPLAY_STATUS:
	#loads known status codes
	lw $t0, successful
	lw $t1, marked
	
	#compares status code to known status codes and jumps
	beq $a0, $t0, DISPLAY_STATUS_SUCCESSFUL
	beq $a0, $t1, DISPLAY_STATUS_ALREADY_MARKED
	b DISPLAY_STATUS_INVALID
	
DISPLAY_STATUS_SUCCESSFUL:
	#prints position already marked message
	la $a0, markedMessage
	li $v0, 4
	syscall
	
	b DISPLAY_STATUS_EXIT

DISPLAY_STATUS_ALREADY_MARKED:
	#prints position successfully marked message
	la $a0, alreadyMarkedMessage
	li $v0, 4
	syscall
	
	b DISPLAY_STATUS_EXIT
	
DISPLAY_STATUS_INVALID:
	#prints invalid position message
	la $a0, invalidMessage
	li $v0, 4
	syscall
	
DISPLAY_STATUS_EXIT:

	#epilogue
	jr $ra

#=======================================================================

#void checkBingo()
CHECK_BINGO:
	#prologue
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	#loads marked value
	lw $s0, marked
	
	#if(checkRows() == marked) go to CHECK_BINGO_TRUE
	jal CHECK_ROWS
	beq $v0, $s0, CHECK_BINGO_TRUE

	#else if(checkCols() == marked) go to CHECK_BINGO_TRUE
	jal CHECK_COLS
	beq $v0, $s0, CHECK_BINGO_TRUE
	
	#else if(checkMainDiagonal() == marked) go to CHECK_BINGO_TRUE
	jal CHECK_MAIN_DIAGONAL
	beq $v0, $s0, CHECK_BINGO_TRUE
	
	#else if(checkOffDiagonal() == marked) go to CHECK_BINGO_TRUE
	jal CHECK_OFF_DIAGONAL
	beq $v0, $s0, CHECK_BINGO_TRUE
	
	#else go to CHECK_BINGO_EXIT
	b CHECK_BINGO_EXIT

CHECK_BINGO_TRUE:
	#prints that you have BINGO
	la $a0, winMessage
	li $v0, 4
	syscall

CHECK_BINGO_EXIT:
	
	#epilogue
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	add $sp, $sp, 8
	jr $ra

#=======================================================================

#int checkRows()
CHECK_ROWS:
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initializes index and boolean, and loads size
	li $s0, 0
	lw $s1, size
	li $s2, 0
	
CHECK_ROWS_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_ROWS_LOOP_END
	
	#checks row[index]
	move $a0, $s0
	jal CHECK_ROW
	or $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1

	#returns to loop condition
	b CHECK_ROWS_LOOP
CHECK_ROWS_LOOP_END:

	#sets return boolean
	move $v0, $s2
	
	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra

#=======================================================================

#int checkRow(int row)
CHECK_ROW:
	#prologue
	add $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initializes index and boolean, and loads size
	#captures row in $s3
	li $s0, 0
	lw $s1, size
	li $s2, 1
	move $s3, $a0
	
CHECK_ROW_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_ROW_LOOP_END
	
	#checks row[row][index]
	move $a0, $s3
	move $a1, $s0
	jal GET_VAL_AT_ROW_AND_COL
	and $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1
	
	#returns to loop condition
	b CHECK_ROW_LOOP
CHECK_ROW_LOOP_END:

	#sets return boolean
	move $v0, $s2

	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	add $sp, $sp, 20
	jr $ra

#=======================================================================

#int checkCols()
CHECK_COLS:
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initializes index and boolean, and loads size
	li $s0, 0
	lw $s1, size
	li $s2, 0
	
CHECK_COLS_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_COLS_LOOP_END
	
	#checks row[index]
	move $a0, $s0
	jal CHECK_COL
	or $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1

	#returns to loop condition
	b CHECK_COLS_LOOP
CHECK_COLS_LOOP_END:

	#sets return boolean
	move $v0, $s2
	
	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra

#=======================================================================

#int checkCol(int col)
CHECK_COL:
	#prologue
	add $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initializes index and boolean, and loads size
	#captures col in $s3
	li $s0, 0
	lw $s1, size
	li $s2, 1
	move $s3, $a0
	
CHECK_COL_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_COL_LOOP_END
	
	#checks row[index][col]
	move $a0, $s0
	move $a1, $s3
	jal GET_VAL_AT_ROW_AND_COL
	and $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1
	
	#returns to loop condition
	b CHECK_COL_LOOP
CHECK_COL_LOOP_END:

	#sets return boolean
	move $v0, $s2

	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	add $sp, $sp, 20
	jr $ra

#=======================================================================

#int checkMainDiagonal()
CHECK_MAIN_DIAGONAL:
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initialize index and boolean, and loads size
	li $s0, 0
	lw $s1, size
	li $s2, 1
	
CHECK_MAIN_DIAGONAL_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_MAIN_DIAGONAL_LOOP_END
	
	#checks row[index][index]
	move $a0, $s0
	move $a1, $s0
	jal GET_VAL_AT_ROW_AND_COL
	and $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1
	
	#returns to loop condition
	b CHECK_MAIN_DIAGONAL_LOOP
CHECK_MAIN_DIAGONAL_LOOP_END:
	
	#sets return boolean
	move $v0, $s2
	
	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra

#=======================================================================

#int checkOffDiagonal()
CHECK_OFF_DIAGONAL:
	#prologue
	add $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	#initialize index and boolean, and loads size
	li $s0, 0
	lw $s1, size
	li $s2, 1
	
CHECK_OFF_DIAGONAL_LOOP:
	#while(index < size)
	bge $s0, $s1, CHECK_OFF_DIAGONAL_LOOP_END
	
	#checks row[index][size - index - 1]
	move $a0, $s0
	sub $a1, $s1, $s0
	sub $a1, $a1, 1
	jal GET_VAL_AT_ROW_AND_COL
	and $s2, $s2, $v0
	
	#increments index
	add $s0, $s0, 1
	
	#returns to loop condition
	b CHECK_OFF_DIAGONAL_LOOP
CHECK_OFF_DIAGONAL_LOOP_END:
	
	#sets return boolean
	move $v0, $s2
	
	#epilogue
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	add $sp, $sp, 16
	jr $ra
