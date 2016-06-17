/**
* Parallel programming
* Lab 6
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

#ifndef LAB_VECTOR_H
#define LAB_VECTOR_H

#include <vector>
#include "matrix.h"
#include <assert.h>
typedef std::vector<int> vector;

vector generateVector(int size, int filler = 1);

vector operator*(matrix left, vector right);
vector operator*(vector left, matrix right);
vector operator+(vector left, vector right);
vector operator-(vector left, vector right);

#endif // LAB_VECTOR_H

