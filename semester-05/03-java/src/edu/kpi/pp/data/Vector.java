package edu.kpi.pp.data;


import edu.kpi.pp.data.Matrix;


public class Vector {

  public static double[] ones(int size) {
    double[] vector = new double[size];
    for (int i = 0; i < size; i++)
      vector[i] = 1;
    return vector;
  }

  // return a random m-by-n matrix with values between 0 and 1
  public static double[] random(int size) {
    double[] vector = new double[size];
    for (int i = 0; i < size; i++)
      vector[i] = Math.random();
    return vector;
  }

  // return C = A + B
  public static double[] add(double[] left, double[] right) {
    double[] result = new double[left.length];
    for (int i = 0; i < left.length; i++) {
      result[i] = left[i] + right[i];
    }
    return result;
  }

  // return C = A - B
  public static double[] substract(double[] left, double[] right) {
    double[] result = new double[left.length];
    for (int i = 0; i < left.length; i++) {
      result[i] = left[i] - right[i];
    }
    return result;
  }

  // matrix-vector multiplication (y = A * x)
  public static double[] multiply(double[][] left, double[] right) {
    return Matrix.multiply(left, right);
  }

  // vector-matrix multiplication (y = x^T A)
  public static double[] multiply(double[] left, double[][] right) {
    return Matrix.multiply(left, right);
  }

  public static String toString(double[] vector) {
    StringBuffer sb = new StringBuffer();
    for (double value: vector) {
      sb.append(String.format("%10.2f,", value));
    }
    sb.append('\n');
    return sb.toString();
  }

}
