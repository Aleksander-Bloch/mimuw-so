#include "inc_thread.h"
#include <pthread.h>
#include <stdlib.h>

void *inc_thread(void *arg) {
    thread_data_t *td = (thread_data_t*)arg;
    for (int i = 0; i < td->count; ++i) {
        pthread_mutex_lock(&td->mutex);
        ++(*td->value);
        pthread_mutex_unlock(&td->mutex);
    }
    return NULL;
}
