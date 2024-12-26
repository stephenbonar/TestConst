/*
 * testconst.compile.linux.x86_64.s - Annotated assembly output.
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

	.file	"testconst.c"
	.text
	.globl	meaningOfUniverseString
	.section	.rodata
	.align 8
.LC0:
	.string	"The meaning of the universe is: %i\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	meaningOfUniverseString, @object
	.size	meaningOfUniverseString, 8
meaningOfUniverseString:
	.quad	.LC0
	.globl	meaningOfUniverse
	.section	.rodata
	.align 4
	.type	meaningOfUniverse, @object
	.size	meaningOfUniverse, 4
meaningOfUniverse:
	.long	42
.LC1:
	.string	"The number is: %i\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$1, -20(%rbp)
	movl	$-216006656, -16(%rbp)
	leaq	.LC1(%rip), %rax
	movq	%rax, -8(%rbp)
	movl	$10, -12(%rbp)
	addl	$5, -12(%rbp)
	movl	-20(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-16(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$42, %edx
	movq	meaningOfUniverseString(%rip), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20240910"
	.section	.note.GNU-stack,"",@progbits
