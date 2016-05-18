package edu.kpi.pp.lab6.tasks;

import java.util.concurrent.RecursiveAction;


public class MinMaxTask extends RecursiveAction{
    private final int[] _arr;
    private final int _start;
    private final int _end;
    private final int _threshold;

    MinMaxTask(int[] arr, int start, int end, int threshold) {
        this._arr = arr;
        this._start = start;
        this._end = end;
        this._threshold = threshold;
    }

    protected void compute() {
        int a = _arr[_start];
        int b = _arr[_start];

        if (this._end - this._start <= _threshold) {
            for (int v : _arr) {
                if (v < a) a = v;
                if (v > b) b = v;
            }
            MyThread.storage.update_a(a);
            MyThread.storage.update_b(b);
        }

        int mid = _start + (_end - _start) / 2;

    }
}
