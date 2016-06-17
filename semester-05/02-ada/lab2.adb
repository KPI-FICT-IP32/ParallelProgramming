------------------------------------
--      Parallel programming      --
--             Lab 2              --
--                                --
-- Func1: C = A - B * (MA * MD)   --
-- Func2: o = Min(MK * MM)        --
-- Func3: T = (MS * MZ) * (W + X) --
--                                --
-- @author Olexandr Kovalchuk     --
-- @group IP 32                   --
--                                --
-- @date 2015-09-27               --
------------------------------------
with Data; 
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Lab2 is
  SIZE: constant Integer := 1000;
  package DataBase is new Data(SIZE => SIZE); use DataBase;

  procedure RunTasks is
    
    task T1 is
      pragma Storage_Size(32*SIZE*(SIZE + 3));
      pragma Priority(7);
      pragma CPU(1);
    end T1;
    task body T1 is
      MA, MD: Matrix;
      A, B, C: Vector;
    begin
      Put_Line("Task T1 started");
      GetMatrix(MA);
      GetMatrix(MD);
      GetVector(A);
      GetVector(B);
      delay 0.25;
      C := Func1(A, B, MA, MD);
      Put("C = A - B * (MA * MD) = ("); Put(C); Put_Line(")");
      Put_Line("Task T1 finished");
    end T1;

    task T2 is
      pragma Storage_Size(32*SIZE*SIZE);
      pragma Priority(4);
      pragma CPU(2);
    end T2;
    task body T2 is
      MK, MM: Matrix;
      o: Integer;
    begin
      Put_Line("Task T2 started");
      GetMatrix(MK);
      GetMatrix(MM);
      o := Func2(MK, MM);
      delay 0.000001;
      Put("o = Min(MK * MM) = "); Put(o, 2); New_Line;
      Put_Line("Task T2 finished");
    end T2;

    task T3 is
      pragma Storage_Size(32*SIZE*(SIZE + 2));
      pragma Priority(6);
      pragma CPU(3);
    end T3;
    task body T3 is
      MS, MZ: Matrix;
      W, X, T: Vector;
    begin
      Put_Line("Task T3 started");
      GetMatrix(MS);
      GetMatrix(MZ);
      GetVector(W);
      GetVector(X);
      delay 0.5;
      T := Func3(MS, MZ, W, X);
      Put("T = (MS * MZ) * (W + X) = ("); Put(T); Put_Line(")");
      Put_Line("Task T3 finished");
    end T3;
  begin
    null;
  end RunTasks;
begin
  Put_Line("Lab2 started");
  RunTasks;
  Put_Line("Lab2 finished");
end Lab2;

