package edu.kpi.pp.threading;


import edu.kpi.pp.data.Vector;
import edu.kpi.pp.data.Matrix;
import edu.kpi.pp.data.Functions;


class TaskBase {

  protected final int size;

  TaskBase(int size) {
    this.size = size; 
  }

  protected void sleep(long millis) {
    try {
      Thread.sleep(millis);
    } catch (InterruptedException ie) {
      throw new RuntimeException("Error in thread: " + ie.getMessage());
    }
  }
}

class Task1 extends TaskBase implements Runnable {

  public Task1(int size) {
    super(size);
  }

  @Override  
  public void run() {
    System.out.println("Task1 started");
    this.sleep(500);

    double[] a, b, c;
    double[][] ma, md;

    a = Vector.ones(this.size);
    b = Vector.ones(this.size);

    ma = Matrix.ones(this.size);
    md = Matrix.ones(this.size);

    c = Functions.func1(a, b, ma, md);

    if (this.size < 8) {
      System.out.print(
        Vector.toString(c)
      );
    }

    System.out.println("Task1 finished");
  }
}

class Task2 extends TaskBase implements Runnable {

  public Task2(int size) {
    super(size);
  }

  @Override  
  public void run() {    
    System.out.println("Task2 started");
    this.sleep(500);

    double[][] mk, mm;
    double o;

    mk = Matrix.ones(this.size);
    mm = Matrix.ones(this.size);

    o = Functions.func2(mk, mm);

    if (this.size < 8) {
      System.out.printf("%10.2f%n", o);
    }

    System.out.println("Task2 finished");
  }
}

class Task3 extends TaskBase implements Runnable {

  public Task3(int size) {
    super(size);
  }

  @Override  
  public void run() {    
    System.out.println("Task3 started");
    this.sleep(500);

    double[] w, x, t;
    double[][] ms, mz;

    w = Vector.ones(this.size);
    x = Vector.ones(this.size);

    ms = Matrix.ones(this.size);
    mz = Matrix.ones(this.size);

    t = Functions.func3(ms, mz, w, x);

    if (this.size < 8) {
      System.out.print(
        Vector.toString(t)
      );
    }

    System.out.println("Task3 finished");
  }
}




