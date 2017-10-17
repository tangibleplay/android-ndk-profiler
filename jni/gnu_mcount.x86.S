/*
 * Part of the android-ndk-profiler library.
 * Copyright (C) Richard Quirk
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */
.globl mcount	
.type	mcount, @function

mcount:
    push %eax
    pushl %ecx
    pushl %edx
    movl 4(%ebp), %eax
	pushl %ebp
    movl %esp, %ebp
    andl $-16, %esp
    subl $16, %esp
    movl %eax, (%esp)
    movl 8(%ebp), %eax
    movl %eax, 4(%esp)
	/* No need to access the PLT or GOT, __mcount_internal is an
	   internal function and we can make a relative call.  */
	call profCount

	/* Pop the saved registers.  Please note that 'mcount' has no
	   return value.  */
    movl %ebp, %esp
    popl %ebp
    popl %edx
    popl %ecx
	popl %eax
	ret