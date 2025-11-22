lui x2, 1
auipc x3, 1
add x3, x3, x2
srai x3, x3, 2
sh x3, 64(x0)
slt x4, x3, x2
lh x5, 64(x0)
xor x5, x5, x4
sll x5, x5, x4
jal x1, l1
add x1, x0, x0
l1: xori x3, x3, 7
