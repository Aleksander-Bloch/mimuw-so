#include <lib.h>
#include <minix/rs.h>

int main()
{
    message m;
    endpoint_t pm_ep;
    minix_rs_lookup("pm", &pm_ep);
    _syscall(pm_ep, PM_HELLO, &m);
}
