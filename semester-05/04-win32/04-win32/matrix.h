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

#ifndef LAB_MATRIX_H
#define LAB_MATRIX_H

#include <vector>
#include <assert.h>

typedef std::vector<std::vector<int>> matrix;

matrix generateMatrix(int size, int filler = 1);
matrix generateMatrix(int rows, int columns, int filler = 1);

matrix operator*(matrix left, matrix right);
int min(matrix mtrx);

#endif // LAB_MATRIX_H
