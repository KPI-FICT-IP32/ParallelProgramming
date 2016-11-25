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
  class Functions {
    public static int[] Func1(int[] a, int[] b, int[,] ma, int[,] md) {
      return (
        Vector.Substract(
          a,
          Vector.Multiply(
            b,
            Matrix.Multiply(ma, md)
          )
        )
      );
    }

    public static int Func2(int[,] mk, int[,] mn) {
      return (
        Matrix.Min(
          Matrix.Multiply(mk, mn)
        )
      );
    }

    public static int[] Func3(int[,] ms, int[,] mz, int[] w, int[] x) {
      return (
        Vector.Multiply(
          Matrix.Multiply(ms, mz),
          Vector.Add(w, x)
        )
      );
    }
  }
}
