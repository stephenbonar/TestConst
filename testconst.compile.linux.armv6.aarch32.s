/*
 * testconst.compile.linux.armv6.aarch32.s - Annotated assembly output.
 * Copyright (C) 2024 Stephen Bonar
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"testconst.c"
	.text
	.global	meaningOfUniverseString           @ meaningOfUniverse declared global.

	/* 
	 * Both global and local string constants ended up in the read-only data
	 * section, .rodata. Interestingly enough, the globbal int constant
	 * meaningOfUniverse also ended up here. 
	 */
	.section	.rodata
	.align	2

/* 
 * The actual string data for meaningOfUniverseString got assigned the
 * auto-generated label .LC0.
 */
.LC0:
	.ascii	"The meaning of the universe is: %i\012\000"
	.data
	.align	2
	.type	meaningOfUniverseString, %object
	.size	meaningOfUniverseString, 4

/* 
 * The actual named label for meaningOfUniverseString is a pointer to the
 * string itself. 
 */
meaningOfUniverseString:
	.word	.LC0                        @ Pointer to .LC0 string data.
	.global	meaningOfUniverse
	.section	.rodata
	.align	2
	.type	meaningOfUniverse, %object
	.size	meaningOfUniverse, 4

/* The global int constant meaningOfUniverse is simply a word in .rodata. */
meaningOfUniverse:
	.word	42
	.align	2

/* 
 * The local string constant numberString is still in .rodata but does not have
 * a named label. Its pointer is in the .text section, which is still
 * read-only.
 */
.LC1:
	.ascii	"The number is: %i\012\000"

	/* 
	 * Text section containing code and some read-only data used by code starts
	 * here.
	 */
	.text
	.align	2
	.global	main
	.arch armv6
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function


main:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0

	/* 
	 * By convention, push frame pointer and link register onto the stack to
	 * preserve their values from the calling function (which in this case
	 * is just the init code and may not have even used a frame, but the
	 * compiler does it anyway).
	 */
	push	{fp, lr}

	/* 
	 * After pushing fp and lr on the stack, the stack pointer points to the
	 * preserved lr value as it was the last item pushed on the stack. But fp
	 * should point to the first item on the stack, which was the previous 
	 * value of fp. To point fp there, we simply add 4 bytes to sp and store
	 * the result in fp. We add because the stack grows downward towards lower
	 * addresses and the bottom of the frame is at a higher address. 
	 */
	add	fp, sp, #4

	/* 
	 * We then allocate 3 words on the stack at 4-bytes each, which will be
	 * used for local variables and pointers to constants.
	 */
	sub	sp, sp, #16

	/* 
	 * The first local constant, number, is simply stored on the stack. It
	 * is not read-only at the assembly level, but the compiler will prevent
	 * its modification after assignment. The compiler uses framepointer with
	 * an offset of -8 when referencing 'number'. Recall that framepointer
	 * points to the bottom of the stack frame for the main function, and two
	 * register values were pushed onto the stack, fp pointing to the first. 
	 * Each word on the stack is 4 bytes, so to get to the 3rd item (which is)
	 * the first item we allocated for local variables, we have to subtract 8
	 * bytes (again, stack grows downwards towards lower memory addresses).
	 *
	 * Here we simply move the immediate value 1 into register r3 and store it
	 * on the stack. The value '1' was small enough to simply use an immediate
	 * value rather than storing it as a dedicated .word in the text section. 
	 */
	mov	r3, #1
	str	r3, [fp, #-8]

	/* 
	 * Label .L3 is the local constant int largeNumber. This constant was large
	 * enough that it needed a dedicated word (stored at .L3) in the text
	 * section. This is a "true" constant in the sense that .L3 can't be
	 * modified as any data in the .text section is read only, just like the
	 * instructions themselves are.
	 *
	 * Here we load the address of the constant value in .L3 into register r3
	 * and store it in the stack. fp - 8 is the value of number, so the next
	 * variable is at fp - 12, and is a pointer to the constant value at .L3.
	 */
	ldr	r3, .L3
	str	r3, [fp, #-12]

	/* 
	 * The local constant string numberString is stored in the .rodata section
	 * where the address is far enough away that we can't load it as an offset
	 * of fp, sp, or pc (program counter). This is because ARM can only use
	 * indirect addressing where the address has to be loaded into a register
	 * before the value can be retrieved or stored. Additionally, ARM 
	 * instructions can only use small immediate values. 
	 *
	 * That said, on ARM you need to store "far" addresses such as those
	 * items stored in the .rodata section as constant words in the read-only
	 * text section, typically stored at the bottom of all the instructions. 
	 * That way you can load the address into a register using a small 
	 * immediate value as an offset from the pc, fp, or sp, which CAN fit
	 * in an instruction. In this particular example, the compiler knows
	 * numberString is 4 bytes after .L3, which was the value of largeNumber.
	 * This will futher assemble to ldr, [pc, #<offset>] where <offset> is
	 * however many bytes away .L3+4 is from the current executing instruction
	 * in pointed to by PC. If you run this program in a debugger and you get
	 * to this ldr instruction, that is what you will see instead of .L3+4.
	 *
	 * Here we load the address contained within .L3+4 into r3, which is the
	 * address of .LC1 in the far .rodata section, then store it in the next 
	 * available space on the stack, which is fp - 16. That variable on the
	 * stack will then be the pointer to the string.
	 */
	ldr	r3, .L3+4
	str	r3, [fp, #-16]

	/* 
	 * We then store the local variable, mutableNumber, in the next available
	 * space we allocated on the stack earlier, which is fp - 20. We move the
	 * immediate value 10 into register r3, which is what we store on the stack
	 * as we initialized mutableNumber = 10. 
	 */
	mov	r3, #10
	str	r3, [fp, #-20]

	/* 
	 * We then added 5 to mutableNumber. Since we stored it on the stack at
	 * fp - 20, we have to reload the value from stack into register r3,
	 * perform the addition, and then store the result back on the stack at
	 * fp - 20. If we used more aggressive compiler optimizations, this may
	 * have been able to be handled exclusively by registers. 
	 */
	ldr	r3, [fp, #-20]
	add	r3, r3, #5
	str	r3, [fp, #-20]

	/*
	 * Now we get to the printf calls. By calling convention, the first
     * argument to pass into the function goes in register r0, the second
	 * in r1, the third in r2, and the fourth in r3. Registers r4 - r11 should
	 * be preserved by printf for use by main (or whatever the calling 
	 * function is), so we should be reasonably guaranteed printf won't modify
	 * r4 - r11. If we needed to pass more than four arguments into a function,
	 * we would need to push any additional arguments onto the stack before
	 * calling the function.
	 *
	 * Here we load fp - 16, or the numberString pointer, into r0 as this
	 * corresponds to printf's first parameter, const char* format. We then 
	 * load fp - 8 into r1, which is number, as the second argument and call
	 * printf with the Branch and Link (bl) instruction. The bl instruction
	 * stores the return address in lr (link address) so the program can
	 * resume execution here when the function returns. 
	 */
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-16]
	bl	printf

	/* 
	 * The second call to printf once again loads fp - 16 into r0, but this
	 * time loads fp - 12 into r1, which is the value of largeNumber.
	 */
	ldr	r1, [fp, #-12]
	ldr	r0, [fp, #-16]
	bl	printf

	/* 
	 * The third call to printf loads fp -16 into r0 as usual, then fp - 20
	 * into r1, which is the value of mutableNumber.
	 */
	ldr	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	printf

	/*
	 * Now this call to printf is the most interesting. We first start by
	 * loading .L3+8 into register r3. .L3+8 is the address of 
	 * meaningOfUniverseString in the .rodata section. But 
	 * meaningOfUniverseString is itself a pointer to the actual characters,
	 * which is stored in .LC0. So we essentially have a pointer to a pointer.
	 * I'm honestly not sure why the compiler did it this way.
	 *
	 * First, we load the address of the address of the string (char**) into
	 * register r3. Then, we load the address contained at that address into
	 * r3. This is like dereferencing char**. Now r3 contains char*. We then
	 * copy the value of r3 into r0 as we need the string for printing. 
	 * Finally, we move the immediate value 42 of the global constant 
	 * meaningOfUniverse into r2 and copy it into r1 for printing. Ironically,
	 * the compiler optimization simply substituted the value 42 as an
	 * immediate rather than use the constant in .rodata even though it exists
	 * for referencing. 
	 */
	ldr	r3, .L3+8  @ Load char** into r3
	ldr	r3, [r3]   @ Dereference char**
	mov	r2, #42
	mov	r1, r2
	mov	r0, r3
	bl	printf
 
	/* 
	 * Put 0 in r0, which is the return value.
	 */
	mov	r3, #0
	mov	r0, r3

	/* 
	 * Deallocate the local variables by putting stack pointer back to where
	 * it was just after we preserved fp and lr on the stack. We can do this by
	 * simply substracting 4-bytes from the frame pointer, as the only other
	 * value we preserved on the stack was lr, which was 4 bytes. 
	 */
	sub	sp, fp, #4

	/* 
	 * Pop the last two items off the stack into fp and pc, which will restore
	 * fp to what it was before main was called, and set pc to where it was
	 * when main was called (the next instruction after call to main in the
	 * init code). Link register contains that address, so we can pop lr into
	 * pc directly. The pop operation also puts sp back to where it was before
	 * main was called. This all effectively returns from main. r0 contains
	 * the return code by convention. 
	 */
	@ sp needed
	pop	{fp, pc}
.L4:
	.align	2
.L3:
	.word	-216006656
	.word	.LC1
	.word	meaningOfUniverseString
	.size	main, .-main
	.ident	"GCC: (Raspbian 10.2.1-6+rpi1) 10.2.1 20210110"
	.section	.note.GNU-stack,"",%progbits
