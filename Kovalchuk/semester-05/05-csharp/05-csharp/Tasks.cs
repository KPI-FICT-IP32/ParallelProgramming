using System;
using System.Text;
using System.Diagnostics;
using System.Threading;

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
  class Tasks {
    public static void Task1(Object sz) {
      Debug.Assert(sz is int);
      int size = (int)sz;

      Console.WriteLine(
        "task 1 started on the thread {0}", 
        Thread.CurrentThread.ManagedThreadId
      );

      Thread.Sleep(200);

      int[] a = Vector.GenerateVector(size);
      int[] b = Vector.GenerateVector(size);
      int[,] ma = Matrix.GenerateMatrix(size);
      int[,] md = Matrix.GenerateMatrix(size);

      int[] result = Functions.Func1(a, b, ma, md);
      if (size < 8) {
        StringBuilder sb = new StringBuilder();
        sb.Append("task 1: [");
        for (int i = 0; i < result.Length; ++i) {
          sb.Append(result[i]).Append(",");
        }
        sb.Append("];");
        Console.WriteLine(sb.ToString());
      }

      Console.WriteLine("task 1 finished");

    }

    public static void Task2(Object sz) {
      Debug.Assert(sz is int);
      int size = (int)sz;

      Console.WriteLine(
        "task 2 started on the thread {0}",
        Thread.CurrentThread.ManagedThreadId
      );

      Thread.Sleep(200);

      int[,] mk = Matrix.GenerateMatrix(size);
      int[,] mn = Matrix.GenerateMatrix(size);

      int result = Functions.Func2(mk, mn);
      if (size < 8) {
        Console.WriteLine("task 2: {0}", result);
      }

      Console.WriteLine("task 2 finished");
    }

    public static void Task3(Object sz) {
      Debug.Assert(sz is int);
      int size = (int)sz;

      Console.WriteLine(
        "task 3 started on the thread {0}", 
        Thread.CurrentThread.ManagedThreadId
      );

      Thread.Sleep(200);

      int[] w = Vector.GenerateVector(size);
      int[] x = Vector.GenerateVector(size);
      int[,] ms = Matrix.GenerateMatrix(size);
      int[,] mz = Matrix.GenerateMatrix(size);

      int[] result = Functions.Func3(ms, mz, w, x);
      if (size < 8) {
        StringBuilder sb = new StringBuilder();
        sb.Append("task 3: [");
        for (int i = 0; i < result.Length; ++i)
        {
          sb.Append(result[i]).Append(",");
        }
        sb.Append("];");
        Console.WriteLine(sb.ToString());
      }

      Console.WriteLine("task 3 finished");
    }
  }
}
