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

#ifndef LAB_FUNCTIONS_H
#define LAB_FUNCTIONS_H

#include "matrix.h"
#include "vector.h"

vector func1(vector a, vector b, matrix ma, matrix md);
int func2(matrix mk, matrix mn);
vector func3(matrix ms, matrix mz, vector w, vector x);

#endif // LAB_FUNCTIONS_H

