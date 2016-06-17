package edu.kpi.pp.data;


import edu.kpi.pp.data.Matrix;
import edu.kpi.pp.data.Vector;


public class Functions {
  public static double[] func1(double[] a, double[] b, double[][] ma, double[][] md) {
    return (
      Vector.substract(
        a,
        Vector.multiply(
          b,
          Matrix.multiply(ma, md)
        )
      )
    );
  }

  public static double func2(double[][] mk, double[][] mm) {
    return (
      Matrix.min(
        Matrix.multiply(mk, mm)
      )    
    );
  }

  public static double[] func3(double[][] ms, double[][] mz, double[] w, double[] x) {
    return (
      Matrix.multiply(
        Matrix.multiply(ms, mz),
        Vector.add(w, x)
      )
    );
  }
}
