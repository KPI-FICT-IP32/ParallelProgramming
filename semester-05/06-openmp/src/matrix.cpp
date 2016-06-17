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

#include "matrix.h"

matrix generateMatrix(int size, int filler) {
	return generateMatrix(size, size, filler);
}

matrix generateMatrix(int rows, int columns, int filler) {
	matrix result = matrix();
	for (int r = 0; r < rows; r++) {
		result.push_back(std::vector<int>(columns, filler));
	}
	return result;
}

matrix operator*(matrix left, matrix right) {
	assert(left.size() > 0);
	assert(right.size() > 0);
	assert(left[0].size() == right.size());

	matrix result = generateMatrix(left.size(), right[0].size(), 0);
	for (int i = 0; i < left.size(); ++i) {
		for (int j = 0; j < right[0].size(); ++j) {
			for (int k = 0; k < left[0].size(); ++k) {
				result[i][j] += left[i][k] * right[k][j];
			}
		}
	}
	return result;
}

int min(matrix mtrx) {
	int result = mtrx[0][0];
	for (int r = 0; r < mtrx.size(); ++r) {
		for (int c = 0; c < mtrx[r].size(); ++c) {
			if (mtrx[r][c] < result) {
				result = mtrx[r][c];
			}
		}
	}
	return result;
}
