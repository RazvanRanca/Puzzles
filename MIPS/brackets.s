###################################################################################
# Reads an input string, checks that it is properly bracketed and returns a suitable output message.
# Both input and output messages are terminated with a new line.
# Possible brackets are ( ) and [ ]
# A string is considered correctly bracketed if :
#	The # of open brackets of a type is equal to the # of closed brackets of the same type
#	For every character c in the string, the # of open brackets of a type in the substring starting at the beggining of the string 
#	and ending at character c is >= the number of closed brackets of the same type in the same substring
# The possible output messages consist of one succes message and 3 different type of error messages( mismatching closed bracket = "(]";
# unexpected close bracket = "())" and unclosed open bracket = "(()" )
# If the program encounters a mistake it should take note of it and then continue as if the mistake wasn't there, so it might find further errors.
###################################################################################

	.data
inputString:
	.space 50	# set aside 50 bytes to store the input string
stack:
	.space 50 	# set aside 50 bytes for the stack onto which we'll push the brackets
o1:
	.byte 40 	# store the '(' character
c1:
	.byte 41	# store the ')' character
o2:
	.byte 91	# store the '[' character
c2:
	.byte 93	# store the ']' character
sm:
	.asciiz "At "	# store the start of every error message
m1:
	.asciiz ": mismatching close bracket\n" # the first error message
m2:
	.asciiz ": unexpected close bracket\n"	# second error message
m3:
	.asciiz ": unclosed open bracket(s)\n"	# third error message
m4:
	.asciiz ": all brackets matched\n"	# success message

	.globl main

	.text

##################################
# Register usage:
# $s0  -holds the newline character, used to determine when we have finished reading the input
# $s1 - the stack pointer
# $s2 - the address where the stack begins, used to determine when the stack is empty
# $s3 - the address of the current character we are considering
# $s4 - the value of the current character
# $s5 - the position of the current character in the input string
# $s6 - a flag which becomes zero if we find an error, used to determine wether to print the success message
# $a0, $a1 - used as parameters for both the print function and the syscall
# $t0, $t1, $t2 - used to store the values of different parantheses, for comparation with other registers.
#################################
main:
	addi $s0, $zero, 10 	# in s0 store the newline character(ASCII code of 10)
	addi $s6, $zero, 1	# this will be 1 if we have had no errors and 0 otherwise, used to check for success

	la $s1, stack		# $s1 will be the stack pointer
	move $s2, $s1		# $s2 just holds the location where the stack starts

	la $s3, inputString		# $s3 holds the address where we will put the read input string
					# in general $s3 will point to the character we are currently considering(the current character)

	# Read the input string, it'll be stored starting at address held in $s3
	move $a0, $s3
	li $v0, 8
	syscall			#read it
	
	addi $s5, $zero, 1	# store the position of the current character, right now we're considering the first character

	# loop through characters, if open bracket add to stack, if closed bracket pop stack
	checkCharacters:
		lb $s4, 0($s3)		# load the value of the current character
		beq $s4, $s0, finish	# if current character is '\n' we're done
		lb $t0, o1
		beq $s4, $t0, push	# if current character is '(' push to stack
		lb $t0, o2
		beq $s4, $t0, push	# if current character is '[' push to stack
		lb $t0, c1
		beq $s4, $t0, check	# if current character is ')' check for error conditions and maybe pop stack
		lb $t0, c2
		beq $s4, $t0, check	# if current character is ']' check for error conditions and maybe pop stack
	
	# do preparations for checking the next character
	nextChar:
		addi $s3, $s3, 1	# get the address of the next character in the input string
		addi $s5, $s5, 1	# increase the current character position
		j checkCharacters	# loop again

	# push a open bracket onto the stack
	push:
		addi $s1, $s1, 1	# increment stack pointer		
		sb $s4, 0($s1)		# add character to stack
		j nextChar		# get next character and continue loop

	# a closed bracket has been found, if stack is empty print an error message, otherwise pop the stack
	check:
		bne $s1, $s2, pop	# if the stack is empty
		la $a0, m2		# there is a unexpected close bracket, load the second error message in the first parameter register
		move $a1, $s5		# put the current character in the second parameter register
		jal print		# call the print function
		move $s6, $zero		# mark that there has been an error 
		j nextChar		# after printing continue checking characters

		# pop a open bracket from the stack, if it doesn't match the current closed bracket print an error message
		pop:			
			lb $t0, 0($s1) 		# load the last character on the stack
			addi $s1, $s1, -1	# pop the stack
			
			lb $t1, c1		# load the ')' bracket
			lb $t2, o1		# load the '(' bracket
			bne $s4, $t1, case2	# if( currentBracket == ')' ) {
			beq $t0, $t2, nextChar	# 	if( poppedBracket != '(' ) {
			la $a0, m1		#		load the first error message in the first parameter
			move $a1, $s5		#		put the current character in the second parameter
			jal print		#		print the error
			move $s6, $zero		# 		mark that there has been an error 
			j nextChar		# 		goTo nextChar
						#	}
						#	else
						#		goTo nextChar
						# }
			case2:			# else {
			lb $t2, o2		# 	load the '[' bracket
			beq $t0, $t2, nextChar	# 	if(poppedBracket != '[' ) {
			la $a0, m1		#		load the first error message in the first parameter
			move $a1, $s5		# 		put the current character in the second parameter
			jal print		# 		print the error
			move $s6, $zero		# 		mark that there has been an error
			j nextChar		# 		goTo nextChar
						#	}
						#	else
						#		goTo nextChar

	#check for any unclosed brackets, and possibly display success message
	finish: 	
		beq $s1, $s2, checkSuccess	# if stack is empty check for success condition
		la $a0, m3			# otherwise load the third error message in the first paramete
		move $a1, $s5			# put the currentCharacter in the second parameter
		jal print			# print the error message
		j exit
		
		# if there have been no errors, then print the success message
		checkSuccess:
			beq $s6, $zero, exit		# if it's zero the parsing has errors, so we are done
			la $a0, m4			# otherwise load the succes message in the first parameter
			move $a1, $s5			# load the currentCharacter in the second parameter
			jal print			# print the success message
		
		exit:
			li $v0, 10
			syscall				# terminate the program

	####################################################
	# print (message, currentCharacter)
	#
	# prints the string "At ", followed by the current character and finally the error message
	# all error messages already contain a '/n' so there is no need to print a new line
	#
	# Register usage:
	#	$a0 - first parameter, the address of the first character of the message
	#	$a1 - second parameter, the value of the current character, this is the character at which the error/success was found
	# 	$s0 - we will use $a0 for the syscalls, so we need to store the first param somewhere, since syscalls are still function calls
	#	    - we can't expect a temporary register to be the same before and after the syscall, therefore i have to use the saved register 
	####################################################
	print:
		sw $s0, 0($sp)		# store the initial value of $s0 so that we can overwrite it
		addi $sp, $sp, -4  	# decrement stack pointer

		move $s0, $a0		# hold the message in $t0

		li $v0, 4 		# print "At "
		la $a0, sm
		syscall

		li $v0, 1		# print the current character
		move $a0, $a1
		syscall

		li $v0, 4		# print the message
		move $a0, $s0
		syscall

		addi $sp, $sp, 4 	# increment stack pointer
		lw $s0, 0($sp)		# retrieve the original value of $s0

		jr $ra
