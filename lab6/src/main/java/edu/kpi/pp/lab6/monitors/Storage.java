package edu.kpi.pp.lab6.monitors;


public class Storage {
    int a, b;
    int[] T;
    int[][] MO;

    public synchronized void set_a_b(int[] Z) { a = b = Z[0]; }
    public synchronized void setT(int[] T) { this.T = T; }
    public synchronized void setMO(int[][] MO) { this.MO = MO; }

    public synchronized int copy_a() {return a;}
    public synchronized int copy_b() {return b;}
    public synchronized int[] copyT() {
        int[] newT = new int[T.length];
        System.arraycopy(T, 0, newT, 0, T.length);
        return newT;
    }
    public synchronized int[][] copyMO() {
        int[][] newMO = new int[MO.length][];
        for (int i = 0; i < newMO.length; ++i) {
            newMO[i] = new int[MO[i].length];
            System.arraycopy(MO[i], 0, newMO[i], 0, MO.length);
        }
        return newMO;
    }

    public int update_a(int new_a) {
        if (new_a < this.a) {
            this.a = new_a;
        }
        return this.a;
    }

    public int update_b(int new_b) {
        if (new_b < this.b) {
            this.b = new_b;
        }
        return this.b;
    }
}
