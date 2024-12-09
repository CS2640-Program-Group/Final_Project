# Elijah Rosal, Caleb Szeto, Ryan Hansen, Eric Chen, Cameron Bolanos
# 12-6-2024
# CS 2640
# Rock, Paper, Scissors
# All macros for RockPaperScissors.asm related to printing

.macro printing(%str) 	# Macro for printing a given String argument
	li $v0, 4	# Load syscall for print_string
	la $a0, %str	# load the address of the given string
	syscall		# Print String
.end_macro

.macro printInt(%reg)
	li $v0, 1	# Load Syscall for print_int
	move $a0, %reg	# Move the result into %reg for printing
	syscall		# Print the result
.end_macro

# Macro to print strings without havcing to declare them in data first
.macro printString(%str)
	li $v0, 4
	.data
	userString: .asciiz %str
	.text
	la $a0, userString
	syscall
.end_macro

# Print String from a register that has a string already loaded into it
.macro printTown(%reg)
	li $v0, 4
	move $a0, %reg
	syscall
.end_macro

# Macro to print out 'rock, 'paper', or 'scissors' for either the user or opponent
.macro choicePrinter(%reg)
	beq %reg, 0, print_rock
	beq %reg, 1, print_paper
	beq %reg, 2, print_scissors
	j end_print_choice
	
print_rock:
	printing(rock)
	j end_print_choice   # Jump to end after printing Rock

print_paper:
	printing(paper)
	j end_print_choice   # Jump to end after printing Paper

print_scissors:
	printing(scissors)
	j end_print_choice   # Jump to end after printing Scissors
	
end_print_choice:
.end_macro

# Spacer for cleanliness
.macro spacer(%num)
	li $v0, 4
	li $s7, 0
loop:
	beq $s7, %num, leave
	add $s7, $s7, 1
	la $a0, newLine
	syscall
	j loop
leave:
.end_macro

.macro round_printer(%def)
	beqz %def, Round_16
	beq %def, 1, Quarter
	beq %def, 2, Semi
	beq %def, 3, Finals
Round_16:
	printString("\n------------ ROUND OF 16 ------------\n")
	j end
Quarter:
	printString("\n------------ QUARTER FINALS ------------\n")
	j end
Semi:
	printString("\n------------ SEMI-FINALS ------------\n")
	j end
Finals:
	printString("\n------------ FINALS ------------\n")
	j end
end:
.end_macro
