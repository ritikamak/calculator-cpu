#Ritika Maknoor
.text
	
state0Start: 
	add $t9, $zero, $zero	# input
	add $t4, $zero, $t9	# temp holder of input
	add $t8, $zero, $zero	# display
	add $t2, $zero, $zero	# temp value for operator
	add $s4, $zero, $zero	# temp value for operator
	addi $t6, $zero, 10		
	add $s0, $zero, $zero	# operand1 = 0
	add $s1, $zero, $zero	# operand2 = 0
	add $s2, $zero, $zero	# operator = 0
	add $s3, $zero, $zero	# result = 0
	j state1
	
state1: 			# If $t9 = 0 then do state1 function 
	beq $t9, $zero, state1	
	andi $t4, $t9, 15	
	beq $t4, 14, display	# =
	beq $t4, 15, clear	# C
	slt $t5, $t4, $t6	# If less then 10; t5 = 1 bc true
	bne $t5, 1, operator	
	beq $t5, 1, digit1	
	
state2:
	beq $t9, $zero, state2	
	andi $t4, $t9, 15
	beq $t4, 14, display	# =
	beq $t4, 15, clear	# C
	slt $t5, $t4, $t6	# If less then 10; t5 = 1 bc true
	bne $t5, 1, operator
	beq $t5, 1, digit2	

digit1:				# operand1 = (operand1 *10) + input
	add $t3, $zero, $s0
	sll $s0, $s0, 3
	add $s0, $s0, $t3
	add $s0, $s0, $t3 
	add $s0, $s0, $t4	
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	add $t8, $zero, $s0 	# Display; Put number entered into register t8
	j state1
	
digit2:				# operand2 = (operand2 *10) + input
	add $t3, $zero, $s1
	sll $s1, $s1, 3
	add $s1, $s1, $t3
	add $s1, $s1, $t3 
	add $s1, $s1, $t4
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	add $t8, $zero, $s1 	# Display; Put number entered into register t8
	j state3
	
operator:
	add $s2, $zero, $t4
	add $t8, $zero, $s0 	# Display; Put number entered into register t8	
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2
	
display:
	add $s3, $zero, $s0
	add $t8, $zero, $s3 	# Display; Put number entered into register t8
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4

clear: 
	j state0Start

state3:
	beq $t9, $zero, state3	
	andi $t4, $t9, 15
	beq $t4, 14, state3_display
	beq $t4, 15, clear	#C
	slt $t5, $t4, $t6	# If less then 10; t5 = 1 bc true
	bne $t5, 1, state3_operator
	beq $t5, 1, digit2	
	
state3_display:
	beq $s2, 10, display_addOp
	beq $s2, 11, display_subOp
	beq $s2, 12, display_multOp
	beq $s2, 13, display_divOp

display_addOp:
	add $s3, $s0, $s1
	add $t8, $zero, $s3 	# Display; Put number entered into register t8
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4

display_subOp:
	sub $s3, $s0, $s1
	add $t8, $zero, $s3 	# Display; Put number entered into register t8	
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4

display_multOp:
	add $t2, $s0, $zero	#t2 is counter
	add $t1, $s1, $zero
	j display_multOpPt2

display_multOpPt2:
	beq $t1, $zero, display_doneMult
	add $t0, $t0, $t2
	add $t1, $t1, -1
	j display_multOpPt2

display_doneMult:
	add $s3, $t0, $zero	
	add $t8, $zero, $s3	
	add $t2, $zero, $zero
	add $t1, $zero, $zero
	add $t0, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4
	
display_divOp:
	add $t2, $s0, $zero	# operand1 temp value
	add $t1, $s1, $zero	# operand2 temp value
	add $s4, $zero, $zero	# s4 is counter
	j display_divOpPt2

display_divOpPt2:
	slt $s5, $t2, $1
	blt $s5, 1, display_doneDiv
	#bne $s5, $zero, display_doneDiv
	sub $t2, $t2, $t1
	addi $s4, $s4, 1
	j display_divOpPt2

display_doneDiv:
	add $s3, $s4, $zero
	add $t8, $zero, $s3
	add $s4, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $s5, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4

state3_operator:
	beq $s2, 10, operator_addOp
	beq $s2, 11, operator_subOp
	beq $s2, 12, operator_multOp
	beq $s2, 13, operator_divOp
	
operator_addOp:
	add $s3, $s0, $s1	
	add $t8, $zero, $s3 	# Display; Put number entered into register t8
	add $s0, $zero, $s3
	add $s2, $zero, $t4	
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2

operator_subOp:
	sub $s3, $s0, $s1
	add $t8, $zero, $s3 	# Display; Put number entered into register t8
	add $s0, $zero, $s3
	add $s2, $zero, $t4	
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2
	
operator_multOp:
	add $t2, $s0, $zero	#t2 is counter
	add $t1, $s1, $zero
	j operator_multOpPt2

operator_multOpPt2:
	beq $t1, $zero, operator_doneMult
	add $t0, $t0, $t2
	add $t1, $t1, -1
	j operator_multOpPt2

operator_doneMult:
	add $s3, $t0, $zero
	add $t8, $zero, $s3
	add $s0, $zero, $s3
	add $s2, $zero, $t4
	add $t2, $zero, $zero
	add $t1, $zero, $zero
	add $t0, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2
		
operator_divOp:
	add $t2, $s0, $zero		
	add $t1, $s1, $zero
	add $s4, $zero, $zero	# s4 is counter
	j operator_divOpPt2

operator_divOpPt2:
	slt $s5, $t2, $1
	#bne $s5, $zero, operator_doneDiv
	blt $s5, 1, operator_doneDiv
	sub $t2, $t2, $t1
	addi $s4, $s4, 1
	j operator_divOpPt2

operator_doneDiv:
	add $s3, $s4, $zero
	add $t8, $zero, $s3
	add $s0, $zero, $s3
	add $s2, $zero, $t4
	add $s4, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $s5, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2
																	
state4:
	beq $t9, $zero, state4	
	andi $t4, $t9, 15
	beq $t4, 14, state4_display
	beq $t4, 15, clear	#C
	slt $t5, $t4, $t6	# If less then 10; t5 = 1 bc true
	bne $t5, 1, state4_operator
	beq $t5, 1, state4_digit	
	
state4_display:
	add $t8, $zero, $s3 	# Display; Put number entered into register t8	
	add $s1, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state4

state4_operator:
	add $s0, $zero, $s3
	add $s2, $zero, $t4
	add $s1, $zero, $zero
	add $s1, $zero, $zero
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state2
	
state4_digit:
	add $s0, $zero, $t4
	add $t8, $zero, $s0 	# Display; Put number entered into register t8
	add $t4, $zero, $zero
	add $t9, $zero, $zero
	j state1
