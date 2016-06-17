#ifndef UTIL_H
#define UTIL_H


#include <string>


namespace util {
    int *get_vector(int);
    int **get_matrix(int, int);
    int **copy_matrix(int**, int, int);
    int get_scalar(); 

    std::string str(int**, int, int);
}

#endif  // UTIL_H
