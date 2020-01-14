ok:
j start
nop
eret
nop
nop
nop
start:
ori $t1,0xf
mtc0 $t1,$12
nop
nop
nop
syscall
nop
nop
j ok
