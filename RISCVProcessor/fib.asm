.data
fib_sequence: .space 40  

.text
.globl main

main:
    li $t0, 0          # (first Fibonacci number)
    li $t1, 1          # (second Fibonacci number)
    la $t2, fib_sequence # move address of fib_sequence into $t2

    sw $t0, 0($t2)     # store x0 at fib_sequence[0]
    sw $t1, 4($t2)     # store x1 at fib_sequence[1]

    li $t3, 2          # initialize to 2 (next index in sequence)

loop:
    beq $t3, 10, end   # if counter = 10, exit loop

    # find next fib number
    add $t4, $t0, $t1  # $t4 = x0 + x1

    # store the result in the array
    sw $t4, 0($t2)     # Store $t4 at fib_sequence[$t3]

    # update x0 and x1 for next iteration
    move $t0, $t1      # $t0 = $t1
    move $t1, $t4      # $t1 = $t4

    # increment the counter and array index
    addi $t3, $t3, 1   # $t3 = $t3 + 1
    addi $t2, $t2, 4  

    j loop            

end:
    # 
    li $v0, 10         # load exit syscall code
    syscall            
