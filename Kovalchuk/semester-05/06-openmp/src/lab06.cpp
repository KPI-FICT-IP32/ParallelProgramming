/**
* Parallel programming
* Lab 6
*
* Functions:
* F1: C = A - B * (MA * MD)
* F2: o = Min(MK * MM)
* F3: T = (MS * MZ) * (W + X)
*
* @since 2015-11-11
* @author Olexandr Kovalchuk
* @group IP-32
*/

#include <iostream>
#include <omp.h>
#include "functions.h"
#include "cmdopts.h"
#include "tasks.h"

int main(int argc, char* argv[]) {

  std::cout << "lab 04 started" << std::endl;
  int size, threads, tid;

  {
    char *sizeopt = getCmdOption(argv, argv + argc, "-s");
    size = sizeopt ? atoi(sizeopt) : 4;
    char *threadopt = getCmdOption(argv, argv + argc, "-t");
    threads = threadopt ? atoi(threadopt): 3;
  }

  #pragma omp parallel shared(size) private(tid) num_threads(threads)
  {
    tid = omp_get_thread_num();
    switch(tid % 3) {
      case 0:
        task1(size, tid);
        break;
      case 1:
        task2(size, tid);
        break;
      default: case 2:
        task3(size, tid);
        break;
    }
  }

  std::cout << "lab 06 finished" << std::endl;
	return 0;
}
