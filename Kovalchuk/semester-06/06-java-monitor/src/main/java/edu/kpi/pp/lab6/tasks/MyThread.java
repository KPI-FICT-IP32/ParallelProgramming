package edu.kpi.pp.lab6.tasks;


import edu.kpi.pp.lab6.monitors.Orchestrator;
import edu.kpi.pp.lab6.monitors.Storage;

import java.util.concurrent.ForkJoinPool;

public class MyThread extends Thread {
    private static int[] Z;
    private static int[] E;
    private static int[] A;
    private static int[][] MK;

    static final Storage storage = new Storage();

    private final int _rank;
    private final int _size;
    private final int H;
    private final int P;
    private final Orchestrator o;

    public MyThread(int rank, int size, int p, Orchestrator o) {
        this._rank = rank;
        this._size = size;
        this.P = p;
        this.H = _size / P;
        this.o = o;
    }

    @Override
    public void run() {
        switch (_rank) {
            case 0:
                A = new int[_size];
                E = new int[_size];
                Z = new int[_size];
                for (int i = 0; i < _size; ++i) {
                    E[i] = Z[i] = 1;
                }
                storage.set_a_b(Z);
                o.notifyInput();
                break;
            case 2:
                int[] T = new int[_size];
                int[][] MO = new int[_size][_size];
                for (int i = 0; i < _size; ++i) {
                    T[i] = 1;
                    for (int j = 0; j < _size; j++) {
                        MO[i][j] = 1;
                    }
                }
                storage.setT(T);
                storage.setMO(MO);
                o.notifyInput();
                break;
            case 3:
                MK = new int[_size][_size];
                for (int i = 0; i < _size; i++) {
                    for (int j = 0; j < _size; j++) {
                        MK[i][j] = 1;
                    }
                }
                o.notifyInput();
                break;
        }

        o.waitInput();

        if (_rank == 0) {
            ForkJoinPool pool = new ForkJoinPool(P);
            pool.invoke(new MinMaxTask(Z, 0, Z.length, H));
            o.notifyMinMax();
        }

        o.waitMinMax();

        int ai = storage.copy_a();
        int bi = storage.copy_b();
        int[] Ti = storage.copyT();
        int[][] MOi = storage.copyMO();

        for (int i = _rank*H; i < (_rank + 1) *H; ++i) {
            A[i]=0;
            for (int j = 0; j < _size; j++)
                for (int k = 0; k < _size; k++)
                    A[i] += ai *Ti[j] * MOi[j][k] * MK[k][i];
            A[i] += bi * E[i];
        }
        o.notifyCacl();

        if (_rank == 0) {
            o.waitCaclFinished();
            StringBuffer buf = new StringBuffer();
            for (int i : A) {
                buf.append(i).append(' ');
            }
            System.out.println(buf);
        }
    }
}
