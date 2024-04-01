.PHONY: all clean

all: hello print strnlen execve

hello.o: hello.asm
	nasm -f elf64 -w+all -w+error -o $@ $<

hello: hello.o
	ld --fatal-warnings -o $@ $<

print.o: print.asm
	nasm -f elf64 -w+all -w+error -o $@ $<

print: print.o
	ld --fatal-warnings -o $@ $<

strnlen.o: strnlen.asm
	nasm -f elf64 -w+all -w+error -o $@ $<

strnlen: strnlen.o
	ld --fatal-warnings -o $@ $<

execve.o: execve.asm
	nasm -f elf64 -w+all -w+error -o $@ $<

execve: execve.o
	ld --fatal-warnings -o $@ $<

clean:
	rm -rf hello.o hello print.o print strnlen.o strnlen execve.o execve
