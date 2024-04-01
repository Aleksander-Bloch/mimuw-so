#!/bin/bash

make execve

./execve ./hello
./execve ./execve ./hello
./execve ./execve ./execve ./hello
./execve /bin/bash -c ls
./execve /bin/bash -c "ls -l"
./execve /bin/bash -c "./execve ./hello"
