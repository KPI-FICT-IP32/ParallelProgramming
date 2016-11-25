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

#include "tasks.h"

void task1(int size, int tid) {
  {
    std::stringstream ss;
    ss << "task 1 in thread " << tid << " started" << std::endl;
    std::cout << ss.str();
  }

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
    ss << std::endl;
    std::cout << ss.str();
  }
  
  {
    std::stringstream ss;
    ss << "task 1 in thread " << tid << " finished" << std::endl;
    std::cout << ss.str();
  }
}

void task2(int size, int tid) {
  {
    std::stringstream ss;
    ss << "task 2 in thread " << tid << " started" << std::endl;
    std::cout << ss.str();
  }

  matrix mk, mn;

  mk = generateMatrix(size);
  mn = generateMatrix(size);

  int result = func2(mk, mn);

  if (size < 8) {
    std::stringstream ss;
    ss << "task 2 result: " << result;
    ss << std::endl;
    std::cout << ss.str();
  }

  {
    std::stringstream ss;
    ss << "task 2 in thread " << tid << " finished" << std::endl;
    std::cout << ss.str();
  }
}

void task3(int size, int tid) {
  {
    std::stringstream ss;
    ss << "task 3 in thread " << tid << " started" << std::endl;
    std::cout << ss.str();
  }

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
    ss << std::endl;
    std::cout << ss.str();
  }

  {
    std::stringstream ss;
    ss << "task 3 in thread " << tid << " finished" << std::endl;
    std::cout << ss.str();
  }
}
