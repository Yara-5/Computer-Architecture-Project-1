addi x1, x0, -5
addi x2, x0, 3
bltu x1, x2, l1
add x3, x0, x0
l1: sb x1, 100(x0)
lbu x1, 100(x0)
slti x2, x2, 7
sltiu x1, x1, -7
beq x0, x0, l2
ecall
ecall
ecall
ecall
l2: bne x0, x0, l3
ecall
l3: xori x1, x1, 2
