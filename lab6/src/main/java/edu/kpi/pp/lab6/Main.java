package edu.kpi.pp.lab6;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by oleksandr on 5/17/16.
 */
public class Main {
    public static void main(String[] args) {
        ExecutorService s = Executors.newFixedThreadPool(MyThread.P);
        for (int i = 0; i < MyThread.P; i++) {
            s.execute(new MyThread(i));
        }
        s.shutdown();
    }
}
