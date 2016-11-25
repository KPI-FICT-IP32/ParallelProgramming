package edu.kpi.pp;

import edu.kpi.pp.threading.TaskThreadGenerator;

/**
 * Parallel programming
 * Lab 3
 *
 * Functions:
 * F1: C := A - B * (MA * MD)
 * F2: o := Min(MK * MM)
 * F3: T := (MS * MZ) * (W + X)
 *
 * @since 2015-10-04
 * @author Olexandr Kovalchuk
 * IP-32
 *
 */
public class Lab3 {
  public static void main(String[] args) throws InterruptedException {
    int size = 4;
    if (args.length > 0) {
      size = Integer.parseInt(args[0]);
    }

    System.out.println("Lab3 started");
    
    Thread[] threads = new Thread[3];
    threads[0] = TaskThreadGenerator.getThread(TaskThreadGenerator.TASK_FUNCTION_1, size);
    threads[1] = TaskThreadGenerator.getThread(TaskThreadGenerator.TASK_FUNCTION_2, size);
    threads[2] = TaskThreadGenerator.getThread(TaskThreadGenerator.TASK_FUNCTION_3, size);

    for (Thread t : threads) {
      t.start();
    }

    for (Thread t : threads) {
      try {
        t.join();
      } catch (InterruptedException ie) {
        System.out.println("Error while joining " + t);
      }
    }

    System.out.println("Lab3 finished");
  }
}

