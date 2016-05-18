package edu.kpi.pp.lab6.monitors;

/**
 * Created by oleksandr on 5/18/16.
 */
public class Orchestrator {
    private final int _p;
    public Orchestrator(int p) {
        this._p = p;
    }

    private int input_finished = 0;
    private boolean min_max_finished = false;
    private int calc_finished = 0;

    public synchronized void waitInput() {
        try {
            while (input_finished < 3) wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public synchronized void waitMinMax() {
        try {
            while (!min_max_finished) wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public synchronized void waitCaclFinished() {
        try {
            while (calc_finished < _p) wait();
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public synchronized void notifyInput() { input_finished++; notifyAll(); }
    public synchronized void notifyMinMax() { min_max_finished = true; notifyAll();}
    public synchronized void notifyCacl() {calc_finished++; notifyAll();}
}
