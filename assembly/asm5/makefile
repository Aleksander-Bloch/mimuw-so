PROGRAMS = inc_thread_test_naive inc_thread_test_lock inc_thread_test_xchg inc_thread_test_cmpxchg inc_thread_test_bts_btr inc_thread_test_mutex
CC = gcc
CFLAGS = -std=c17 -Wall -Wextra -O2
LDFLAGS = -pthread -z noexecstack

all: $(PROGRAMS)

%.o: %.asm
	nasm -f elf64 -w+all -w+error -o $@ $<

inc_thread_mutex.o: inc_thread_mutex.c inc_thread.h
	$(CC) -c $(CFLAGS) -o $@ $<

inc_thread_test.o: inc_thread_test.c inc_thread.h
	$(CC) -c $(CFLAGS) -o $@ $<

inc_thread_test_%: inc_thread_test.o inc_thread_%.o
	$(CC) $(LDFLAGS) -o $@ $^

.PHONY: all clean

clean:
	rm -rf $(PROGRAMS) *.o
