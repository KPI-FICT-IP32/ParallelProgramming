package edu.kpi.pp.data;


public class Matrix {

  public static double[][] ones(int size) {
    return Matrix.ones(size, size);
  }

  public static double[][] ones(int rows, int cols) {
    double[][] matrix = new double[rows][cols];
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < cols; c++)
        matrix[r][c] = 1;
    return matrix;
  }

  // return a random m-by-n matrix with values between 0 and 1
  public static double[][] random(int rows, int columns) {
    double[][] matrix = new double[rows][columns];
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < columns; c++)
        matrix[r][c] = Math.random();
    return matrix;
  }

  // return n-by-n identity matrix I
  public static double[][] identity(int size) {
    double[][] identityMatrix = new double[size][size];
    for (int i = 0; i < size; i++)
      identityMatrix[i][i] = 1;
    return identityMatrix;
  }

  // return C = A + B
  public static double[][] add(double[][] left, double[][] right) {
    int rows = left.length;
    int cols = left[0].length;
    double[][] result = new double[rows][cols];
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < cols; c++)
        result[r][c] = left[r][c] + right[r][c];
    return result;
  }

  // return C = A - B
  public static double[][] subtract(double[][] left, double[][] right) {
    int rows = left.length;
    int cols = left[0].length;
    double[][] result = new double[rows][cols];
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < cols; c++)
        result[r][c] = left[r][c] - right[r][c];
    return result;
  }

  // return C = A * B
  public static double[][] multiply(double[][] left, double[][] right) {
    int rLeft = left.length;
    int cLeft = left[0].length;
    int rRight = right.length;
    int cRight = right[0].length;
    if (cLeft != rRight) {
      throw new RuntimeException("Illegal matrix dimensions.");
    }
    double[][] result = new double[rLeft][cRight];
    for (int i = 0; i < rLeft; i++)
      for (int j = 0; j < cRight; j++)
        for (int k = 0; k < cLeft; k++)
          result[i][j] += left[i][k] * right[k][j];
    return result;
  }

  // matrix-vector multiplication (y = A * x)
  public static double[] multiply(double[][] left, double[] right) {
    int rows = left.length;
    int cols = left[0].length;
    if (right.length != cols) {
      throw new RuntimeException("Illegal matrix dimensions.");
    }
    double[] result = new double[rows];
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < cols; c++)
        result[r] += left[r][c] * right[c];
    return result;
  }

  // vector-matrix multiplication (y = x^T A)
  public static double[] multiply(double[] left, double[][] right) {
    int rows = right.length;
    int cols = right[0].length;
    if (left.length != rows) {
      throw new RuntimeException("Illegal matrix dimensions.");
    }
    double[] result = new double[cols];
    for (int c = 0; c < cols; c++)
      for (int r = 0; r < rows; r++)
        result[c] += right[r][c] * left[r];
    return result;
  }

  public static double min(double[][] matrix) {
    double min = matrix[0][0];
    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix.length; c++) {
        if (matrix[r][c] < min) {
          min = matrix[r][c];
        }
      }
    }
    return min;
  }

  public static String toString(double[][] matrix) {
    StringBuffer sb = new StringBuffer();
    for (double[] row : matrix) {
      for (double value: row) {
        sb.append(String.format("%10.2f,", value));
      }
      sb.append('\n');
    }
    return sb.toString();
  }

}
