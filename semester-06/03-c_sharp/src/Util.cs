using System;

namespace _03_csharp {
    class Util {
        public static int[] generateVector(int size, int filler = 1) {
            int[] result = new int[size];
            for (int i = 0; i < size; ++i) {
                result[i] = filler;
            }
            return result;
        }

        public static int[][] generateMatrix(int size, int filler = 1) {
            int[][] result = new int[size][];
            for (int r = 0; r < size; ++r) {
                result[r] = generateVector(size, filler);
            }
            return result;
        }

        // _ means function has a side-effect
        public static void merge_(int[] arr, int start, int middle, int end){
            int[] first = new int[middle - start];
            int[] second = new int[end - middle];
            int fptr = 0, sptr = 0, rptr = start;


            Array.Copy(arr, start, first, 0, middle - start);
            Array.Copy(arr, middle, second, 0, end - middle);

            while (rptr < end) {
                if (fptr == first.Length) {
                    Array.Copy(second, sptr, arr, rptr, end - rptr);
                    break;
                }

                if (sptr == second.Length) {
                    Array.Copy(first, fptr, arr, rptr, end - rptr);
                    break;
                }

                arr[rptr++] = first[fptr] <= second[sptr] ? first[fptr++] : second[sptr++];
            }
        }

        public static int[] copyVector(int[] original) {
            int[] copy = new int[original.Length];
            Array.Copy(original, copy, original.Length);
            return copy;
        }

        public static int[][] copyMatrix(int[][] original) {
            int[][] copy = new int[original.Length][];
            for (int r = 0; r < original.Length; ++r) {
                copy[r] = copyVector(original[r]);
            }
            return copy;
        }
    }
}
