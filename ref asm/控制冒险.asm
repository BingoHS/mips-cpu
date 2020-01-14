start:
addi 	$t1,	$t0,	0x1 #id mem
addi 	$t2,	$t0,	0x1 #id ex
beq	$t1,	$t2,	next
nop
nop
next:
addi	$t3,	$t0,	0x1
nop
nop
beq	$t1,	$t3,	final
nop
nop
final:
sw 	$t1,	($t0)
lw	$t4,	($t0)
beq	$t1,	$t4,	end
nop
nop
end:
sw 	$t1,	($t0)
lw	$t4,	($t0)
bne	$t0,	$t4,	start

