using System.Diagnostics;

/**
 * Parallel programming
 * Lab 5
 *
 * Functions:
 * F1: C = A - B * (MA * MD)
 * F2: o = Min(MK * MM)
 * F3: T = (MS * MZ) * (W + X)
 *
 * @since 2015-10-29
 * @author Olexandr Kovalchuk
 * @group IP-32
 */

namespace _05_csharp {
  class Matrix {

    public static int[,] GenerateMatrix(int size, int filler = 1) {
      return GenerateMatrix(size, size, filler);
    }

    public static int[,] GenerateMatrix(int rows, int columns, int filler = 1) {
      int[,] result = new int[rows,columns];
      for (int r = 0; r < rows; ++r) {
        for (int c = 0; c < columns; ++c) {
          result[r, c] = filler;
        }
      }
      return result;
    }

    public static int[,] Multiply(int[,] left, int[,] right) {
      Debug.Assert(left.GetLength(0) > 0);
      Debug.Assert(right.GetLength(0) > 0);
      Debug.Assert(left.GetLength(1) == right.GetLength(0));

      int[,] result = GenerateMatrix(left.GetLength(0), right.GetLength(1), 0);
      for (int i = 0; i < left.GetLength(0); ++i) {
        for (int j = 0; j < right.GetLength(1); ++j) {
          for (int k = 0; k < left.GetLength(1); ++k) {
            result[i,j] += left[i,k] * right[k,j];
          }
        }
      }
      return result;
    }

    public static int Min(int[,] mtrx) {
      int result = mtrx[0,0];
      for (int r = 0; r < mtrx.GetLength(0); ++r) {
        for (int c = 0; c < mtrx.GetLength(1); ++c) {
          if (mtrx[r,c] < result) {
            result = mtrx[r,c];
          }
        }
      }
      return result;
    }
  }
}
