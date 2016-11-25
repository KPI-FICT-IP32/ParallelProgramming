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

#ifndef LAB_TASKS_H
#define LAB_TASKS_H

#include <iostream>
#include "functions.h"
#include <sstream>

void task1(int size, int tid);
void task2(int size, int tid);
void task3(int size, int tid);

#endif
