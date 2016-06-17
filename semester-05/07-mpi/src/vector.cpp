/**
* Parallel programming
* Lab 7
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

#include "vector.h"

vector generateVector(int size, int filler) {
  vector result = vector(size, filler);
  return result;
}

vector operator*(matrix left, vector right) {
  assert(left.size() > 0);
  assert(right.size() > 0);
  assert(right.size() == left[0].size());

  vector result = generateVector(left.size(), 0);
  for (int i = 0; i < left.size(); ++i) {
    for (int j = 0; j < right.size(); ++j) {
      result[i] += left[i][j] * right[j];
    }
  }
  return result;
}

vector operator*(vector left, matrix right) {
  assert(left.size() > 0);
  assert(right.size() > 0);
  assert(left.size() == right[0].size());

  vector result = generateVector(left.size(), 0);
  for (int i = 0; i < right[0].size(); ++i) {
    for (int j = 0; j < right.size(); ++j) {
      result[i] += right[i][j] * left[j];
    }
  }
  return result;
}

vector operator+(vector left, vector right) {
  assert(left.size() > 0);
  assert(left.size() == right.size());
  
  vector result = vector(left);
  for (int i = 0; i < result.size(); ++i) {
    result[i] += right[i];
  }
  
  return result;
}

vector operator-(vector left, vector right) {
    assert(left.size() > 0);
    assert(left.size() == right.size());

    vector result = vector(left);
    for (int i = 0; i < result.size(); ++i) {
      result[i] -= right[i];
    }

    return result;
}
