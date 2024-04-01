#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
        int x;
        x = storage(4);
        assert(x == 0);
        x = storage(10);
        assert(x == 4);
        x = storage(7);
        assert(x == 10);
        switch (fork())
        {
        case -1:
                perror("fork");
                exit(1);
        case 0:
                x = storage(5);
                assert(x == 7);
                break;
        default:
                wait(0);
                x = storage(0);
                assert(x == 5);
                break;
        }
        return 0;
}
