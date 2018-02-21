#Alex Drizos
#CS 0447 Assembly and Computer Architecture
# .data section pre-written and not to be modiified according to project spec
# Implement your five functions located at the end of this program.
.data
	buffer1:	.asciiz	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	buffer2:	.asciiz	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	buffer3:	.asciiz	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	buffer4:	.asciiz	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	prompt1:	.asciiz	"Please enter a string: "
	prompt2:	.asciiz	"Please enter another string: "
	prompt3:	.asciiz	"Please enter a positive integer: "
	test1:		.asciiz	"Test function _strCopy\n"
	enter1:		.asciiz	"You just entered  : "
	result1:	.asciiz	"Result of _strCopy: "
	check1:		.asciiz	"If both strings are identical, your _strCopy works properly.\n\n"
	test2:		.asciiz	"Test function _strConcat\n"
	str1msg:	.asciiz "String 1: "
	str2msg:	.asciiz	"String 2: "
	result2:	.asciiz "Result of _strConcat: "
	check2:		.asciiz "\nIf the result looks fine, your _strConcat works properly.\n\n"
	test3:		.asciiz "Test function _getNumDigits\n"
	result3:	.asciiz "Your _getNumDigits says "
	result4:	.asciiz " has "
	result5:	.asciiz	" digits."
	check3:		.asciiz "\nIf the number of digits is correct, your function _getNumDigits works correctly.\n\n"
	test4:		.asciiz "Test function _numToPriceString\n"
	result6:	.asciiz "The output string from _numToPriceString with the number "
	result7:	.asciiz " as the argument is the string \""
	check4:		.asciiz "\"\nIf the output string looks correct, your function _numToPriceString works properly.\n"
	test5:		.asciiz "Test function _div10\n"
	result8:	.asciiz "From your _div10, "
	result9:	.asciiz " divided by 10 is "
	result10:	.asciiz	" and the remainder is "
	check5:		.asciiz "\nIf the quotient and the reminder are correct, your function _div10 works properly.\n\n"
.text
	#################
	# Test _strCopy #
	#################

	la   $a0, test1
	addi $v0, $zero, 4
	syscall			# print "Test function _strCopy"
	la   $a0, prompt1
	addi $v0, $zero, 4
	syscall			# print "Please enter a string: "
	la   $a0, buffer1
	addi $a1, $zero, 62
	addi $v0, $zero, 8
	syscall			# Read a string into buffer1
	addi $s0, $zero, 10	# Ascii 10 '\n'
	# Get rid of '\n'
	la   $s1, buffer1
mpLoop1:
	lb   $s2, 0($s1)
	beq  $s0, $s2, mpDone1
	addi $s1, $s1, 1
	j    mpLoop1
mpDone1:
	sb   $zero, 0($s1)
	# print the string user entered
	la   $a0, enter1
	addi $v0, $zero, 4
	syscall			# Print "You just entered:   "
	la   $a0, buffer1
	addi $v0, $zero, 4
	syscall			# Print the string user just entered
	addi $a0, $zero, 10
	addi $v0, $zero, 11
	syscall			# Print '\n'
	# Call _strCopy
	la   $a0, buffer1	# Source string
	la   $a1, buffer2	# Destination buffer
	jal  _strCopy		# Call the function _strCopy
	la   $a0, result1
	addi $v0, $zero, 4
	syscall			# Print "Result of _strCopy: "
	la   $a0, buffer2
	addi $v0, $zero, 4
	syscall			# Print the result of _strCopy
	addi $a0, $zero, 10
	addi $v0, $zero, 11
	syscall			# Print '\n'
	la   $a0, check1
	addi $v0, $zero, 4
	syscall			# Print check1

	###################
	# Test _strConcat #
	###################

	la   $a0, prompt2
	addi $v0, $zero, 4
	syscall			# print "Please enter another string: "
	la   $a0, buffer3
	addi $a1, $zero, 62
	addi $v0, $zero, 8
	syscall			# Read a string into buffer1
	addi $s0, $zero, 10	# Ascii 10 '\n'
	# Get rid of '\n'
	la   $s1, buffer3
mpLoop2:
	lb   $s2, 0($s1)
	beq  $s0, $s2, mpDone2
	addi $s1, $s1, 1
	j    mpLoop2
mpDone2:
	sb   $zero, 0($s1)
	la   $a0, str1msg
	addi $v0, $zero, 4
	syscall			# Print "String 1: "
	la   $a0, buffer1
	addi $v0, $zero, 4
	syscall			# Print the first string user entered
	addi $a0, $zero, 10
	addi $v0, $zero, 11
	syscall			# Print '\n'
	la   $a0, str2msg
	addi $v0, $zero, 4
	syscall			# Print "String 2: "
	la   $a0, buffer3
	addi $v0, $zero, 4
	syscall			# Print the second string user entered
	addi $a0, $zero, 10
	addi $v0, $zero, 11
	syscall			# Print '\n'
	# Call the function _strConcat
	la   $a0, buffer1
	la   $a1, buffer3
	jal  _strConcat
	# print result
	la   $a0, result2
	addi $v0, $zero, 4
	syscall			# Print "Result of _strConcat: "
	la   $a0, buffer1
	addi $v0, $zero, 4
	syscall			# Print the result string of _strConcat
	la   $a0, check2
	addi $v0, $zero, 4
	syscall			# Print check2

	###############
	# Test _div10 #
	###############

	la   $a0, test5
	addi $v0, $zero, 4
	syscall			# Print "Test _div10"
	la   $a0, prompt3
	addi $v0, $zero, 4
	syscall			# Print "Please enter a positive integer: "
	addi $v0, $zero, 5
	syscall			# Read integer
	add  $s3, $zero, $v0	# $s3 is the integer user just entered
	add  $a0, $zero, $s3
	jal  _div10
	add  $s4, $zero, $v0
	add  $s5, $zero, $v1
	la   $a0, result8
	addi $v0, $zero, 4
	syscall			# Print "From your _div10, "
	add  $a0, $zero, $s3
	addi $v0, $zero, 1
	syscall			# Print the integer user entered
	la   $a0, result9
	addi $v0, $zero, 4
	syscall			# Print " divided by 10 is "
	add  $a0, $zero, $s4
	addi $v0, $zero, 1
	syscall			# Print the quotient
	la   $a0, result10
	addi $v0, $zero, 4
	syscall			# Print " and the remainder is "
	add  $a0, $zero, $s5
	addi $v0, $zero, 1
	syscall			# Print the remainder
	la   $a0, check5
	addi $v0, $zero, 4
	syscall

	######################
	# Test _getNumDigits #
	######################

	la   $a0, test3
	addi $v0, $zero, 4
	syscall			# Print "Test _getNumDigits"
	#la   $a0, prompt3
	#addi $v0, $zero, 4
	#syscall			# Print "Please enter a positive integer: "
	#addi $v0, $zero, 5
	#syscall			# Read integer
	#add  $s3, $zero, $v0	# $s3 is the integer user just entered
	add  $a0, $zero, $s3
	jal  _getNumDigits
	add  $s4, $zero, $v0
	la   $a0, result3
	addi $v0, $zero, 4
	syscall			# Print "Your _getNumDigits says "
	add  $a0, $zero, $s3
	addi $v0, $zero, 1
	syscall			# Print the integer user entered
	la   $a0, result4
	addi $v0, $zero, 4
	syscall			# Print " has "
	add  $a0, $zero, $s4
	addi $v0, $zero, 1
	syscall			# Print the number of digits
	la   $a0, result5
	addi $v0, $zero, 4
	syscall			# Print "digits."
	la   $a0, check3
	addi $v0, $zero, 4
	syscall

	#######################
	# Test _numToPriceString #
	#######################

	la   $a0, test4
	addi $v0, $zero, 4
	syscall			# Print "Test _numToPriceString"
	la   $a0, result6
	addi $v0, $zero, 4
	syscall			# Print "The output ..."
	add  $a0, $zero, $s3
	addi $v0, $zero, 1
	syscall			# Print the integer user entered
	la   $a0, result7
	addi $v0, $zero, 4
	syscall			# Print " as the argument: "
	# Call the function _toPriceString
	add  $a0, $zero, $s3
	la   $a1, buffer4
	jal  _numToPriceString
	la   $a0, buffer4
	addi $v0, $zero, 4
	syscall
	la   $a0, check4
	addi $v0, $zero, 4
	syscall			# Print "\"\nIf..."

	addi $v0, $zero, 10
	syscall


# _strCopy
#
# Copy a null-terminated source string to a destination buffer
#
# Arguments:
#   - $a0: An address of the first character of a source string
#   - $a1: An address of a buffer
# Return Value:
#   - None
_strCopy:
    lbu $t0, 0($a0) 	#load a byte from source string
    sb $t0, 0($a1) 	#store byte in destination buffer
    beqz $t0, strCopyExit #stop when null is copied
    addi $a0, $a0, 1 	#increment both addresses
    addi $a1, $a1, 1
    j _strCopy		#loop

strCopyExit:
    jr $ra




# _strConcat
#
# Concatenate the second string to the end of the first string
#
# Arguments:
#   - $a0: The address of the first string
#   - $a1: The address of the second string
# Return Value:
#   - None
_strConcat:
findNullLoop:
lbu	$t0, 0($a0)		#put nth byte in $t0
beqz	$t0, findNullLoopEnd	#we found null so jump out of loop
addi	$a0, $a0, 1		#otherwise, increment to next char
j	findNullLoop		#loop

findNullLoopEnd:
#we need to swap some values around to just to a nested strCopy function call
add	$t0, $zero, $zero	#clear for swap
add	$t0, $a1, $zero		#put $a1 in temp for 3 step swap
add	$a1, $a0, $zero		#put address of null char of 1st string in $a1 as specified by strCopy
add	$a0, $t0, $zero		#put old $a1 value in $a0

addi	$sp, $sp, -4		#create space on the stack for register backups
sw	$ra, 0($sp)		#save return value before nested function call

jal	_strCopy			#strCopy here will concatenate the strings by copying the second string onto the first string starting at 1st's null char

lw	$ra, 0($sp)		#replace return value
jr	$ra			#return to caller





# _div10
#
# Return the result of a given number divided by 10
#
# Arguments:
#   - $a0: A positive integer number
# Return Values:
#   - $v0: Quotient
#   - $v1: Remainder
_div10:
    #initialize registers
    #$t0 = 10 = divisor
    #clear t0
    addi $t0, $zero, 10
    #$t1 = quotient, will be returned in $v0
    add $t1, $zero, $zero
    #$a0 = dividend
    #t2 = temp
    #reset return quotient and divisor values to 0
    add $v0, $zero, $zero
    add $v1, $zero, $zero

divideLoop:

    #temp = dividend - divsor
    sub $t2, $a0, $t0
    #if temp < 0 jump to done
    slt $t3, $t2, $zero
    bnez $t3, divideLoopDone
    #dividend -= divsor
    sub $a0, $a0, $t0
    #quotient++
    addi $v0, $v0, 1

    #jump to loop
    j	divideLoop
divideLoopDone:
    add $t2, $t2, $t0
    #remainder = temp
    add $v1, $v1, $t2
    #quotient = $v0
    add $v0, $v0, $t1
    jr $ra




# _getNumDigits
#
# Returns the number of digits of a given positive integer
#
# Argument:
#   - $a0: a positive integer
# Return Value:
#   - $v0: the number of digits of a given positive integer
_getNumDigits:
#Im assuming user will not buy more than $9,999 worth of wine in one transaction
#t1 = 1, $t2 = 2, $t3 = 3, $t4 = 4
addi $t1, $zero, 1
addi $t2, $zero, 2
addi $t3, $zero, 3
addi $t4, $zero, 4

#check for 1 digit
slti $t0, $a0, 10
beq $t0, $t1, return1

#check for 2 digits
slti $t0, $a0, 100
beq $t0, $t1, return2
#check for 3 digits
slti $t0, $a0, 1000
beq $t0, $t1, return3
#check for 4 digits
slti $t0, $a0, 10000
beq $t0, $t1, return4

#return 1 digit
return1:
add $v0, $zero, $t1
jr $ra

#return 2 digits
return2:
add $v0, $zero, $t2
jr $ra

#return 3 digits
return3:
add $v0, $zero, $t3
jr $ra

#return 4 digits
return4:
add $v0, $zero, $t4
jr $ra

# _numToPriceString
#
# Convert a given positive integer into string of the form $xx.00
#
# Argument
#   - $a0: A positive integer
#   - $a1: An address of a buffer
# Return Value
#   - None
_numToPriceString:
#PART 1 -  convert integer to string
#s1 = 1st digit, $s2 = 2nd digit, $s3 = 3rd digit, $s4 = 4th digit
#s0 = count
add $s0, $zero, $zero	#initialize count to zero
addi $sp, $sp, -40
sw $ra, 0($sp)		#back up ra and ao registers before nested function call
sw $a0, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)		#back up s(x) registers that caller may have used
sw $s2, 16($sp)
sw $s3, 20($sp)
sw $s4, 24($sp)
sw $s5, 28($sp)
sw $s6, 32($sp)
sw $s7, 36($sp)

add $t9, $zero, $zero	#temp for comparison to flag value
addi $t9, $zero, 1
#zero out s1-s4 to ensure non used registers are null
add	$s1, $zero, $zero
add	$s2, $zero, $zero
add	$s3, $zero, $zero
add	$s4, $zero, $zero

#first part of algorith, after we get these first s values, we'll add 0x30 to get ascii value
divideToFindAsciiValueBase:
jal _div10
add $s1, $zero, $v1	#remainder in v1 is first digit
add $a0, $zero, $v0	#quotient from last _div10 call is new agrument to pass to get 2nd digit
addi $s1, $s1, 0x30	#add 0x30 to get ascii value
addi $s0, $s0, 1	#increment digit count
#CHECK: if quotient is less than 1, we know its our last digit, jump out
slti $t0, $v0, 1	#t0 = 1 if v0 is less than 1
bnez $t0, endDivideToFindAsciiValueBase		#otherwise, continue
jal _div10
add $s2, $zero, $v1	#remainder in v1 is second digit
add $a0, $zero, $v0	#quotient from last _div10 call is new agrument to pass to get 3rd digit
addi $s2, $s2, 0x30	#add 0x30 to get ascii value
addi $s0, $s0, 1	#increment digit count
#CHECK: if quotient is less than 1, we know its our last digit, jump out
slti $t0, $v0, 1	#t0 = 1 if v0 is less than 1
bnez $t0, endDivideToFindAsciiValueBase		#otherwise, continue
jal _div10
add $s3, $zero, $v1	#remainder in v1 is third digit
add $a0, $zero, $v0	#quotient from last _div10 call is new agrument to pass to get 4th digit
addi $s3, $s3, 0x30	#add 0x30 to get ascii value
addi $s0, $s0, 1	#increment digit count
#CHECK: if quotient is less than 1, we know its our last digit, jump out
slti $t0, $v0, 1	#t0 = 1 if v0 is less than 1
bnez $t0, endDivideToFindAsciiValueBase		#otherwise, continue
jal _div10
add $s4, $zero, $v1	#remainder in v1 is fourth digit
addi $s4, $s4, 0x30	#add 0x30 to get ascii value
addi $s0, $s0, 1	#increment digit count
#assume we wont have more than 4 digits based on reasonable values associated with wine store purchases
li $v0, 1
add $a0, $zero, $zero
add $a0, $zero, $s0
syscall
endDivideToFindAsciiValueBase:

#done with part 1
lw $a0, 4($sp)	#restore original $a0 value

#PART 2 - format string in form $xx.00
#loop and add each part to buffer, use count variable to determine how many digits to add
#save buffer address in $a1 to temp register $t0
add $t0, $zero, $zero
add $t0, $a1, $zero
#1st - add $ character = 0x24
add $t1, $zero, $zero
addi $t1, $zero, 0x24
sb $t1, 0($t0)
#2nd - add digits while i(=$t2) = numdigits(=$s0)
add $t2, $zero, $zero 	#zero out t2 for i
#add digits in reverse order due to previous algorithm implimentation "strings r-l numbers l-r"
addDigits:
beqz $s4, next1
addi $t0, $t0, 1	#increment buffer index
sb $s4, 0($t0)		#store first digit into buffer
#addi $s0, $s0, 1	#increment numdigits
addi $t2, $t2, 1	#increment i
next1:
beqz $s3, next2
#check if i is = numdigits
beq $s0, $t2, endAddDigits
addi $t0, $t0, 1	#increment buffer index
sb $s3, 0($t0)		#store second value into buffer
#addi $s0, $s0, 1	#increment numdigits
addi $t2, $t2, 1	#increment i
next2:
beqz $s2, next3
#check if i is = numdigits
beq $s0, $t2, endAddDigits
addi $t0, $t0, 1	#increment buffer index
sb $s2, 0($t0)		#store third value into buffer
#addi $s0, $s0, 1	#increment numdigits
addi $t2, $t2, 1	#increment i
next3:
#check if i is = numdigits
beq $s0, $t2, endAddDigits
addi $t0, $t0, 1	#increment buffer index
sb $s1, 0($t0)		#store fourth value into buffer
#addi $s0, $s0, 1	#increment numdigits
addi $t2, $t2, 1	#increment i


endAddDigits:
addi $t0, $t0, 1	#increment buffer index
addi $t1, $zero, 0x2e	#add period in hex to t1
sb $t1, 0($t0)		#add period to buffer
addi $t0, $t0, 1	#increment buffer index
addi $t1, $zero, 0x30	#add 0 in hex to t1
sb $t1, 0($t0)		#add 0 to buffer
addi $t0, $t0, 1	#increment buffer index
sb $t1, 0($t0)		#add second 0 to buffer
addi $t0, $t0, 1	#increment buffer index
addi $t1, $zero, 0
sb $t1, 0($t0)		#add null terminator to buffer



#function is complete, restore backed up values and return
lw $ra, 0($sp)		#restor ra register after nested function calls
lw $a0, 4($sp)		#restor ao register after nested function calls
lw $s0, 8($sp)
lw $s1, 12($sp)		#restore s(x) registers after nested function calls
lw $s2, 16($sp)
lw $s3, 20($sp)
lw $s4, 24($sp)
lw $s5, 28($sp)
lw $s6, 32($sp)
lw $s7, 36($sp)
addi $sp, $sp, 40	#reset stack pointer
jr $ra			#return to caller
