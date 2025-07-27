.text
.globl main

main:
    addi x5, x0, 0      # a = 0 (x5)
    addi x6, x0, 1      # b = 1 (x6) 
    addi x8, x0, 0      # i = 0 (x8)
    addi x9, x0, 10     # loop limit = 10 (x9)

loop:
    # branch greater than (i < 10)
    bge x8, x9, end     # if i >= 10, exit loop
    
    # sum = a + b
    add x7, x5, x6      # sum = a + b (x7)
    
    # a = b
    add x5, x6, x0      # a = b
    
    # b = sum  
    add x6, x7, x0      # b = sum
    
    # printf("%d\n", sum) - simplified as just storing sum
    # in real implementation, this would be a system call
    # i++
    addi x8, x8, 1      # i = i + 1
    
    # jump back to loop
    jal x0, loop        # goto loop
    
end:
    # return 0
    addi x10, x0, 0     # return value = 0
    # exit (would be system call in real implementation)            
