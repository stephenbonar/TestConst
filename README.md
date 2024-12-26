# TestConst
Demonstrates how constants and other variables compile to assembly language on different platforms.

# Purpose
You can examine the testconst.c source file and then compare it to the different testconst.compile.<platform>.<arch>.s assembly output files.
This will allow you to see what the C code compiles into on diffent platforms and architectures.
I put this together for my own research and learning, but have made it available publically in case it could benefit anyone else.

# Compiling
If you would like to compile this on your own system, simply clone this GitHub repo and run 'make' in the cloned directory.
This will both build the program, testconst, and generate the assembly used to compile, testconst.compile.s. 