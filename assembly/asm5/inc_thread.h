#ifndef INC_THREAD_H
#define INC_THREAD_H

#include <pthread.h>

typedef struct {
  int *value;
  int count;
  pthread_mutex_t mutex;
} thread_data_t;

void *inc_thread(void *);

#endif
