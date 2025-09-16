main:
beq sp,x0,EQ
blt sp,x0,LT
bltu sp,x0,LTU
bne sp,x0,NE
bge sp,x0,GE
bgeu sp,x0,GEU

EQ:
add x0,x0,x0
LT:
add x0,x0,x0
LTU:
add x0,x0,x0
NE:
add x0,x0,x0
GE:
add x0,x0,x0
GEU:
add x0,x0,x0
