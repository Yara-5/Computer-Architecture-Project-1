    # This program finds the first odd entry in part of the memory
    
    #Saving some data to check
    addi x1, x0, 16	
    sw x1, 100(x0)
    addi x1, x0, 10
    sw x1, 104(x0)
    addi x1, x0, 25
    sw x1, 108(x0)
    addi x1, x0, 17
    sw x1, 112(x0)
       
             
    add x1, x0, x0
    addi x2, x0, 4
    addi x5, x0, 1
loop:
    lw x3, 100(x1)	# Read the data
    and x4, x3, x5	# Get the least significant bit
    add x1, x1, x2	# Increment the address
    beq x4, x0, loop	# Go back if the least significant bit is 0
    sub x1, x1, x2	# Get the correct address where the data was found
    sw x3, 200(x0)	# Store it
    lw x1, 200(x0)	# Reading it to mak sure it was stored
    or x1, x1, x2	# (Just checking the or function)
    
