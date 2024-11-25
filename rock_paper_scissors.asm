.data
menu_prompt:       .asciiz "\nRock, Paper, Scissors Game\n1. Start Game\n2. View Rules\n3. Exit\nChoose an option: "
rules_text:        .asciiz "\nRules:\nRock beats Scissors\nScissors beat Paper\nPaper beats Rock\n"
enter_rounds:      .asciiz "\nEnter the number of rounds: "
invalid_option:    .asciiz "\nInvalid option. Try again.\n"
player_prompt:     .asciiz "\nChoose (1=Rock, 2=Paper, 3=Scissors): "
computer_choice:   .asciiz "\nComputer chose: "
round_winner:      .asciiz "\nRound Winner: "
game_over:         .asciiz "\nGame Over! Final Score:\n"
player_score_text: .asciiz "Your Score: "
computer_score_text:.asciiz "Computer Score: "
player_win:        .asciiz "You Win!"
computer_win:      .asciiz "Computer Wins!"
draw_text:         .asciiz "It's a Draw!"
new_line:          .asciiz "\n"

.text
.globl main

main:
    # Display the menu
    li $v0, 4               # Print string syscall
    la $a0, menu_prompt
    syscall

    # Get user menu choice
    li $v0, 5               # Read integer syscall
    syscall
    move $t0, $v0           # Store menu choice in $t0

    # Menu logic
    beq $t0, 1, start_game  # If 1, start game
    beq $t0, 2, view_rules  # If 2, show rules
    beq $t0, 3, exit_game   # If 3, exit
    j invalid_menu_option   # Else, invalid option

view_rules:

invalid_menu_option:        
                                    
start_game:
    
exit_game:
   
