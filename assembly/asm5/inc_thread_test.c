#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "inc_thread.h"

#define MAX_THREADS 50

static int global_value = 0;

int main(int argc, char *args[]) {
  int i, thread_count;
  thread_data_t td;

  pthread_t tid[MAX_THREADS];

  if (argc != 3) {
    fprintf(stderr, "Usage: %s thread_count max_value\n", args[0]);
    return 1;
  }

  thread_count = atoi(args[1]);
  td.value = &global_value;
  td.count = atoi(args[2]);
  pthread_mutex_init(&td.mutex, NULL);

  if (thread_count > MAX_THREADS || thread_count < 1) {
    fprintf(stderr, "Wrong number of threads %d, should be in range 1...%d.\n",
            thread_count, MAX_THREADS);
    return 1;
  }

  for (i = 1; i < thread_count; ++i)
    if (pthread_create(&tid[i], NULL, &inc_thread, (void*)&td))
      fprintf(stderr, "Function create_thread failed for thread %d.\n", i);

  /* Wątek 0 już mamy uruchomiony. */
  inc_thread((void*)&td);

  for (i = 1; i < thread_count; ++i)
    if (pthread_join(tid[i], NULL))
      fprintf(stderr, "Function join_thread failed for thread %d.\n", i);

  printf("%d\n", global_value);

  pthread_mutex_destroy(&td.mutex);

  return 0;
}
