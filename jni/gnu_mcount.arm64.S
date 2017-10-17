/*
 * Part of the android-ndk-profiler library.
 * Copyright (C) Richard Quirk
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

.section .bss

.macro mcount_enter
# NOTE: save call-used registers and fp/lr. 
# x19 is not call-used but its in the same instruction.
        stp     x29, x30, [sp, #-16]!
        stp     x18, x19, [sp, #-16]!
        stp     x16, x17, [sp, #-16]!
        stp     x14, x15, [sp, #-16]!
        stp     x12, x13, [sp, #-16]!
        stp     x10, x11, [sp, #-16]!
        stp     x8, x9, [sp, #-16]!
        stp     x6, x7, [sp, #-16]!
        stp     x4, x5, [sp, #-16]!
        stp     x2, x3, [sp, #-16]!
        stp     x0, x1, [sp, #-16]!
        mov     x29, sp
.endm

.macro mcount_exit
        ldp     x0, x1, [sp], #16
        ldp     x2, x3, [sp], #16
        ldp     x4, x5, [sp], #16
        ldp     x6, x7, [sp], #16
        ldp     x8, x9, [sp], #16
        ldp     x10, x11, [sp], #16
        ldp     x12, x13, [sp], #16
        ldp     x14, x15, [sp], #16
        ldp     x16, x17, [sp], #16
        ldp     x18, x19, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
.endm



.section .text


.global _mcount
.type _mcount,function

_mcount:
        mcount_enter

        # ldr x0, [sp, #16]
        # x0 is last lr set by compiler.
        mov x1, x30
        bl profCount

        mcount_exit

/*
        push {r0-r3}
        push {lr}
        ldr r0, [sp, #20]  @ r0 = lr pushed by calling routine
        mov r1, lr    @ address of calling routine
        bl profCount
        pop {r2}           @ this routine's return address
        pop {r0, r1}
        @ stack contains r2, r3 and lr
        ldr r3, [sp , #8]  @ r3 = lr pushed by calling routine
        str r2, [sp, #8]   @ return address now last on the stack
        mov lr, r3         @ lr = caller's expected lr
        pop {r2, r3}
        pop {pc}   @ pop caller's expected r2, r3 and return
*/