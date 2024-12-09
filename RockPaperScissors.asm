# Elijah Rosal, Caleb Szeto, Ryan Hansen, Eric Chen, Cameron Bolanos
# 12-6-2024
# CS 2640
# Rock, Paper, Scissors

.include "RPSprint.asm"
.include "RPSread.asm"

# Random Integer Generator
.macro randomInt(%r)
	li $a0, 100
	li $a1, 100		# Here you set $a1 to the max bound.
    	li $v0, 42		# generates the random number.
    	syscall
    	move %r, $a0		# Store random int into $t0
.end_macro

.macro oppLoader(%name, %w1, %w2)
	la $s1, %name		# Load their name
	# Load their attack weights
	li $s2, %w1
	li $s3, %w2
.end_macro

# Macro to find what the opponent chose
.macro BattleSim(%w1, %w2)

	# %w1 -> Weight of Rock (e.g., 90)
	# %w2 -> Weight of Paper (e.g., 5)
	# wieght of scissors is whatever is left
	
	# Generate a random number between 0 and 100
	randomInt($t0)         # Generate random number in $t0 (0-100)
	printInt($t0)
	# Check if the random number falls into the Rock range
	bge $t0, %w1, paper_or_scissors
	# If $t0 is less than w1, Rock is selected
	li $t2, 0              # Set $t1 to represent Rock
	j end_battle

paper_or_scissors:
	# Check if the random number falls into the Paper range (w1 + w2)
	add $t8, %w1, %w2
	bge $t0, $t8, scissors_selected
	# If $t0 is less than w1 + w2, Paper is selected
	li $t2, 1              # Set $t1 to represent Paper
	j end_battle

scissors_selected:
	# If it's greater than or equal to w1 + w2, Scissors is selected
	li $t2, 2              # Set $t1 to represent Scissors

end_battle:
	# $t1 now contains the selected option
	# 0 -> Rock, 1 -> Paper, 2 -> Scissors
	# You can proceed with the next steps in your battle simulation
.end_macro

.macro dialogue
	# Reuses the random int to choose the correct branch
	bgt $t0, 75, dw
	bgt $t0, 50, bl
	bgt $t0, 25, ed
	bge $t0, 0, ran
	
dw:
	printString("\nDwayne \"The Rock\" Johnson: Can you smell-l-l-l-l-l what the \"ROCK\" is COOKING?!\n")
	j end_d
bl:	printString("\nPaper Bill: I'm just a bill. Yes, I'm only a bill.\n")
	j end_d
ed:	printString("\nEdward Scissorhands: I'm not finished.\n")
	j end_d
ran:	printString("\nRandy Rand: It pays to have a grandfather in the Rock, Paper Scissors business, isn't it?\n")
end_d:
.end_macro

# Macro to print out "Rock, Paper Scissors!?" for suspenseful delay
.macro delay(%count)
	# Delay loop counter
	move $t5, %count       # Load delay loop counter into $t5

	# Print "Rock"
	printString("Rock... ")
    
	# Delay loop after "Rock"
	delay_loop_rock:
	subi $t5, $t5, 1			# Decrement the delay counter
	bnez $t5, delay_loop_rock	# Busy-wait until $t5 reaches 0

	# Print "Paper"
	printString("Paper... ")
    
	# Delay loop after "Paper"
	move $t5, %count			# Reload the delay counter
delay_loop_paper:
	subi $t5, $t5, 1			# Decrement the delay counter
	bnez $t5, delay_loop_paper	# Busy-wait until $t5 reaches 0

	# Print "Scissors"
	printString("Scissors!\n")

	# Final delay loop after "Scissors"
	move $t5, %count			# Reload the delay counter
delay_loop_scissors:
	subi $t5, $t5, 1			# Decrement the delay counter
	bnez $t5, delay_loop_scissors	# Busy-wait until $t5 reaches 0
.end_macro

.data
welcome_msg: .asciiz "Welcome to Rock, Paper, Scissors: The Text Based Adventure Demo\n		-Press any key to start-\n"
name_prompt: .asciiz "Professor Rand: Hello young fellow! I'm Professor Rand, \n		and I'll be guiding you in your intial decisions for your journey.\n		Before we get started, what is your name?\nEnter your name: "
newLine: .asciiz "\n"
name: .space 20
rock_t: .asciiz "Rockville"
paper_t: .asciiz "New Paper City"
scissors_t: .asciiz "Scissor Suburbs"
opp1: .asciiz "Dwayne \"The Rock\" Johnson"
opp2: .asciiz "Paper Bill"
opp3: .asciiz "Edward Scissorhands"
opp4: .asciiz "Randy Rand"
rock: .asciiz "Rock\n"
paper: .asciiz "Paper\n"
scissors: .asciiz "Scissors\n"
dot_str: .asciiz ".\n"
.text

main:
	li $s0, 0		# Intialise highest win streak record
	printing(welcome_msg)
	readChar
	spacer(5)
game_select:
	printString("Select your gamemode\n	1) Story Mode\n	2) Endless\nEnter the corresponding number: ")
	readInt($t0)
	beq $t0, 1, Story
	beq $t0, 2, Endless
	# If invalid input, loop again
	printString("Invalid choice\n")
	j game_select
Story:
	printing(name_prompt)
	readName(name, 20)
	spacer(5)

	printString("Professor Rand: Hello ")
	printing(name)
	printString(", and welcome to the world run by the simple game of Rock, Paper, Scissors!\n		One last thing, what town do you represent?\n\n		1) Rockville\n		2) New Paper City\n		3) Scissor Suburbs\nEnter the corresponding number to choose: ")
town:
	readInt($t0)
	beq $t0, 1, Rockville
	beq $t0, 2, Paper_City
	beq $t0, 3, Scissor_Suburbs
	# If invalid input, loop again
	printString("Invalid choice\n")
	j town
Rockville:
	la $t3, rock_t
	j Tournament
Paper_City:
	la $t3, paper_t
	j Tournament
Scissor_Suburbs:
	la $t3, scissors_t
	j Tournament
Tournament:
	spacer(5)
	printString("Professor Rand: Oh so you're representing ")
	printTown($t3)
	printString(" eh, well then I'll be rooting for you\n		as you compete in our local tournament!\n		-Press any key to continue-\n")
	readChar
	spacer(5)
	printString("Announcer: Welcome to the local tournament of Rock, Paper, Scissors held in lovely ")
	printTown($t3)
	printString(".\n           The turnout is pretty good considering the mere population of 20. Of course there are some outsiders here,\n           helping contribute to our prize pool.\n		-Press any key to continue-\n")
	readChar
	j Done	
Endless:
	li $s5, 1 	# Intialise round counter
	li $s6, 0	# Intialise win streak
Opponent_Selector:
	spacer(3)
	li $s5, 1 	# Intialise round counter
	randomInt($t0)
	bgt $t0, 75, Dwayne
	bgt $t0, 50, Bill
	bgt $t0, 25, Edward
	bge $t0, 0, Randy
	
Dwayne:
	oppLoader(opp1, 90, 5)
	j Selected
Bill:
	oppLoader(opp2, 30, 60)
	j Selected
Edward:
	oppLoader(opp3, 10, 20)
	j Selected
Randy:
	oppLoader(opp4, 33, 33)
	j Selected
Selected:
	printString("Your Opponent is: ")
	printTown($s1)
	dialogue			# Have some dialogue the opponent says before your battle
	
Fight:
	li $t6, 1000000 	# Initialsie delay counter
	# Prompt the user for input
	printString("\n------------ROUND ")
	printInt($s5)
	printString("------------\n")
	printString("What will you choose? Rock (1), Paper (2), or Scissors (3): ")

getUserChoice: # Read the user input
	readInt($t0)

	# Check the character and store the result in $t0
	# Default to an invalid input if it's not one of the expected characters

	# Check if input is 1 for Rock
	beq $t0, 1, rock_choice

	# Check if input is 2 for Paper
	beq $t0, 2, paper_choice

	# Check if input is 3 for Scissors
	beq $t0, 3, scissors_choice

	# If invalid input, loop again
	printString("Invalid choice. Type the coreresponding integer: Rock (1), Paper (2), or Scissors (3): ")
	j getUserChoice

rock_choice:
	li $t1, 0		# Set $t1 to 0 for Rock
	j result

paper_choice:
	li $t1, 1		# Set $t1 to 1 for Paper
	j result

scissors_choice:
	li $t1, 2		# Set $t1 to 2 for Scissors
	j result
result:
	BattleSim($s2, $s3)
	printString("\nYou chose: ")
	choicePrinter($t1)
	bge $s5, 20, res		# Delay will be 0 at this point
	mul $t7, $s5, 50000	# Reduce delay by how many rounds have passed
	sub $t6, $t6, $t7
	delay($t6)
res:
	printTown($s1)
	printString( " threw out: ")
	choicePrinter($t2)
	li $t5, 1000000			# Load the delay counter
delay_loop:
	subi $t5, $t5, 1			# Decrement the delay counter
	bnez $t5, delay_loop		# Busy-wait until $t5 reaches 0

	# Branches based on what the user chose to find out who won
	beq $t1, $t2, draw
	beq $t1, 0, rock_check		
	beq $t1, 1, paper_check
	beq $t1, 2, scissors_check
rock_check:
	beq $t2, 1, lose		# Opponent chose paper, you lose
	j win

paper_check:
	beq $t2, 2, lose		# Opponent chose paper, you lose
	j win
	
scissors_check:
	beq $t2, 0, lose		# Opponent chose paper, you lose
	j win
draw:
	addi, $s5, $s5, 1
	printString("It's a draw! Here comes round ")
	printInt($s5)
	j Fight
lose:
	bgt $s6, $s0, saveHigh  # If $s6 > $s0, branch to save new high into $s0
	j Try_again		# Jump to the end if not

saveHigh:
	move $s0, $s6
		
Try_again:
	printString("		YOU LOSE!!!!!\n	You ended with a win streak of ")
	printInt($s6)
	printString(".\n		Your highest win streak is ")
	printInt($s0)
	printString("\n	1) Try Again?\n	2) Quit\n")
	
getInt:
	li $t4, 2		# Set Flag
	readInt($t0)
	beq $t0, 1, Endless
	beq $t0, 2, Done
	# If invalid input, loop again
	printString("Invalid choice. Try again.\n")
	j getInt
	
win:
	addi $s6, $s6, 1
	printString("			YOU WON on Round ")
	printInt($s5)
	printString("\n		You currently have a win streak of ")
	printInt($s6)
	printString("\n			Would You like to Continue?\n	1) Yes\n	2) No\n")
	
choices:
	readInt($t0)
	beq $t0, 1, Opponent_Selector
	beq $t0, 2, Done
	# If invalid input, loop again
	printString("Invalid choice. Try again.\n")
	j choices

Done:	# Exit Code
	li $v0, 10
	syscall