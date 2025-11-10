addi x1, x0, 5
slli x1, x1, 1
addi x4, x0, 1
addi x3, x0, 0xFFFFFFFF
sltu x2, x3, x1
srl x2, x2, x4
sra x3, x3, x4
fence 1, 1
add x1, x0, x0