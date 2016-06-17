package edu.kpi.pp.coursework;

import edu.kpi.pp.coursework.forkjoin.MergeSortTask;
import edu.kpi.pp.coursework.monitors.MutualResourses;
import edu.kpi.pp.coursework.monitors.Orchestrator;

import java.util.concurrent.ForkJoinPool;


public class MyThread extends Thread {
    private final MutualResourses _mr;
    private final Orchestrator _orchestrator;
    private final int _p;
    private final int _size;
    private final int id;

    public MyThread(int id, MutualResourses mr, Orchestrator o, int processes, int size) {
        this._mr = mr;
        this._orchestrator = o;
        this._p = processes;
        this._size = size;
        this.id = id;
    }

    @Override
    public void run() {
        System.out.printf("[%d] started\n", id);
        if (id == 0) {
            int[] z = new int[_size];
            int[] a = new int[_size];
            int[][] mo = new int[_size][_size];
            int[][] mu = new int[_size][_size];

            for(int i = 0; i < _size; ++i) {
                z[i] = 1;
                for(int j = 0; j < _size; ++j) {
                    mo[i][j] = mu[i][j] = 1;
                };
            }

            _mr.setVa(a);
            _mr.setMo(mo);
            _mr.setMu(mu);
            _mr.setVz(z);
            _orchestrator.notifyIO();
        }
        if (id == _p - 1) {
            int[] e = new int[_size];
            int[][] mk = new int[_size][_size];
            int alpha = 1;
            for (int i = 0; i < _size; ++i) {
                e[i] = 1;
                for (int j = 0; j < _size; ++j) {
                    mk[i][j] = 1;
                }
            }
            _mr.setVe(e);
            _mr.setMk(mk);
            _mr.setAlpha(alpha);
            _orchestrator.notifyIO();
        }

        _orchestrator.waitInput();

        if (id == 0) {
            ForkJoinPool pool = new ForkJoinPool(_p);
            pool.invoke(new MergeSortTask(_mr.getZ(), 0, _mr.getZ().length, _size / _p));

            _orchestrator.notifySort();
        }

        _orchestrator.waitSort();

        int[] z = _mr.copyZ();
        int[] e = _mr.copyE();
        int[][] mo = _mr.copyMO();
        int alpha = _mr.copyAlpha();
        int[][] mk = _mr.getMK();
        int[][] mu = _mr.getMU();
        int[] a = _mr.getA();

        int start = (int)id * (_size / _p);
        int end = (int)(id + 1) * (_size / _p);

        for (int i = start; i < end; ++i) {
            a[i] = 0;
            for (int j = 0; j < a.length; ++j) {
                for (int k = 0; k < a.length; ++k) {
                    a[i] += z[j] * mo[j][k] * mk[k][i];
                }
                a[i] += alpha * e[j] * mu[j][i];
            }
        }

        _orchestrator.notifyCalc();

        if (id == 0) {
            _orchestrator.waitCalc();
            if (_size < 10) {
                StringBuilder buf = new StringBuilder();
                for (int i = 0; i < _size; ++i) {
                    buf.append(a[i]).append(',').append(' ');
                }
                System.out.println(buf.toString());
            }
        }

        System.out.printf("[%d] finished\n", id);
    }
}
