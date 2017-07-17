#####Reverse Fibonacci Sequence less that 1000#####
	
	.data
greeting:   .asciiz "Fibonacci series ... numbers < 1000\nReverse order\n"
one:	    .asciiz "\n1"
zero:	    .asciiz "\n0"
newLine:    .asciiz "\n"

.globl main		
.text				

main:		
li $v0  , 4		
la $a0 , greeting	#print the initial message to the console
syscall
li $v0 , 0              #resetting this register for later use
li $a0 , 0              #resetting this register for later use
			
addi $a0 , $a0 , 987	#$a0 is the maximum fibonacci number
addi $a1 , $a1 , 17	#we want to display the next 17 fibonacci numbers, store 17 in $a0

sw $ra , 0($sp)		#save the return address
jal fibonacci_reverse	#jump and link --> to recursive fibonacci function
lw $ra , 0($sp)		#load the return address back from the stack
j end			#jump to termination
							
fibonacci_reverse:
move $a2,$a0		#move 987 to $a2
move $a3,$a1		#move 17 to $a3
li $a0 , 1		#load the first fibonacci number (1) in to $a0
li $a1 , 1		#load the second fibonacci number (1) in to $a1

sw $a0 , 0($sp)		#saving all current numbers stored to the stack
sw $a1 , 4($sp)		
sw $a2 , 8($sp)		
sw $a3 , 12($sp)		
sw $a0 , 16($sp)		
sw $a1 , 20($sp)		
sw $ra , 28($sp)
		
jal fibCheck		#call the check fibonacci number function
	
lw $ra , 28($sp)	#load the return address back from the stack
lw $t0 , 24($sp)	#load the value from fibCheck
lw $a1 , 20($sp)	#restore the rest of the parameters
lw $a3 , 16($sp)
lw $a3 , 12($sp)
lw $a2 , 8($sp)	
lw $a1 , 4($sp)		
lw $a0 , 0($sp)		

li $v0 , 4
la $a0 , one		#print the last digit for the sequence (1)
syscall
jr $ra			#return to caller

fibCheck:		
lw $a0 , 0($sp)		#restore all arguments from the stack 
lw $a1 , 4($sp)		
lw $a2 , 8($sp)		
lw $a3 , 12($sp)				
beq $a1 , $a2 , printNum#go to function store the current fibonacci number 


add $t1 , $a0 , $a1	#find the next fibonacci number
addi $sp , $sp , -32	#creating room on the stack for all parameters below and saving
sw $a1 , 0($sp)		
sw $t1 , 4($sp)		
sw $a2 , 8($sp)		
sw $a3 , 12($sp)		
sw $a0 , 16($sp)		
sw $a1 , 20($sp)		
sw $ra , 28($sp)		
jal fibCheck		#recursion occurs here, jump back to fibCheck
lw $ra , 28($sp)	#load the return address and load all parameters
lw $t0 , 24($sp)	#return value is stored here
lw $a1 , 20($sp)		
lw $a0 , 16($sp)		
lw $a3 , 12($sp)		
lw $a2 , 8($sp)		
lw $t1 , 4($sp)		
lw $a1 , 0($sp)		
addi $sp , $sp,32 	
bgez $t3,printNum 	#if the number is greater than or equal to 0, print to the console

printNum:
addi $sp , $sp , -8	#making room on stack for number to print
sw $a0 , 0($sp)		#save parameters to the stack
sw $v0 , 4($sp)	
li $v0 , 4	
la $a0 , newLine	#print a new line
syscall
lw $v0 , 4($sp)		#restore parameters for printing
lw $a0 , 0($sp)		
addi $sp , $sp , 8 
			
addi $sp , $sp , -8	#making room on stack for number to print
sw $a0 , 0($sp)	
sw $v0 , 4($sp)	
li $v0 , 1		#now need to print the integer, load 1 in to $v0
move $a0 , $a1		#move the fibonacci number in to the print parameter $a0
syscall			
lw $v0 , 4($sp)		#restore parameters 
lw $a0 , 0($sp)		
addi $sp , $sp , 8

j saveReturn
	
saveReturn:
sw $v0 , 24($sp)  	#store return value on the stack
jr $ra			
			
end:		     
li $v0 , 4
la $a0 , zero		#end of the program, print 0 to the console
syscall
li $v0 , 10		#terminate Program
syscall
