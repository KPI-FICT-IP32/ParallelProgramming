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

#include "functions.h"

vector func1(vector a, vector b, matrix ma, matrix md) {
  return (a - b * (ma * md));
}

int func2(matrix mk, matrix mn) {
  return (min(mk*mn));
}

vector func3(matrix ms, matrix mz, vector w, vector x) {
  return ((ms * mz) * (w + x));
}
