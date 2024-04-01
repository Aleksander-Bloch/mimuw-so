#!/bin/bash

PROGRAMS="inc_thread_test_naive inc_thread_test_lock inc_thread_test_xchg inc_thread_test_cmpxchg inc_thread_test_bts_btr inc_thread_test_mutex"

make all

for p in $PROGRAMS; do
    echo "Running $p"
    time ./$p 10 1000000
    echo
done

make clean
