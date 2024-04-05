#####################################################################
#
# CSCB58 Winter 2024 Assembly Final Project
# University of Toronto, Scarborough
#
# Student Name: Shatat Al Hamid
# Student Number: 1009035713
# UTorID: Alhamids
# Official email: shatat.alhamid@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestoneshave been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

# Constants
.data
buffer: .word 0:20000
result: .asciiz "END"

.eqv BASE_ADDRESS 0x10008000
.eqv END_ADDRESS 0x10008ffc
.eqv END_PIXEL 65536
.eqv WIDTH 4
.eqv PERROW 256

.text
li $t0, BASE_ADDRESS	# $t0 stores the base address for display
li $s0, 0x000000	# stores the black colour code
li $s1, 0xdb0c29	# stores the red colour code
li $s2, 0x71b415	# stores the green colour code (green)
li $s3, 0x4a72e9	# stores the blue colour code
li $s4, 0xffd028	# stores the yellow colour code

move $t4, $t0
li $t1, 0		# Counter

main:
	jal game
	
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened

	keypress_happened:
		lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
		beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
		j keypress_happened
	
	respond_to_a:
		li $v0, 4
		la $a0, result
		syscall
		j END

game:

	ColourBG:
		sw $s3, 0($t4)
		addi $t4, $t4, WIDTH
		addi $t1, $t1, WIDTH
		bge $t1, END_PIXEL, ColourStage
		j ColourBG

	ColourStage:
		li $t4, END_ADDRESS
		li $t1, END_PIXEL
		Loop:
			sw $s2, END_PIXEL($t4)
			subi $t4, $t4, WIDTH
			subi $t1, $t1, WIDTH
			bgt $t1, 9984, Loop
			jr $ra

END:
	li $v0, 10 # terminate the program gracefully
	syscall

