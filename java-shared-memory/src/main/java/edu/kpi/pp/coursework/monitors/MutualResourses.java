package edu.kpi.pp.coursework.monitors;

public class MutualResourses {
    private int[][] mo, mu, mk;
    private int[] va, ve, vz;
    private int alpha;

    public synchronized void setMo(int[][] mo) {this.mo = mo;}
    public synchronized void setMk(int[][] mk) {this.mk = mk;}
    public synchronized void setMu(int[][] mu) {this.mu = mu;}
    public synchronized void setVa(int[] va) {this.va = va;}
    public synchronized void setVe(int[] ve) {this.ve = ve;}
    public synchronized void setVz(int[] vz) {this.vz = vz;}
    public synchronized void setAlpha(int alpha) {this.alpha = alpha;}

    public synchronized int[] copyZ() {
        int[] newZ = new int[vz.length];
        System.arraycopy(vz, 0, newZ, 0, vz.length);
        return newZ;
    }

    public synchronized int[][] copyMO() {
        int[][] newMo = new int[mo.length][];
        for (int i = 0; i < mo.length; ++i) {
            newMo[i] = new int[mo[i].length];
            System.arraycopy(mo[i], 0, newMo[i], 0, mo[i].length);
        }
        return newMo;
    }

    public synchronized int[] copyE() {
        int[] newE = new int[vz.length];
        System.arraycopy(vz, 0, newE, 0, vz.length);
        return newE;
    }

    public int[] getZ() { return vz; }
    public int[][] getMU() {return mu;}
    public int[][] getMK() {return mk;}
    public int[] getA() {return va;}
    public int[] getE() {return ve;}

    public synchronized int copyAlpha() {return alpha;}
}
