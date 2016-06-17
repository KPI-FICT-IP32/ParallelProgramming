package edu.kpi.pp.coursework.forkjoin;

import java.util.Arrays;
import java.util.concurrent.RecursiveAction;

import static java.lang.System.arraycopy;

public class MergeSortTask extends RecursiveAction {
    private int[] arr;
    private int start, end;
    private int threshold;

    public MergeSortTask(int[] arr, int start, int end, int threshold) {
        this.arr = arr;
        this.start = start;
        this.end = end;
        this.threshold = threshold;
    }

    @Override
    protected void compute() {
        if (end - start <= threshold) {
            // sequential sort
            Arrays.sort(arr, start, end);
            return;
        }

        // Sort halves in parallel
        int mid = start + (end-start) / 2;
        invokeAll(
            new MergeSortTask(arr, start, mid, threshold),
            new MergeSortTask(arr, mid, end, threshold)
        );

        // sequential merge
        merge(arr, start, end, mid);
    }

    private static void merge(int[] array, int start, int end, int mid) {
        int[] resulting = new int[end - start];

        int idx1 = start;
        int idx2 = mid;
        int idx = 0;

        while (idx < resulting.length) {
            if (idx1 == mid) {
                arraycopy(array, idx2, resulting, idx, end - idx2);
                break;
            } else if (idx2 == end) {
                arraycopy(array, idx1, resulting, idx, mid - idx1);
                break;
            } else {
                resulting[idx++] = array[idx1] <= array[idx2] ? array[idx1++] : array[idx2++];
            }
        }

        arraycopy(resulting, 0, array, start, resulting.length);
    }
}