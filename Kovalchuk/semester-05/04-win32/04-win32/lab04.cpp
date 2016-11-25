/**
* Parallel programming
* Lab 4
*
* Functions:
* F1: C = A - B * (MA * MD)
* F2: o = Min(MK * MM)
* F3: T = (MS * MZ) * (W + X)
*
* @since 2015-10-18
* @author Olexandr Kovalchuk
* @group IP-32
*/

#include <iostream>
#include "functions.h"
#include "cmdopts.h"
#include "tasks.h"

int main(int argc, char* argv[]) {
  std::cout << "lab 04 started" << std::endl;
  int size, threadCount;

  {
    char *sizeopt = getCmdOption(argv, argv + argc, "-s");
    size = sizeopt ? atoi(sizeopt) : 4;
    char *threadopt = getCmdOption(argv, argv + argc, "-t");
    threadCount = threadopt ? atoi(threadopt) : 3;
  }

  std::vector<HANDLE> handles;
  HANDLE thread_;
  LPTHREAD_START_ROUTINE func;

  for (int i = 0; i < threadCount; ++i) {
    switch (i % 3) {
      case 0:
        func = (LPTHREAD_START_ROUTINE) task1;
        break;
      case 1:
        func = (LPTHREAD_START_ROUTINE) task2;
        break;
      default: // case 2 
        func = (LPTHREAD_START_ROUTINE) task3;
        break;
    }
    thread_ = CreateThread(NULL, 0, func, (LPVOID)&size, CREATE_SUSPENDED, NULL);
    SetThreadPriority(thread_, THREAD_PRIORITY_NORMAL);
    handles.push_back(thread_);
  }

  for (int i = 0; i < handles.size(); ++i) {
    ResumeThread(handles[i]);
  }

  for (int i = 0; i < handles.size(); ++i) {
    WaitForSingleObject(handles[i], INFINITE);
    CloseHandle(handles[i]);
  }

  std::cout << "lab 04 finished" << std::endl;
	return 0;
}
