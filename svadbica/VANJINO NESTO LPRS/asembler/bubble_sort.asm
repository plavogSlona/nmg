.data
    8   // m[0] - broj elemenata
    1   // m[1] - početak niza
    6
    3
    7
    5
    4
    8
    2

.text

    sub R0, R0, R0
    ld R0, R0           // R0 <= m[0]

for1_init:
    sub R1, R1, R1
    inc R1, R1          // i = 1

for1_uslov:
    sub R3, R1, R0      // i < n
    jmpns for1_exit

for2_init:
    inc R2, R1

for2_uslov:
    sub R3, R0, R2      // j <= n, odn. n >= j
    jmps for2_exit
    
if:
    ld R4, R1           // R4 <= m[R1], odn. R4 <= m[i]
    ld R5, R2           // R5 <= m[j]
    sub R3, R5, R4      // m[j] < m[i]
    jmpns skip_swap
swap:
    st R4, R2           // m[j] <= R4
    st R5, R1           // m[i] <= R5

skip_swap:
    inc R2, R2
    jmp for2_uslov

for2_exit:
    inc R1, R1
    jmp for1_uslov

for1_exit:
    jmp for1_exit