using System;
using System.Threading;

namespace _03_csharp {

    class Lab3 {

        public static readonly int N = 6;
        public static readonly int P = 6;
        public static readonly int H = N / P;

        public static EventWaitHandle evtT1InputFinished;
        public static EventWaitHandle evtT4InputFinished;

        public static Mutex mtxCopyMO;

        public static Semaphore semT2SortFinished;
        public static Semaphore semT3SortFinished;
        public static Semaphore semT4SortFinished;
        public static Semaphore semT5SortFinished;
        public static Semaphore semT6SortFinished;

        static void Main(string[] args) {
            Console.WriteLine("Lab 3 started");
            // Prepare synchronization objects
            evtT1InputFinished = new EventWaitHandle(initialState: false, mode: EventResetMode.ManualReset);
            evtT4InputFinished = new EventWaitHandle(initialState: false, mode:EventResetMode.ManualReset);

            mtxCopyMO = new Mutex(initiallyOwned: false);

            semT2SortFinished = new Semaphore(initialCount: 0, maximumCount: 1);
            semT3SortFinished = new Semaphore(initialCount: 0, maximumCount: 1);
            semT4SortFinished = new Semaphore(initialCount: 0, maximumCount: 1);
            semT5SortFinished = new Semaphore(initialCount: 0, maximumCount: 1);
            semT6SortFinished = new Semaphore(initialCount: 0, maximumCount: 1);

            // Create threads
            Thread[] threads = new Thread[P];
            threads[0] = new Thread(TaskDefinition.thread1);
            threads[1] = new Thread(TaskDefinition.thread2);
            threads[2] = new Thread(TaskDefinition.thread3);
            threads[3] = new Thread(TaskDefinition.thread4);
            threads[4] = new Thread(TaskDefinition.thread5);
            threads[5] = new Thread(TaskDefinition.thread6);

            // Run threads
            foreach (Thread t in threads) { t.Start(); }

            // Wait threads to finish
            foreach (Thread t in threads) { t.Join(); }

            Console.WriteLine("Lab 3 finished");
            Console.ReadKey();
        }
    }
}
