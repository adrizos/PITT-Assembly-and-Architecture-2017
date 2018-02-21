#Alex Drizos
#University of Pittsburgh / Computer Science
#Sudoku Solver - Recursive Backtracking Solution in MIPS Assembly
#Dependencies:
#MARS MIPS Environment
#Java GUI files from .zip file must be loaded into Mars tools section
#Java GUI files created by: Dr. Thumrongsak Kosiyatrakul / University of Pittsburgh

.data
puzzleAddress:	.word	0xFFFF8000
newLine:	.asciiz "\n"


.text


main:
jal	_printBoardToConsole
jal	_solveSudoku		#reg stuff???
#terminate program
li $v0, 10
syscall				    #terminates program


_solveSudoku:
add	$t3, $zero, $zero	#positionIndex counter
addi	$t2, $zero, 1	#$t2 = counter, starts at 1
#jal	_printBoardToConsole	#debugging
addi	$t9, $zero, 9	#9 constant for tryAValue
lw	$t0, puzzleAddress	#load puzzle address in $t0
wholeBoardLoop:			#loop traverses the entire board 0-80 positions
lb	$t1, ($t0)		    #load value  at puzzle address
beqz	$t1, tryAValue	#if spot is empty, try a value
#otherwise
#is there a next position? if so, increment. otherwise board is full
slti	$t8, $t3, 80
bnez	$t8, incrementWholeBoardLoop
boardFull:
li	$v0, 1
jr	$ra
incrementWholeBoardLoop:
addi	$t0, $t0, 1		#increment address
addi	$t3, $t3, 1		#increment positionIndex
j	wholeBoardLoop		#try the next position


tryAValue:			#try values 1-9 for each position
#prepare to call _checkRow
#arguments $a0 = value to try, $a1 = position index
#backup registers
addi	$sp, $sp, -24
sw	$ra, 0($sp)
sw	$t0, 4($sp)
sw	$t1, 8($sp)
sw	$t2, 12($sp)
sw	$t9, 16($sp)
sw	$t3, 20($sp)
add	$a0, $zero, $t2
add	$a1, $zero, $t3
jal	_checkRow
lw	$ra, 0($sp)
lw	$t0, 4($sp)
lw	$t1, 8($sp)
lw	$t2, 12($sp)
lw	$t9, 16($sp)
lw	$t3, 20($sp)
addi	$sp, $sp, 24
#check if there was a conflict
beqz	$v0, incrementValue
#prepare to call _checkCol
#arguments $a0 = value to try, $a1 = position index
#backup registers
addi	$sp, $sp, -24
sw	$ra, 0($sp)
sw	$t0, 4($sp)
sw	$t1, 8($sp)
sw	$t2, 12($sp)
sw	$t9, 16($sp)
sw	$t3, 20($sp)
add	$a0, $zero, $t2
add	$a1, $zero, $t3
jal	_checkColumn
lw	$ra, 0($sp)
lw	$t0, 4($sp)
lw	$t1, 8($sp)
lw	$t2, 12($sp)
lw	$t9, 16($sp)
lw	$t3, 20($sp)
addi	$sp, $sp, 24
#check if there was a conflict
beqz	$v0, incrementValue
#prepare to call _checkBlock
#arguments $a0 = value to try, $a1 = position index
#backup registers
addi	$sp, $sp, -24
sw	$ra, 0($sp)
sw	$t0, 4($sp)
sw	$t1, 8($sp)
sw	$t2, 12($sp)
sw	$t9, 16($sp)
sw	$t3, 20($sp)
add	$a0, $zero, $t2
add	$a1, $zero, $t3
jal	_checkBlock
lw	$ra, 0($sp)
lw	$t0, 4($sp)
lw	$t1, 8($sp)
lw	$t2, 12($sp)
lw	$t9, 16($sp)
lw	$t3, 20($sp)
addi	$sp, $sp, 24
#check if there was a conflict
beqz	$v0, incrementValue

#if all three checks pass, we can place the digit
sb	$t2, ($t0)
#backup everything for this call and recurse
addi	$sp, $sp, -24
sw	$ra, 0($sp)
sw	$t0, 4($sp)
sw	$t1, 8($sp)
sw	$t2, 12($sp)
sw	$t9, 16($sp)
sw	$t3, 20($sp)
jal	_solveSudoku		#RECURSION WOO //also backtracking returns here
lw	$ra, 0($sp)
lw	$t0, 4($sp)
lw	$t1, 8($sp)
lw	$t2, 12($sp)
lw	$t9, 16($sp)
lw	$t3, 20($sp)
addi	$sp, $sp, 24

#check _solveSudoku's return value
#case 1 - failure :/
beqz	$v0, erasePlacedValue
#case 2 - success
li	$v0, 1
jr	$ra		#return successfull board

#erase placed value
erasePlacedValue:
sb	$zero, ($t0)

incrementValue:
#if we run out of numbers 1 - 9 (none of them were able to be placed), we BACKTRACK
beq	$t2, $t9, backTrack

#otherwise, increment
addi	$t2, $t2, 1
j	tryAValue

backTrack:
li	$v0, 0
jr	$ra


############################################
#Helper Functions
#############################################

############################################
#_printBoardToConsole
#Descripton: This function prints the starting board to the console
#
#Variables: $t0 = puzzle starting address in main memory
#Arguemnts:n/a
#
#Return: n/a
#############################################
#clear temporary registers
_printBoardToConsole:
li	$v0, 4
la	$a0, newLine
syscall			#printline debugging
move 	$t0, $zero
move 	$t1, $zero		#t1 = counter,
addi	$t1, $zero, 1		#counter starts at 1 :/
move	$a0, $zero



lw	$t0, puzzleAddress #load puzzle address in $t0

printLoop:			   #loop to print board
li	$v0, 1
lb	$a0, 0($t0)
syscall				   #print digit
####check if count is divisble by 9
addi	$sp, $sp, -16
sw	$t0, 0($sp)
sw	$t1, 4($sp)
sw	$a0, 8($sp)
sw	$ra, 12($sp)
add	$a0, $zero, $t1
jal	_isDivisible
lw	$t0, 0($sp)
lw	$t1, 4($sp)
lw	$a0, 8($sp)
lw	$ra, 12($sp)
addi	$sp, $sp, 16	#restore stack point after reloading this functions values
#book keeping for this loop
addi	$t0, $t0, 1		#increment address
addi	$t1, $t1, 1		#increment counter
slti	$t2, $t1, 82
beqz  	$t2, printLoopDone
j	printLoop
printLoopDone:
jr	$ra


#---------------
_isDivisible:
addi	$t0, $zero, 9
div	$t1, $a0, $t0
mfhi	$t2
beqz	$a0, skipNewLine
beqz	$t2, printNewLine
bnez	$t2, skipNewLine

printNewLine:
li	$v0, 4
la	$a0, newLine
syscall				#print new line when count is divisble by 9 for formatting
jr	$ra
skipNewLine:
jr	$ra

#####################################
#_checkRow
#arguments: a0 = currDigit, a1 = position index
#
#should be called before digit is placed!!!!
######################################

_checkRow:
lw	$t0, puzzleAddress		#load puzzle address in $t0
#pointer = pointer to base memory address + [(positionIndex/9)*9]
addi	$t1, $zero, 9			#t1 = 9 for above formula
divu 	$a1, $t1			#position index / 9
mflo 	$t2				    #t2 = quotient
multu	$t2, $t1
mflo	$t3				    #t3 = t2*t1 = (t2*9)
add	$t1, $zero, $zero		#clear t1
add	$t1, $t3, $t0			# t1 = pointer
add 	$t4, $zero, $zero
addi	$t4, $t1,9	    	#$t4 = END
#loop through the entire row starting at begining of the row
checkRowLoop:
beq	$t1, $t4, checkRowReturn1	#if we've gone throught the whole row and haven't find a match, its ok to place digit there, return 1
lb	$t5, ($t1)			    #put p addresses value into $t5
beq	$a0, $t5, checkRowReturn0	#if the current digit already exists in row, jump and return "0"
addi	$t1, $t1, 1			#incrememt p pointer
j	checkRowLoop

checkRowReturn1:
li	$v0, 1
jr	$ra
checkRowReturn0:
li	$v0, 0
jr	$ra

#--------------------
_checkColumn:
lw	$t0, puzzleAddress		#load puzzle address is $t0
#pointer = pointer to base memory address + [position index % 9]
addi	$t1, $zero, 9		#t1 = 9 for above formula
divu	$a1, $t1			#position index / 9
mfhi	$t2				    #$t2 = remainder
add	$t1, $zero, $zero		#clear t1
add	$t1, $t2, $t0			# t1 = pointer
addi	$t4, $t1, 81		#t4 = END
checkColumnLoop:
beq	$t1, $t4, checkColumnReturn1	#if we've gone throught the whole column and haven't find a match, its ok to place digit there, return 1
lb	$t5, ($t1)			    #put p address value into $t5
beq	$a0, $t5, checkColumnReturn0	#if the current digit already exists in a column, jump and return "0"
addi	$t1, $t1, 9			#increment p pointer
j	checkColumnLoop

checkColumnReturn1:
li	$v0, 1
jr	$ra
checkColumnReturn0:
li	$v0, 0
jr	$ra

#####################################
#_checkBlock
#arguments: a0 = currDigit, a1 = position index
#
#should be called before digit is placed!!!!
######################################
_checkBlock:
lw	$t0, puzzleAddress		#load puzzle address is $t0
addi	$t9, $zero, 9		#9 value for algorithm
addi	$t8, $zero, 3		#3 value for algorithm
add	$t7, $zero, $zero		#$t7 is loop counter starts at 0
###1
divu	$a1, $t9			#mflo == quotient for row, mfhi == remainder for column
#find actual row
mflo	$t1
#find actual column
mfhi	$t2
###2
#determine which block we're in
divu	$t1, $t8
mflo	$t1					#$t1 = blockRow
divu	$t2, $t8
mflo	$t2					#$t2 = blockColumn
##block coordinates are now ($t1, $t2)

###3
#computer upper left corner of current block (this is where we'll start checking)
#mflo = lower order 32 result
multu	$t1, $t8
mflo	$t1					#$t1 = topLeft row
multu	$t2, $t8
mflo	$t2					#$t2 = topLeft column

###4
#given the top left block coordinates, compute the relative position index of that point (0-80) on the board
multu	$t1, $t9
mflo	$t1
add	$t1, $t1, $t2				#$t1 = topLeft position index to start the block traversal for comparisons

###5
#traverse block from topLeft index point
#simple inner block traversal add in order: 1,1,7 1,1,7 1,1
#blockTraversal
add	$t1, $t1, $t0				#

lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (1)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (2)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 7				#increment position (3)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (4)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (5)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 7				#increment position (6)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (7)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0
add	$t1, $t1, 1				#increment position (8)
lb	$t2, ($t1)				#load value in current block position index
beq	$a0, $t2, checkBlockReturn0		#if digits are equal, we can't place, jump to return 0

checkBlockReturn1:
li	$v0, 1
jr	$ra
checkBlockReturn0:
li	$v0, 0
jr	$ra



testCheckRow:
addi	$a1, $zero, 29				#start at this position
addi	$a0, $zero, 2				#currDigit
jal	_checkRow
add	$a0, $zero, $v0
li	$v0, 1
syscall
testCheckColumn:
addi	$a1, $zero, 29				#start at this position
addi	$a0, $zero, 2				#currDigit
jal	_checkColumn
add	$a0, $zero, $v0
li	$v0, 1
syscall
testCheckBlock:
addi	$a1, $zero, 29				#start at this position
addi	$a0, $zero, 2				#currDigit
jal	_checkBlock
add	$a0, $zero, $v0
li	$v0, 1
syscall
