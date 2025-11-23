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
loop:
    lw x3, 100(x1)	# Read the data
    andi x4, x3, 1	# Get the least significant bit
    add x1, x1, x2	# Increment the address
    bge x0, x4, loop	# Go back if the least significant bit is 0
    sub x1, x1, x2	# Get the correct address where the data was found
    sb x3, 200(x0)	# Store it
    lb x1, 200(x0)	# Reading it to mak sure it was stored
    ori x1, x1, 4	# (Just checking the or function)
