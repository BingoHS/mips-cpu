#R–Õ√∞œ’
#id wb√∞œ’
start:
addi	$t1,	$t0,	0x1111#r9=0x1111
nop
nop
addi	$t2,	$t1,	0x1111 #r10=0x2222 rs√∞œ’
nop
nop
add	$t3,	$t1,	$t2 #r11=0x3333 rt√∞œ’
#ex wb√∞œ’
nop
add	$t4,	$t3,	$t3 #r12=0x6666 rs,rt√∞œ’
#ex mem√∞œ’
add	$t5,	$t4,	$t4 #r13=0xCCCC rs,rt√∞œ’
#LW–Õ√∞œ’
sw	$t5,	($t0) # mem[0]<=0xCCCC
lw	$t6,	($t0) # r14<=mem[0]
#ex mem√∞œ’
add	$t7,	$t6,	$t6 #r15=0x19998
#ex wb√∞œ’
add	$s0,	$t6,	$t6 #r16=0x19998
#id wb√∞œ’
add	$s1,	$t6,	$t6 #r17=0x19998
beq	$s0,	$s1,	start
