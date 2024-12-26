# Makefile - Creates program binary an assembly for testconst.
# Copyright (C) 2024 Stephen Bonar
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This make file creates not only the binary testconst to run and / or
# debug the program, but also testconst.compile.s, to see what assembly
# instructions the program compiles to on the current platform. As I try
# this demo on different platforms / architectures, I make a copy of
# testconst.compile.s for each architecture so we can compare different
# architectures. 
all: testconst testconst.compile.s

testconst: testconst.c
	gcc -g -o $@ $^

testconst.compile.s: testconst.c
	gcc -S -o $@ $^

clean:
	rm testconst.compile.s testconst