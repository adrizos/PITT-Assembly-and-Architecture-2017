#Alex Drizos
#cs447
#University of Pittsburgh
#Project 2
#Cash Register Simulation in MIPS Assembly Code

.data
titleMsg:  .asciiz "          CS0447\n  Bad Wine & Tipsy Spirits\n  University of Pittsburgh"
cabSstr:   .asciiz "\n\nCabernet Sauvignon    $15.00"
merlotstr: .asciiz "\n\nMerlot                $12.00"
syrahstr:  .asciiz "\n\nSyrah                  $7.00"
pinotstr:  .asciiz "\n\nPinot Noir             $9.00"
malbecstr: .asciiz "\n\nMalbec                $11.00"
zinfstr:   .asciiz "\n\nZinfandel              $8.00"
chardstr:  .asciiz "\n\nChardonnay            $10.00"
sauvBstr:  .asciiz "\n\nSauvignon Blanc       $11.00"
rieslingstr:  .asciiz "\n\nRiesling               $9.00"
totalstr:	   .asciiz "\n\nTotal:                "
cashstr:      .asciiz "\n\nCash:                 "
changestr: .asciiz "\n\nChange:                "	
tempBuffer: .space 9
newLine: .asciiz "\n"


.text
main:
add	$t0, $zero, $zero
add	$s0, $zero, $zero
addi	$t0, $zero, 0xffff8000
la	$s0, ($t0)		#load address of memory location that stores string data for the register in $s0

state1:
#1.clear total to 0
#2.clear the simple display to $0.00
#3.display header on the receipt
#4.wait for user to press a valid button then go to state2
add	$t9, $zero, $zero	# Standby Mode = t9 = 0
add	$t8, $zero, $zero	#reset simple display value
la	$a0, titleMsg		#load address of title message into argument register $a0
la	$a1, ($s0)		#load address of receipt buffer into argument register $a1
jal	_strCopy		#copy title message to the receipt buffer, GUI will display it
add	$s1, $zero, $zero	#zero out s1 to hold running total
add	$s2, $zero, $zero	#zero out s2 to hold cash tender amount

#loop until user starts transaction (i.e. presses a wine button 11-19 inclusive)
standbyLoop:
beq 	$t9, 11, cabS		#cabernet sauvignon pressed
beq 	$t9, 12, merlot		#merlot pressed
beq 	$t9, 13, syrah		#Syrah pressed
beq 	$t9, 14, pinot		#pinot noir pressed
beq 	$t9, 15, malbec		#malbec pressed
beq 	$t9, 16, zinf		#zinfandel pressed
beq 	$t9, 17, chard		#chadonnay pressed
beq 	$t9, 18, sauvB		#sauvignon blanc pressed
beq 	$t9, 19, riesling	#riesling pressed
j	standbyLoop

state2:
#Description
#1. Display the price of the selected wine on the simple display
#2. Display the name and the price of the selected wine on the receipt
#3. Accumulate total with the price of the selected wine
#4. Wait for user to press a button
#	-if user presses a wine, go back to state2
#	-if user presses cancel button, go to state1
#	-if user presses the total button go to state3

#1 once wine button is pressed, set $t8 to its price and the register will update accordingly
#we're also going to set the second argument value here for the following section as specified by the _strConcat function
cabS:	addi $t8, $zero, 15
la	$a1, cabSstr
addi	$s1, $s1, 15	#add price to running total
j	doneAddingPrice	
merlot:	addi $t8, $zero, 12
la	$a1, merlotstr
addi	$s1, $s1, 12	#add price to running total
j	doneAddingPrice	
syrah:	addi $t8, $zero, 7
la	$a1, syrahstr
addi	$s1, $s1, 7	#add price to running total
j	doneAddingPrice	
pinot:	addi $t8, $zero, 9
la	$a1, pinotstr
addi	$s1, $s1, 9	#add price to running total
j	doneAddingPrice	
malbec:	addi $t8, $zero, 11
la	$a1, malbecstr
addi	$s1, $s1, 11	#add price to running total
j	doneAddingPrice	
zinf:	addi $t8, $zero, 8
la	$a1, zinfstr
addi	$s1, $s1, 8	#add price to running total
j	doneAddingPrice	
chard:	addi $t8, $zero, 10
la	$a1, chardstr
addi	$s1, $s1, 10	#add price to running total
j	doneAddingPrice	
sauvB:	addi $t8, $zero, 11
la	$a1, sauvBstr
addi	$s1, $s1, 11	#add price to running total
j	doneAddingPrice	
riesling:addi $t8, $zero, 9
la	$a1, rieslingstr
addi	$s1, $s1, 9	#add price to running total
doneAddingPrice:


#2. display name and price of wine on the receipt

add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string, second argument set in above section
jal	_strConcat	

#3. accumulate total done is #1

#4. wait for action again
#loop until user starts continues action (i.e. presses a wine button 11-19 inclusive, presses total, or presses cancel)
add	$t9, $zero, $zero	#clear $t9 to wait for user input
standbyLoop2:
beq 	$t9, 11, cabS		#cabernet sauvignon pressed
beq 	$t9, 12, merlot		#merlot pressed
beq 	$t9, 13, syrah		#Syrah pressed
beq 	$t9, 14, pinot		#pinot noir pressed
beq 	$t9, 15, malbec		#malbec pressed
beq 	$t9, 16, zinf		#zinfandel pressed
beq 	$t9, 17, chard		#chadonnay pressed
beq 	$t9, 18, sauvB		#sauvignon blanc pressed
beq 	$t9, 19, riesling	#riesling pressed
beq	$t9, 21, state1		#cancel pressed, go back and reset
beq	$t9, 22, state3		#total pressed, go to state 3
j	standbyLoop2


state3: 
#1. Display total on the simple display
#2. Display total on the receipt
#3. Clear the cash value to 0
#4. Wait for user to press a button
#	-if user presses the cancel button, go to state1
#	-if user presses a numeric button, go to state 4

#1. 
add	$t8, $zero, $s1
#2. 
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
la	$a1, totalstr		#set second argument to "total" string address
jal	_strConcat		#add "total" to the string, GUI will add to receipt

#add numeric total value as a string to receipt string
la	$t1, tempBuffer	#temp buffer for return value of _numToPriceString function
add	$a0, $zero, $s1
add	$a1, $zero, $t1
jal	_numToPriceString
	
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
add	$a1, $a1, $t1
jal	_strConcat	


#3.
#$s2 = cash value
add	$s2, $zero, $zero	#clear cash value to zero

#4.
#loop until user continues action (wines are disabled, user can press cancel or numeric buttons)
add	$t9, $zero, $zero	#clear $t9 to wait for user input
standbyLoop3:
beq	$t9,  1, keypad1		#user presses 1
beq	$t9,  2, keypad2		#user presses 2
beq	$t9,  3, keypad3		#user presses 3
beq	$t9,  4, keypad4		#user presses 4
beq	$t9,  5, keypad5		#user presses 5
beq	$t9,  6, keypad6		#user presses 6
beq	$t9,  7, keypad7		#user presses 7
beq	$t9,  8, keypad8		#user presses 8
beq	$t9,  9, keypad9		#user presses 9
beq	$t9, 10, keypad0		#user presses 10
beq	$t9, 21, state1		#cancel pressed, go back and reset
j	standbyLoop3


state4:
#1. cash value = (cash value * 10) + selected button number 
#2. Display cash value on the simple display
#3. Wait for user to press a button
#	- If user press the ”Cancel” button, go to state 1 - If user press a numeric button, go to state 4
#	- If user press the ”Cash” button, go to state 5

#1. #$s2 = cash value, $t0 = 10, $t1 = temp for mflo multiplication result

keypad1:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 1
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad2:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 2
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad3:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 3
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad4:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 4
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad5:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 5
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad6:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 6
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad7:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 7
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad8:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 8
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad9:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 9
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4
keypad0:
add	$t0, $zero, $zero	#clear $t0 to 0
addi	$t0, $zero, 10
mul	$s2, $s2, $t0
addi	$s2, $s2, 0
add	$t8, $zero, $s2
add	$t9, $zero, $zero	#clear $t9 to wait for user input after jump
j	standbyLoop4

#loop until user starts continues action (wines are disabled, user can press cancel, cash, or numeric buttons)
add	$t9, $zero, $zero	#clear $t9 to wait for user input
standbyLoop4:
beq	$t9,  1, keypad1		#user presses 1
beq	$t9,  2, keypad2		#user presses 2
beq	$t9,  3, keypad3		#user presses 3
beq	$t9,  4, keypad4		#user presses 4
beq	$t9,  5, keypad5		#user presses 5
beq	$t9,  6, keypad6		#user presses 6
beq	$t9,  7, keypad7		#user presses 7
beq	$t9,  8, keypad8		#user presses 8
beq	$t9,  9, keypad9		#user presses 9
beq	$t9, 10, keypad0		#user presses 10
beq	$t9, 21, state1			#cancel pressed, go back and reset
beq	$t9, 23, state5			#cash pressed, go to state 5
j	standbyLoop4


state5:
#1. Display cash value on the receipt
#2. change = cash value - total
#3. Display change on the simple display
#4. Display change on the receipt
#5. Wait for user to press a wine button. Once user press a wine button, go to state 6.

#1.
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
la	$a1, cashstr		#set second argument to "cash" string address
jal	_strConcat		#add "cash" to the string, GUI will add to receipt

#add numeric cash value as a string to receipt string
la	$t1, tempBuffer	#temp buffer for return value of _numToPriceString function
add	$a0, $zero, $s2
add	$a1, $zero, $t1
jal	_numToPriceString
	
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
add	$a1, $a1, $t1
jal	_strConcat	

#2.
#$s3 = change
add	$s3, $zero, $zero	#clear $s3 to zero
sub	$s3, $s2, $s1		#change = cash - total

#3.
add	$t8, $zero, $s3		#add change to simple display

#4.
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
la	$a1, changestr		#set second argument to "change" string address
jal	_strConcat		#add "change" to the string, GUI will add to receipt

#add numeric cash value as a string to receipt string
la	$t1, tempBuffer	#temp buffer for return value of _numToPriceString function
add	$a0, $zero, $s3
add	$a1, $zero, $t1
jal	_numToPriceString
	
add	$a0, $zero, $zero
add	$a0, $a0, $s0		#set first argument to receipt buffer string
add	$a1, $a1, $t1
jal	_strConcat	

#loop until user starts new transaction (i.e. presses a wine button 11-19 inclusive)
add	$t9, $zero, $zero
standbyLoop5:
beq 	$t9, 11, state6		#cabernet sauvignon pressed
beq 	$t9, 12, state6		#merlot pressed
beq 	$t9, 13, state6		#Syrah pressed
beq 	$t9, 14, state6		#pinot noir pressed
beq 	$t9, 15, state6		#malbec pressed
beq 	$t9, 16, state6		#zinfandel pressed
beq 	$t9, 17, state6		#chadonnay pressed
beq 	$t9, 18, state6		#sauvignon blanc pressed
beq 	$t9, 19, state6		#riesling pressed
j	standbyLoop5

state6:
#1. Clear total to 0
#2. Display the header on the receipt
#3. Go to state2

#1. 
add	$s1, $zero, $zero	#clear total to zero
add	$s2, $zero, $zero	#clear cash to zero
add	$s3, $zero, $zero	#clear change to zero
#2.
la	$a0, titleMsg		#load address of title message into argument register $a0
lb	$zero, 0($s0)		#"clear" receipt buffer

la	$a1, ($s0)		#load address of receipt buffer into argument register $a1
jal	_strCopy		#copy title message to the receipt buffer, GUI will display it

#3.	jump to state 2 in a position dependent on wine selected for new transaction

newTransactionCheck:
beq 	$t9, 11, cabS		#cabernet sauvignon pressed
beq 	$t9, 12, merlot		#merlot pressed
beq 	$t9, 13, syrah		#Syrah pressed
beq 	$t9, 14, pinot		#pinot noir pressed
beq 	$t9, 15, malbec		#malbec pressed
beq 	$t9, 16, zinf		#zinfandel pressed
beq 	$t9, 17, chard		#chadonnay pressed
beq 	$t9, 18, sauvB		#sauvignon blanc pressed
beq 	$t9, 19, riesling	#riesling pressed
j	newTransactionCheck

endOfMain:
addi $v0, $zero, 10
syscall		#terminates program


#HELPER FUNCTIONS

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
#we need to swap some values around to jump to a nested strCopy function call
add	$t0, $zero, $zero	#clear for swap
add	$t0, $a1, $zero		#put $a1 in temp for 3 step swap
add	$a1, $a0, $zero		#put address of null char of 1st string in $a1 as specified by strCopy
add	$a0, $t0, $zero		#put old $a1 value in $a0

addi	$sp, $sp, -4		#create space on the stack for register backups
sw	$ra, 0($sp)		#save return value before nested function call

jal	_strCopy		#strCopy here will concatenate the strings by copying the second string onto the first string starting at 1st's null char

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
#s0 = count
add $s0, $zero, $zero	#initialize count to zero
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
