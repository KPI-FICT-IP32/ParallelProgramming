#include "util.h"


int *util::get_vector(int size) {
    int *v = new int[size];
    for (int i = 0; i < size; ++i) v[i] = 1;
    return v;
}


int **util::get_matrix(int rows, int cols) {
    int **m = new int*[rows];
    for (int r = 0; r < rows; ++r) m[r] = get_vector(cols);
    return m;
}


int **util::copy_matrix(int **matrix, int rows, int cols) {
    int **cp = new int*[rows];
    for (int r = 0; r < rows; ++r) {
        cp[r] = new int[cols];
        for (int c = 0; c < cols; ++c) cp[r][c] = matrix[r][c];
    }
    return cp;
}


int util::get_scalar() {return 1;}



std::string util::str(int **matrix, int rows, int cols) {
    std::string s = "[\n";
    for (int r = 0; r < rows; ++r) {
        s.append("  [ ");
        for (int c = 0; c < cols; ++c) {
            s.append(" ").append(std::to_string(matrix[r][c])).append(" ");
        }
        s.append(" ]\n");
    }
    s.append("]");
    return s;
}
