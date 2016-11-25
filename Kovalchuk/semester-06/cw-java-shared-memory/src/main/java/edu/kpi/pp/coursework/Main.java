package edu.kpi.pp.coursework;

import edu.kpi.pp.coursework.monitors.MutualResourses;
import edu.kpi.pp.coursework.monitors.Orchestrator;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class Main {
    public static void main(String[] args) {
        int processors = Runtime.getRuntime().availableProcessors();
        String processes_str = System.getProperty("pp.processes", String.valueOf(processors));
        String size_str = System.getProperty("pp.size", "500");

        int size = Integer.valueOf(size_str);
        int processes = Integer.valueOf(processes_str);

        MutualResourses mr = new MutualResourses();
        Orchestrator o = new Orchestrator(processes);

        ExecutorService s = Executors.newFixedThreadPool(processes);
        for (int i = 0; i < processes; i++) {
            s.execute(new MyThread(i, mr, o, processes, size));
        }
        s.shutdown();

    }
}
