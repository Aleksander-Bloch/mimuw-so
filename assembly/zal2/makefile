.PHONY: all clean

all: example

core.o: core.asm
	nasm -DN=2 -f elf64 -w+all -w+error -o $@ $<

example.o: example.c
	gcc -c -Wall -Wextra -std=c17 -O2 -o $@ $<

example: core.o example.o
	gcc -z noexecstack -lpthread -o $@ $^

clean:
	rm -rf example *.o
