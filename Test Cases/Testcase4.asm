addi x1, x0, 16
jalr x2, 0(x1)
add x0, x0, x0
add x3, x0, x0
blt x1, x0, l1
or x1, x1, x2
l1: addi x1, x0, -8
sh x1, 100(x0)
lhu x2, 100(x0)
lh x3, 100(x0)
bgeu x3, x2, l2
add x1, x0, x0
l2: bne x3, x2, l3
add x2, x0, x0
l3: srli x1, x1, 1
