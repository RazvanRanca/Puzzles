#########################################################
# Reads a string and outputs the reverse of that string
# Both input and output strings end with a newline
# Strings have a maximum of 40 characters(+newline)
#########################################################
	.data

inputString:
	.space 50 	# set aside 50 bytes to store the input string

stack:
	.space 50 	# set aside another 50 bytes to use as the stack

	.globl main

	.text
main:
	addi $s0, $zero, 10 		# in $s0 store the newline character(ASCII code of 10)
	
	la $s1, stack			# $s1 will be the stack pointer
	move $s2, $s1			# $s2 just holds the location where the stack starts, it won't change	

	la $s3, inputString		# $s3 holds the address where we will put the read input string
					# in general $s3 will point to the character we are currently considering(the current character)
	
	# read the string and store it in the reserved space, $s3 will point to the first character
	li $v0, 8
	move $a0, $s3
	syscall				# read it

	lb $s4, 0($s3)			# $s4 will hold the value of the current character

	bne $s3, $s0, push		# if the first character is '\n' we have nothing to reverse, so finish
	j finish
	
	# add current character to stack, if there are characters left repeat
	push:
		
		sb $s4, 0($s1) 		# add the current character to the stack
		addi $s1, $s1, 1 	# increment the stack pointer

		addi $s3, $s3, 1	# get the address of the next character in the string
		lb $s4, 0($s3)		# load the value of the new current character

		bne $s4, $s0, push	# if the current character is '\n' we have added all characters to the stack, so start popping

	# get current character in stack, print it, if there are characters left repeat
	pop:
		addi $s1, $s1, -1	# decrement stack counter, pop printed element from stack

		lb $a0, 0($s1) 		# load the current stack element
		li $v0, 11
		syscall 		# print it

		bne $s1, $s2, pop	# if the stack pointer is equal to the start of the stack we've printed every element and can finish
						
	# print a newline and end the program	
	finish:
		move $a0, $s0		# put the newline in $a0
		li $v0, 11
		syscall			# print the newline character

		li $v0, 10
		syscall			# end the program
	
