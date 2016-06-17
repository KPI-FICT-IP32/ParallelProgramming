using System;
using System.Text;


namespace _03_csharp {
    class TaskDefinition {
        public static void thread1() {
            Console.WriteLine("thread 1 started");

            // Input B, MK
            Storage.B = Util.generateVector(Lab3.N);
            Storage.MK = Util.generateMatrix(Lab3.N);

            // Signal other threads about B, MK input finished
            Lab3.evtT1InputFinished.Set();

            // Wait for T4 to finish input
            Lab3.evtT4InputFinished.WaitOne();

            // Copy shared data
            int[] C1;
            int[][] MO1;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C1 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C1 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO1 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = 0; i < Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C1[j] * MO1[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: 0, length: Lab3.H);

            // Wait T2 to finish sorting
            Lab3.semT2SortFinished.WaitOne();
            Util.merge_(Storage.A, 0, Lab3.H, 2 * Lab3.H);

            // Wait T3 to finish sorting
            Lab3.semT3SortFinished.WaitOne();
            Util.merge_(Storage.A, 0, 2 * Lab3.H, 3 * Lab3.H);

            // Wait T4 to finish sorting
            Lab3.semT4SortFinished.WaitOne();
            Util.merge_(Storage.A, 0, 3 * Lab3.H, Lab3.N);

            StringBuilder sb = new StringBuilder("Result: [");
            foreach (int i in Storage.A) { sb.Append(" " + i + " "); }
            sb.Append(']');

            if (Lab3.N < 16) { Console.WriteLine(sb.ToString()); }
            Console.WriteLine("thread 1 finished");
        }

        public static void thread2() {
            Console.WriteLine("thread 2 started");

            // Wait for T1 and T4 to finish input
            Lab3.evtT1InputFinished.WaitOne();
            Lab3.evtT4InputFinished.WaitOne();

            // Copy shared data
            int[] C2;
            int[][] MO2;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C2 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C2 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO2 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = Lab3.H; i < 2 * Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C2[j] * MO2[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: Lab3.H, length: Lab3.H);
            Lab3.semT2SortFinished.Release();

            Console.WriteLine("thread 2 finished");
        }

        public static void thread3() {
            Console.WriteLine("thread 3 started");

            // Wait for T1 and T4 to finish input
            Lab3.evtT1InputFinished.WaitOne();
            Lab3.evtT4InputFinished.WaitOne();

            // Copy shared data
            int[] C3;
            int[][] MO3;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C3 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C3 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO3 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = 2 * Lab3.H; i < 3 * Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C3[j] * MO3[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: 2 * Lab3.H, length: Lab3.H);
            Lab3.semT3SortFinished.Release();

            Console.WriteLine("thread 3 finished");
        }

        public static void thread4() {
            Console.WriteLine("thread 4 started");

            // Input C, MO, alpha
            Storage.C = Util.generateVector(Lab3.N);
            Storage.MO = Util.generateMatrix(Lab3.N);
            Storage.alpha = 1;

            // Signal other threads about B, MK input finished
            Lab3.evtT4InputFinished.Set();

            // Wait for T4 to finish input
            Lab3.evtT1InputFinished.WaitOne();

            // Copy shared data
            int[] C4;
            int[][] MO4;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C4 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C4 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO4 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = 3 * Lab3.H; i < 4 * Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C4[j] * MO4[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: 3 * Lab3.H, length: Lab3.H);

            // Wait T5 to finish sorting
            Lab3.semT5SortFinished.WaitOne();
            Util.merge_(Storage.A, 3 * Lab3.H, 4 * Lab3.H, 5 * Lab3.H);

            // Wait T6 to finish sorting
            Lab3.semT6SortFinished.WaitOne();
            Util.merge_(Storage.A, 3 * Lab3.H, 5 * Lab3.H, 6 * Lab3.H);

            Lab3.semT4SortFinished.Release();

            Console.WriteLine("thread 4 finished");
        }

        public static void thread5() {
            Console.WriteLine("thread 5 started");

            // Wait for T1 and T4 to finish input
            Lab3.evtT1InputFinished.WaitOne();
            Lab3.evtT4InputFinished.WaitOne();

            // Copy shared data
            int[] C5;
            int[][] MO5;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C5 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C5 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO5 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = 4 * Lab3.H; i < 5 * Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C5[j] * MO5[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: 4 * Lab3.H, length: Lab3.H);
            Lab3.semT5SortFinished.Release();

            Console.WriteLine("thread 5 finished");
        }

        public static void thread6() {
            Console.WriteLine("thread 6 started");

            // Wait for T1 and T4 to finish input
            Lab3.evtT1InputFinished.WaitOne();
            Lab3.evtT4InputFinished.WaitOne();

            // Copy shared data
            int[] C6;
            int[][] MO6;

            // The following is the syntaxic sugar for
            // try {
            //     Monitor.Enter(Storage.C);
            //     C6 = Util.copyVector(Storage.C);
            // } finally { Monitor.Exit(Storage.C); }
            lock (Storage.C) { C6 = Util.copyVector(Storage.C); }

            Lab3.mtxCopyMO.WaitOne();
            MO6 = Util.copyMatrix(Storage.MO);
            Lab3.mtxCopyMO.ReleaseMutex();

            // Compute
            for (int i = 5 * Lab3.H; i < 6 * Lab3.H; ++i) {
                Storage.A[i] = 0;
                for (int j = 0; j < Lab3.N; ++j) {
                    for (int k = 0; k < Lab3.N; ++k) {
                        Storage.A[i] += C6[j] * MO6[j][k] * Storage.MK[k][i];
                    }
                }
                Storage.A[i] += Storage.alpha * Storage.B[i];
            }

            Array.Sort(Storage.A, index: 5 * Lab3.H, length: Lab3.H);
            Lab3.semT6SortFinished.Release();

            Console.WriteLine("thread 6 finished");
        }
    }
}
