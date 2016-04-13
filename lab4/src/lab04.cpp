/**
 * Parallel programming 2
 * @teacher Korochkin Oleksandr Volodymyrovych
 *
 * Lab 04. OpenMP
 * 
 * MA = min(Z) * MO + alpha * (MT * MR)
 *
 * @author Oleksandr Kovalchuk a.k.a. anxolerd
 * @group IP-32
 */
#include <iostream>
#include <omp.h>

// Include constants
#include "lab04.h"


int main(int argc, char* argv[]) {
    std::cout << "lab 04 started" << std::endl; 
    int tid;

    int alpha, min_z;
    int *Z;
    int **MA, **MO, **MT, **MR;

    omp_lock_t lock_min_z;
    omp_init_lock(&lock_min_z);

    int cp_min_z, cp_alpha;
    int **cp_MT;
    
    MA = new int*[N];
    for (int r = 0; r < N; ++r) MA[r] = new int[N];

    // set MAXIMUM value of threads to 4
    omp_set_num_threads(4);

// default(shared) means all variables w/o scope will be shared
#pragma omp parallel default(shared) private(tid, cp_alpha, cp_min_z, cp_MT)
    {
        tid = omp_get_thread_num();

#pragma omp critical(io)
        std::cout << "Thread " << tid << " started" << std::endl;

        switch (tid) {
            case 0:
                // Input alpha and MT on thread 1
                alpha = util::get_scalar();
                MT = util::get_matrix(N, N);
                break;
            case 2:
                // Input Z and MO on thread 3
                Z = util::get_vector(N);
                MO = util::get_matrix(N, N);
                break;
            case 3:
                // Input MR on thread 4
                MR = util::get_matrix(N, N);
                break;
            default:
                break;  // noop
        }

// Wait for input finished
#pragma omp barrier

#pragma omp single
        {
            min_z = Z[0];
        }

// Available for OpenMP 3.1 and 4.0. Should work with gcc >= 4.7 
// Let OpenMP decide how to parallel min reduction
#pragma omp for reduction(min: min_z)
        for (int i = 0; i < N; ++i) {
            if (Z[i] < min_z) min_z = Z[i]; 
        }

// If above code not compiling assume doing that in old-fashioned way
// #pragma omp single
//         min_z = Z[0];
// #pragma omp for
//         for(int i = 0; i < N; ++i) {
// #pragma omp critical(find_min)
//             {
//                 if (Z[i] < min_z) min_z = Z[i];
//             }
// #pragma omp barrier

        // copy min_z
        omp_set_lock(&lock_min_z);
        cp_min_z = min_z;
        omp_unset_lock(&lock_min_z);


// May fail at compile time with Visual Studio C++ compiler
// as it does not support atomic directives
#pragma omp atomic read
        cp_alpha = alpha;

#pragma omp critical(copy_MR)
        {
            cp_MT = util::copy_matrix(MT, N, N);
        }

        for (int i = 0; i < N; ++i) {
// Let OpenMP to chose chunk size
#pragma omp for
            for (int j = 0; j < N; ++j) {
                MA[i][j] = cp_min_z * MO[i][j];
                for (int k = 0; k < N; ++k) {
                    MA[i][j] += cp_alpha * cp_MT[i][k] * MR[k][j];
                }
            }
        }

// Wait all threads to finish computations
#pragma omp barrier

        if (tid == 0) {
#pragma omp critical(io)
            {
                if (N < 9) {
                    std::cout << util::str(MA, N, N) << std::endl;     
                }
            }
        }

        //cleanup
        for (int i = 0; i < N; ++i) {
            delete[] cp_MT[i];
        }
        delete[] cp_MT;

#pragma omp critical(io)
        std::cout << "Thread " << tid << " finished" << std::endl;
    }  // pragma omp parallel

    // final cleanup;
    for (int i = 0; i < N; ++i) {
        delete[] MO[i];
        delete[] MT[i];
        delete[] MR[i];
        delete[] MA[i];
    }
    delete[] Z;
    delete[] MO;
    delete[] MT;
    delete[] MR;
    delete[] MA;

    std::cout << "lab 04 finished" << std::endl; 
}
