# Elijah Rosal, Caleb Szeto, Ryan Hansen, Eric Chen, Cameron Bolanos
# 12-6-2024
# CS 2640
# Rock, Paper, Scissors
# All macros for RockPaperScissors.asm related to reading inputs

.macro readChar
	li $v0, 12	# Load syscall for read_char
	syscall		# Read the user inputted char
.end_macro

.macro readInt(%reg)
	li $v0, 5	# Load syscall for read_int
	syscall		# Read the integer
	move %reg, $v0	# Store the input in %reg
.end_macro

# Macro to store an inputted string in a buffer argument
.macro readName(%buffer, %size)
	li $v0, 8        # Syscall code for reading a string
	la $a0, %buffer  # Load address of buffer to $a0
	li $a1, %size    # Load size of buffer to $a1
	syscall          # Perform the syscall
	
	# Remove the newline character
        la $t5, %buffer			# Load address of the string
find_newline:
        lb $t6, 0($t5)			# Load a byte from the string
        beqz $t6, end_remove		# If null terminator, end loop
        li $t7, 0x0A			# ASCII code for newline
        beq $t6, $t7, replace_null	# If newline, replace with null
        addi $t5, $t5, 1			# Move to the next character
        j find_newline			# Repeat loop

replace_null:
        sb $zero, 0($t5)                    # Replace newline with null terminator
end_remove:
.end_macro

