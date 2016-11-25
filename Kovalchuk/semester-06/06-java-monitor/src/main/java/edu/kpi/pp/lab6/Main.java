package edu.kpi.pp.lab6;

import edu.kpi.pp.lab6.monitors.Orchestrator;
import edu.kpi.pp.lab6.tasks.MyThread;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * PP. Lab6.
 * Java. Monitor
 * A = max(Z) E + min(Z) T (MO MK)
 *
 * @author Oleksandr Kovalchuk
 * @group IP-32
 */
public class Main {
    public static void main(String[] args) {
        final int size = Integer.valueOf(System.getProperty("pp.size", "6"));
        final int p = Integer.valueOf(System.getProperty("pp.processes", "6"));

        Orchestrator orchestrator = new Orchestrator(p);
        ExecutorService s = Executors.newFixedThreadPool(p);
        for (int i = 0; i < p; i++) {
            s.execute(new MyThread(i, size, p, orchestrator));
        }
        s.shutdown();
    }
}
