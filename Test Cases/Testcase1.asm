    # This program finds the first odd entry in the memory
    add x1, x0, x0
    addi x2, x0, 4
    addi x5, x0, 1
loop:
    lw x3, 0(x1)	# Read the data
    and x4, x3, x5	# Get the least significant bit
    add x1, x1, x2	# Increment the address
    beq x4, x0, loop	# Go back if the least significant bit is 0
    sub x1, x1, x2	# Get the correct address where the data was found
    sw x3, 28(x0)	# Store it
    lw x1, 28(x0)	# Reading it to mak sure it was stored
    or x1, x1, x2	# (Just checking the or function)