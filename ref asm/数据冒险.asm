#R��ð��
#id wbð��
start:
addi	$t1,	$t0,	0x1111#r9=0x1111
nop
nop
addi	$t2,	$t1,	0x1111 #r10=0x2222 rsð��
nop
nop
add	$t3,	$t1,	$t2 #r11=0x3333 rtð��
#ex wbð��
nop
add	$t4,	$t3,	$t3 #r12=0x6666 rs,rtð��
#ex memð��
add	$t5,	$t4,	$t4 #r13=0xCCCC rs,rtð��
#LW��ð��
sw	$t5,	($t0) # mem[0]<=0xCCCC
lw	$t6,	($t0) # r14<=mem[0]
#ex memð��
add	$t7,	$t6,	$t6 #r15=0x19998
#ex wbð��
add	$s0,	$t6,	$t6 #r16=0x19998
#id wbð��
add	$s1,	$t6,	$t6 #r17=0x19998
beq	$s0,	$s1,	start
