package edu.kpi.pp.coursework.monitors;

public class Orchestrator {
    private int ioFinished;
    private boolean sortFinished;
    private int calcFinished;

    private final int _p;

    public Orchestrator(int p) {
        this._p = p;
    }

    public synchronized void waitInput() {
        try {
            while (ioFinished != 2) { wait(); }
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }

    public synchronized void waitSort() {
        try {
            while (!sortFinished) { wait(); }
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(0);
        }
    }

    public synchronized void waitCalc() {
        try {
            while (calcFinished != _p) {wait();}
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.exit(0);
        }
    }

    public synchronized void notifyIO() {
        this.ioFinished += 1;
        notifyAll();
    }

    public synchronized void notifySort() {
        this.sortFinished = true;
        notifyAll();
    }

    public synchronized void notifyCalc() {
        this.calcFinished += 1;
        notifyAll();
    }

}
