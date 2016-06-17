package edu.kpi.pp.threading;
import edu.kpi.pp.threading.Task1;
import edu.kpi.pp.threading.Task2;
import edu.kpi.pp.threading.Task3;

public class TaskThreadGenerator {
  public static final byte TASK_FUNCTION_1 = 1;
  public static final byte TASK_FUNCTION_2 = 2;
  public static final byte TASK_FUNCTION_3 = 3;

  private TaskThreadGenerator() {
    // Do nothing
  };

  public static Thread getThread(byte taskId, int size) {
    Thread taskThread = null;
    switch (taskId) {
      case TASK_FUNCTION_1:
        taskThread = new Thread(new Task1(size));
        break;
      case TASK_FUNCTION_2:
        taskThread = new Thread(new Task2(size));
        break;
      case TASK_FUNCTION_3:
        taskThread = new Thread(new Task3(size));
        break;
      default:
        throw new RuntimeException("Invalid task id");
    }
    taskThread.setPriority(Thread.NORM_PRIORITY);
    return taskThread;
  }
}
