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
  class Vector {

    public static int[] GenerateVector(int size, int filler = 1) {
      int[] result = new int[size];
      for (int i = 0; i < size; ++i) {
        result[i] = filler;
      }
      return result;
    }

    public static int[] Multiply(int[,] left, int[] right) {
      Debug.Assert(left.GetLength(0) > 0);
      Debug.Assert(right.Length > 0);
      Debug.Assert(right.Length == left.GetLength(1));

      int[] result = new int[left.GetLength(0)];
      for (int i = 0; i < left.GetLength(0); ++i) {
        for (int j = 0; j < right.Length; ++j) {
          result[i] += left[i,j] * right[j];
        }
      }
      return result;
    }

    public static int[] Multiply(int[] left, int[,] right) {
      Debug.Assert(left.Length > 0);
      Debug.Assert(right.GetLength(0) > 0);
      Debug.Assert(left.Length == right.GetLength(1));

      int[] result = new int[left.Length];
      for (int i = 0; i < right.GetLength(1); ++i) {
        for (int j = 0; j < right.GetLength(0); ++j) {
          result[i] += right[i,j] * left[j];
        }
      }
      return result;
    }

    public static int[] Add(int[] left, int[] right) {
      Debug.Assert(left.Length > 0);
      Debug.Assert(left.Length == right.Length);

      int[] result = new int[left.Length];
      for (int i = 0; i < result.Length; ++i) {
        result[i] = left[i] + right[i];
      }
      return result;
    }

    public static int[] Substract(int[] left, int[] right) {
      Debug.Assert(left.Length > 0);
      Debug.Assert(left.Length == right.Length);

      int[] result = new int[left.Length];
      for (int i = 0; i < result.Length; ++i) {
        result[i] = left[i] - right[i];
      }

      return result;
    }

  }
}
