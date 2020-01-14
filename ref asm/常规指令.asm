start:
addi 	$t1,	$t0,	0x3000 #r9=3000
ori  	$t2,	$t0,	0x8765 #r10=8765
andi 	$t3,	$t0,	0xffff #r11=0
slti 	$t4,	$t0,	0x1 #r12=1
lui  	$t5,	0x1234 #f13=0x12340000
add 	$t6,	$t1,	$t2 #r14=9999
sub	$t7,	$t2,	$t1 #r15=7631
and	$s0,	$t2,	$t4 #r16=1
or	$s1,	$t2,	$t3 #r17=8765
nor	$s2,	$t3,	$t4 #r18=fffffffe
slt	$s3,	$t3,	$t4 #r19=1
srl	$s4,	$t1,	4 #r20=123
sw	$t4,	($t3) #store 1
lw	$s5	($t3) #load 1 to r21
j	start