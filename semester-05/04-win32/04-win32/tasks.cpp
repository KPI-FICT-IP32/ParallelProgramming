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

#include "tasks.h"

void task1(LPVOID lpSize) {
  std::cout << "task 1 in thread " << GetCurrentThreadId() << " started" << std::endl;
  int size = *((int *)lpSize);

  Sleep(500);

  vector a, b;
  matrix ma, md;

  a = generateVector(size);
  b = generateVector(size);
  ma = generateMatrix(size);
  md = generateMatrix(size);

  vector result = func1(a, b, ma, md);

  if (size < 8) {
    std::stringstream ss;
    ss << "task 1 result: ";
    ss << '[';
    for (int i = 0; i < result.size(); ++i) {
      ss << result[i] << " ";
    }
    ss << ']';

    std::cout << ss.str() << std::endl;
  }

  std::cout << "task 1 in thread " << GetCurrentThreadId() << " finished" << std::endl;
}

void task2(LPVOID lpSize) {
  std::cout << "task 2 in thread " << GetCurrentThreadId() << " started" << std::endl;
  int size = *((int *)lpSize);

  Sleep(500);

  matrix mk, mn;

  mk = generateMatrix(size);
  mn = generateMatrix(size);

  int result = func2(mk, mn);

  if (size < 8) {
    std::stringstream ss;
    ss << "task 2 result: " << result;
    std::cout << ss.str() << std::endl;
  }

  std::cout << "task 2 in thread " << GetCurrentThreadId() << " finished" << std::endl;
}

void task3(LPVOID lpSize) {
  std::cout << "task 3 in thread " << GetCurrentThreadId() << " started" << std::endl;
  int size = *((int *) lpSize);
  Sleep(500);

  vector w, x;
  matrix ms, mz;

  w = generateVector(size);
  x = generateVector(size);
  ms = generateMatrix(size);
  mz = generateMatrix(size);

  vector result = func3(ms, mz, w, x);

  if (size < 8) {
    std::stringstream ss;
    ss << "task 3 result: ";
    ss << '[';
    for (int i = 0; i < result.size(); ++i) {
      ss << result[i] << " ";
    }
    ss << ']';

    std::cout << ss.str() << std::endl;
  }

  std::cout << "task 3 in thread " << GetCurrentThreadId() << " finished" << std::endl;
}
