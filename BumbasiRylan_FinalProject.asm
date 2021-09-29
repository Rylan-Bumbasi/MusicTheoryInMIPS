######################################

# Name: Rylan Bumbasi
# RedID: 822563190
# Date: 3/7/2021
# COMPE 271 Personal Project

#######################################
.data

#Arrays
rootNotes: .word 60 61 62 63 64 65 66 67 68 69 70 71 72	# Create an Array Contaning all the pitches from C4 to B4



#Strings for the the main program
myIntro: .asciiz "Welcome to MIDI Madness! By Rylan Bumbasi\n\n"
menuOptions: .asciiz "Enter 1 to Play Scales\n\nEnter 2 to take Pitch Recognition Test.\n\nEnter 3 for Chord Madness.\n\n"
requestInput: .asciiz "Please enter a number: "
displayError: .asciiz  "*** INVALID INPUT ***, try again.\n\n"
rootNoteOptions: .asciiz "C4 = 0\nC# = 1\nD = 2\nD# = 3\nE = 4\nF = 5\nF# = 6\nG = 7\nG# = 8\nA = 9\nA# = 10\nB = 11\n"
askRestart: .asciiz "\nWould your like to return to the main menu?\n\n1 = Yes.\n2 = No.\n\n"

halfCount: .word 500
wholeCount: .word 1000

#Chord Madness Data Section
chordMadnessIntro: .asciiz "In this section of the program you will choose a root note and a chord stucture.\nThe MIDI player will then play you the corelating chord.\n\nPlease choose a root note.\n"
chordStructureOptions: .asciiz "\nPlease select a chord structure.\n\nMajor Chord = 1\nMinor Chord = 2\nMajor 7th Chord = 3\nMinor 7th Chord = 4\nDominant 7th Chord = 5\n"

#playingScales Data Section
playScalesIntro: .asciiz "In this section of the program You will select a root note and choose to play either a major or minor scale.\n\nPlease select a root note.\n\n"
scaleOptions: .asciiz "\nPlease select a Scale.\n1 = Major Scale\n2 = Minor Scale\n"

#pitchRecognitionTest Data Section
requestGuess: .asciiz "Which number note in the scale was off pitch?\n\n"
correctGuess: .asciiz "\nCongratulations, you guessed correctly :D\n"
incorrectGuess: .asciiz "\nSorry, you got it wrong :(\n"
pitchRecognitionTestIntro: .asciiz "In this section of the program you will first choose a root note.\nAfter a root note is chosen, the Major Scale for that Root note will be played.\n\nThe Catch is that one of the notes in the scale will be played off key and your goal is to identify which key is off pitch\n\n"

.text

	# Display intro Message
	main:	
		li $v0, 4
		la $a0, myIntro
		syscall

		# Display Menu Options
		li $v0, 4
		la $a0, menuOptions
		syscall
		
		j getMenuInput
###############################################################################################################################
		# Below are functions that can be universally used by every section in my program
	displayRootNotes:
		
		addi $sp,$sp,-4		# Allocate one spot for the stack
		sw $ra, 0($sp)		# push $ra onto the stack
			
		li $v0, 4		# Display the Root Note Options
		la $a0, rootNoteOptions
		syscall
		
		jal requestUserInput
		
		
		lw $ra, 0($sp)		# restore value of $ra
		addi $sp, $sp, 4	# Decallocate the space createad for the stack
		jr $ra
		
#########################################################################################################################################
	# The nature of the getRootNote function written below is based off an an algorithim written by "The Simple Engineer" on YouTube
	# A link to his original code will be included in my Final Lab Report
#########################################################################################################################################

	getRootNote:	
		bgt $t4, $t7, exitGetRootNote	# The loop will break at the index of the array that the user requested
		sll $t5, $t4, 2	# 4 * I
		addu $t5, $t5, $s1 # rootNotes[I]
		lw $t6, 0($t5)	   # $t6 = rootNotes[I]
		addi $t4, $t4, 1   # Iterator + 1
		j getRootNote
		

	exitGetRootNote:
		add $t1, $zero, $t6	#t1 hold's the pitch of the root note
		lw $t3, halfCount($zero) # t3 = halfCount
		addi $t7, $zero, 0
		jr $ra

	getUserInput:
		# Get users input for menu option
		li $v0, 5
		syscall
		
		# Store result in t7
		move $t7, $v0
		jr $ra
	
	requestUserInput:
		li $v0, 4
		la $a0, requestInput
		syscall
		jr $ra

#########################################################################################################################################
	# The nature of the generateRandomInt function written below is based off an an algorithim written by "Ayman Jajja" on YouTube
	# A link to his original code will be included in my Final Lab Report
#########################################################################################################################################	
	generateRandomInt:
		# Generate a random number from 0 to 9
		addi $a1, $zero, 10
		addi $v0, $zero, 42
		syscall
		
		# If the Number generated is not 3,4,5 or 6, then regenerate the number
		beq $a0, 3, grabRandomInt
		beq $a0, 4, grabRandomInt
		beq $a0, 5, grabRandomInt
		beq $a0, 6, grabRandomInt
		j generateRandomInt

	
	grabRandomInt:
		# Take the randomly generated number and send it to register $t0
		add $t0, $zero, $a0
		jr $ra

	requestUserGuess:
		# Prompt the user to enter a guess
		li $v0, 4
		la $a0, requestGuess
		syscall
		jr $ra
###############################################################################################################################################################		
		
		# Display error message in user inputs a number that isn't 1,2,3
	errorMessage:
		li $v0, 4
		la $a0, displayError
		syscall
	

	getMenuInput: 	# Ask for user Input
		li $v0, 4
		la $a0, requestInput
		syscall

		# Get users input for menu option
		li $v0, 5
		syscall

		# Store result in t7
		move $t7, $v0

		beq $t7, 1, playScales # If the user inputs 1, program will jump to PlayScales
		beq $t7, 2, pitchRecognitionTest # If the user inputs 2, the program will jump to pitchRecognitionTest
		beq $t7, 3, chordMadness 	# If the user inputs 3, the program will jump to chordMadness
		j errorMessage

		


playScales:	
		la $s1, rootNotes	# Load array into register $s1
			
		# Display play Scales Intro Message
		li $v0, 4
		la $a0, playScalesIntro
		syscall
			
		jal displayRootNotes # Jump and link to the displayRootNotes function
		jal getUserInput
		jal getRootNote # Jump and link to the displayRootNotes function

		# Display Scale options
		li $v0, 4
		la $a0, scaleOptions
		syscall
			
		jal getUserInput
		
		# Play a major or minor scale depending on the user input
		beq $t7, 1, majorScale	
		beq $t7, 2, minorScale
		j playScalesEnd


       


        	
	majorScale:     
		# Play the root note of the scale
		li $v0, 31
        	la $a0, ($t1)
       		la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2
        
        	# Play the second of the Scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
		syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 4 #t2 = t1 + 4
        
        	# Play the 3rd of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 5 #t2 = t1 + 5 
        
        	# Play the 4th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 7 #t2 = t1 + 7 
        
        	# Play the 5th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 9 #t2 = t1 + 9 
        	# Play the 6th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 11 # t2 = t1 + 11 
        	# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t2 = t1 + 12
        	# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	
		j playScalesEnd
     
         	
	minorScale:
		# Play Root Note of Scale
		li $v0, 31
       		la $a0, ($t1)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2 
        
        	# Play the second of the Scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 3 #t2 = t1 + 3 
        
       		# Play the 3rd of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 5 #t2 = t1 + 5 
        
        	# Play the 4th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
       		li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 7 #t2 = t1 + 7 
        
        	# Play the 5th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 8 #t2 = t1 + 8 
        	
		# Play the 6th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 10 #t2 = t1 + 10 
        	
		# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t1 = t1 + 12
        	
		# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
      		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
     
	playScalesEnd:	
		j end


pitchRecognitionTest:
		# Display Pitch Recognition intro
		li $v0, 4
		la $a0, pitchRecognitionTestIntro
		syscall
		
		la $s1, rootNotes	# Load array into register $s1
		
		jal displayRootNotes # Jump and link to the displayRootNotes function
		jal getUserInput
		jal getRootNote # Jump and link to the displayRootNotes function
		jal generateRandomInt
	
		lw $t3, wholeCount($zero) # t3 = wholeCount
		
		# Depending on the random number generated, play a certain scale that is off pitch
		beq $t0, 3, majorScaleOffPitch3
		beq $t0, 4, majorScaleOffPitch4
		beq $t0, 5, majorScaleOffPitch5
		beq $t0, 6, majorScaleOffPitch6
		

	majorScaleOffPitch3:     
		li $v0, 31
        	la $a0, ($t1)	# Play Root Note of Scale
       		la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2
        
        	# Play the second of the Scale off pitch, (Semitone lower)
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
		syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 3 #t2 = t1 + 3
        
        	# Play the 3rd of the scale off pitch (semitone down)
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 5 #t2 = t1 + 5 
        
        	# Play the 4th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 7 #t2 = t1 + 7 
        
        	# Play the 5th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 9 #t2 = t1 + 9 
        	# Play the 6th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 11 # t2 = t1 + 11 
        	# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t2 = t1 + 12
        	# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	add $t2, $zero, $t1 # reset t2 back to the root note
		j guessNote

	majorScaleOffPitch4:     
		li $v0, 31
        	la $a0, ($t1)
       		la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2
        
        	# Play the second of the Scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
		syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 4 #t2 = t1 + 4
        
        	# Play the 3rd of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 6 #t2 = t1 + 6 
        
        	# Play the 4th of the scale off pitch (semitone higher)
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 7 #t2 = t1 + 7 
        
        	# Play the 5th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 9 #t2 = t1 + 9 
        	# Play the 6th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 11 # t2 = t1 + 11 
        	# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t2 = t1 + 12
        	# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	add $t2, $zero, $t1 # reset t2 back to the root note
		j guessNote

	majorScaleOffPitch5:     
		li $v0, 31
        	la $a0, ($t1)
       		la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2
        
        	# Play the second of the Scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
		syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 4 #t2 = t1 + 4
        
        	# Play the 3rd of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 5 #t2 = t1 + 5 
        
        	# Play the 4th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 6 #t2 = t1 + 6 
        
        	# Play the 5th of the scale off pitch (semi tone down)
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 9 #t2 = t1 + 9 
        	# Play the 6th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 11 # t2 = t1 + 11 
        	# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t2 = t1 + 12
        	# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	add $t2, $zero, $t1 # reset t2 back to the root note
		j guessNote

	majorScaleOffPitch6:     
		li $v0, 31
        	la $a0, ($t1)
       		la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 2 #t2 = t1 + 2
        
        	# Play the second of the Scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
		syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 4 #t2 = t1 + 4
        
        	# Play the 3rd of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 5 #t2 = t1 + 5 
        
        	# Play the 4th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 7 #t2 = t1 + 7 
        
        	# Play the 5th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
      
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        
        	addi $t2, $t1, 10 #t2 = t1 + 10 
        	# Play the 6th of the scale off pitch (semitone highter)
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
       		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
       
        	addi $t2, $t1, 11 # t2 = t1 + 11 
        	# Play the 7th of the scale
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	addi $t2, $t1, 12 #t2 = t1 + 12
        	# Play the tonic
        	li $v0, 31
        	la $a0, ($t2)
        	la $a1, ($t3)
        	la $a2, 0
        	la $a3, 127
        	syscall
        
        	#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
        
        	add $t2, $zero, $t1 # reset t2 back to the root note
		j guessNote


	guessNote:
		jal requestUserGuess # Prompt the user to input a guess
		jal requestUserInput # Ask the user for their input
		jal getUserInput     # Get user input
		
		bne $t7, $t0, incorrect # If user guesses incorrectly, display a message
		li $v0, 4
		la $a0, correctGuess	# If a user guesses correctly, display a message
		syscall
		j pitchRecognitionTestEnd
		
	incorrect:
		# Display a message that user was incorrect.
		li $v0, 4
		la $a0, incorrectGuess
		syscall
		j pitchRecognitionTestEnd

	pitchRecognitionTestEnd:
		j end


chordMadness:

# Channel 1 contains piano sound
	initilizeChannelSounds:	
		li $v0, 38
		la $a0, 1
		la $a1, 0
		syscall

		# Channel 2 contains piano sound
		li $v0, 38
		la $a0, 2
		la $a1, 0
		syscall

		# Channel 3 contains piano sound
		li $v0, 38
		la $a0, 3
		la $a1, 0
		syscall

		# Channel 4 contains piano sound
		li $v0, 38
		la $a0, 4
		la $a1, 0
		syscall

		# Channel 5 contains piano sound
		li $v0, 38
		la $a0, 5
		la $a1, 0
		syscall

		la $s1, rootNotes	# Load array into register $s1
			
		# Display chord Madness Intro Message
		li $v0, 4
		la $a0, chordMadnessIntro
		syscall
			
		jal displayRootNotes # Jump and link to the displayRootNotes function
		jal getUserInput
		jal getRootNote # Jump and link to the displayRootNotes function
	





	getChordStructure:	
		# Display Chord Structure Options
		li $v0, 4
		la $a0, chordStructureOptions
		syscall
			
		# Request input from user
		li $v0, 4
		la $a0, requestInput
		syscall

		li $v0, 5 # Get User's input for Chord Sturcture
		syscall
		move $t7, $v0 # Store user's input into $t7
		

		beq $t7, 1, brokenMajorChord	
		beq $t7, 2, brokenMinorChord
		beq $t7, 3, brokenMajor7thChord
		beq $t7, 4, brokenMinor7thChord
		beq $t7, 5, brokenMinor7thChord
		j end

			# Play each note in the chord individually first
	brokenMajorChord: 	
		li $v0, 31
		la $a0, ($t1)	# Play the Root note of the Chord
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		
		li $v0, 31
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
			
		j majorChord


	majorChord:	
		li $v0, 37 
		la, $a0, ($t1) # Play the Root Note of the scale
		la $a1, ($t3)  #Play the note for the length of the value stored in $t3
		la $a2, 1
		la $a3, 127
		syscall

		# Play the 3rd of the scale
		li $v0, 37
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)	#Play the note for the length of the value stored in $t3
		la $a2, 2
		la $a3, 127
		syscall
		
		# Play the 5th of the scale
		li $v0, 37
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall
		j end

	# Play each note in the chord individually first
	brokenMinorChord:
		li $v0, 31
		la $a0, ($t1)	# Play the Root note of the Chord
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		
		li $v0, 31
		addi $t2, $t1, 3 # Increment the root note by 3 semitones to reach the flat 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the flat 3rd of the scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
			
		j minorChord

	minorChord:	
		li $v0, 37 
		la, $a0, ($t1) # Play the Root Note of the scale
		la $a1, ($t3)  #Play the note for the length of the value stored in $t3
		la $a2, 1
		la $a3, 127
		syscall

		# Play the 3rd of the scale
		li $v0, 37
		addi $t2, $t1, 3 # Increment the root note by 3 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)	#Play the note for the length of the value stored in $t3
		la $a2, 2
		la $a3, 127
		syscall
		
		# Play the 5th of the scale
		li $v0, 37
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		j end


	brokenMajor7thChord:	
		li $v0, 31
		la $a0, ($t1)	# Play the Root note of the Chord
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		
		li $v0, 31
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 11 # Increment the root note by 11 semitones to reach the 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
			
		j major7thChord

	major7thChord:	
		li $v0, 37 
		la, $a0, ($t1) # Play the Root Note of the scale
		la $a1, ($t3)  #Play the note for the length of the value stored in $t3
		la $a2, 1
		la $a3, 127
		syscall

		# Play the 3rd of the scale
		li $v0, 37
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)	#Play the note for the length of the value stored in $t3
		la $a2, 2
		la $a3, 127
		syscall
		
		# Play the 5th of the scale
		li $v0, 37
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall

		# Play the 7th of the scale
		li $v0, 37
		addi $t2, $t1, 11 # Increment the root note by 11 semitones to reach the 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 7th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall
		j end

	brokenMinor7thChord:	
		li $v0, 31
		la $a0, ($t1)	# Play the Root note of the Chord
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		
		li $v0, 31
		addi $t2, $t1, 3 # Increment the root note by 3 semitones to reach the flat 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the flat 3rd of the scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 10 # Increment the root note by 10 semitones to reach the flat 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the flat 7th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
			
		j minor7thChord

	minor7thChord:	
		li $v0, 37 
		la, $a0, ($t1) # Play the Root Note of the scale
		la $a1, ($t3)  #Play the note for the length of the value stored in $t3
		la $a2, 1
		la $a3, 127
		syscall

		# Play the flat 3rd of the scale
		li $v0, 37
		addi $t2, $t1, 3 # Increment the root note by 3 semitones to reach the flat 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the flat 3rd of the scale
		la $a1, ($t3)	#Play the note for the length of the value stored in $t3
		la $a2, 2
		la $a3, 127
		syscall
		
		# Play the 5th of the scale
		li $v0, 37
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall

		# Play the flat 7th of the scale
		li $v0, 37
		addi $t2, $t1, 10 # Increment the root note by 10 semitones to reach the flat 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 7th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall
		j end

	brokenDominant7thChord:	
		li $v0, 31
		la $a0, ($t1)	# Play the Root note of the Chord
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
		
		li $v0, 31
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall

		li $v0, 31
		addi $t2, $t1, 10 # Increment the root note by 11 semitones to reach the flat 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)
		la $a2, 0	
		la $a3, 127
		syscall

		#sleep
        	li $v0, 32
        	la $a0, ($t3)
        	syscall
			
		j dominant7thChord

	dominant7thChord:	
		li $v0, 37 
		la, $a0, ($t1) # Play the Root Note of the scale
		la $a1, ($t3)  #Play the note for the length of the value stored in $t3
		la $a2, 1
		la $a3, 127
		syscall

		# Play the 3rd of the scale
		li $v0, 37
		addi $t2, $t1, 4 # Increment the root note by 4 semitones to reach the 3rd of the scale and set that note to $t2
		la, $a0, ($t2)	# Play the 3rd of the scale
		la $a1, ($t3)	#Play the note for the length of the value stored in $t3
		la $a2, 2
		la $a3, 127
		syscall
		
		# Play the 5th of the scale
		li $v0, 37
		addi $t2, $t1, 7 # Increment the root note by 7 semitones to reach the 5th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the 5th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall

		# Play the 7th of the scale
		li $v0, 37
		addi $t2, $t1, 10 # Increment the root note by 10 semitones to reach the flat 7th of the scale and set that note to $t2
		la, $a0, ($t2)   # Play the flat 7th of the Scale
		la $a1, ($t3)	#  Play the note for the length of the value stored in $t3
		la $a2, 3
		la $a3, 127
		syscall
		j end

end:
		# Ask the user if they would like to restart.
		li $v0, 4
		la $a0, askRestart
		syscall
		
		# Get User Input
		jal requestUserInput
		jal getUserInput


		beq $t7, 1, main # If user inputs 1, restart
		beq $t7, 2, endOfProgram# if the user inputs 2, end program
	
		
		

endOfProgram:

		








