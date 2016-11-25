using System;
using System.Collections.Generic;
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
  class Program {
    static void Main(string[] args) {

      Console.WriteLine("Lab 5 started");

      int threadNum;
      int size;

      {
        var arguments = new Dictionary<string, string>();
        foreach (string argument in args) {
          string[] splitted = argument.Split('=');
          if (splitted.Length == 2) {
            arguments[splitted[0]] = splitted[1];
          }
        }

        try {
          threadNum = int.Parse(arguments["threads"]);
        } catch (Exception e) { threadNum = 3; }

        try {
          size = int.Parse(arguments["size"]);
        } catch (Exception e) { size = 4; }
      }

      List<Thread> threads = new List<Thread>();
      for (int i = 0; i < threadNum; ++i) {
        Thread thrd;
        switch (i % 3) {
          case 0:
            thrd = new Thread(Tasks.Task1);
            break;
          case 1:
            thrd = new Thread(Tasks.Task2);
            break;
          default: case 2:
            thrd = new Thread(Tasks.Task3);
            break;
        }
        threads.Add(thrd);
      }

      foreach (Thread t in threads) {
        t.Start(size);
      }

      foreach(Thread t in threads) {
        t.Join();
      }

      Console.WriteLine("Lab 5 finished");
      Console.ReadKey();
    }
  }
}
