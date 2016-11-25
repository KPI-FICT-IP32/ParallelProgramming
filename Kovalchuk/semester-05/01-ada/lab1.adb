------------------------------------
--      Parallel programming      --
--             Lab 1              --
--                                --
-- Func1: C = A - B * (MA * MD)   --
-- Func2: o = Min(MK * MM)        --
-- Func3: T = (MS * MZ) * (W + X) --
--                                --
-- @author Olexandr Kovalchuk     --
-- @group IP 32                   --
--                                --
-- @date 2015-09-23               --
------------------------------------

with Data; 
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Lab1 is
  package Data3 is new Data(SIZE => 3); use Data3;
  MA, MD, MK, MM, MS, MZ: Data3.Matrix;
  C, A, B, W, X, T: Data3.Vector;
  o : Integer;
begin
  -- Generating dummy data
  GetMatrix(MA);
  GetMatrix(MD);
  GetMatrix(MK);
  GetMatrix(MM);
  GetMatrix(MS);
  GetMatrix(MZ);

  GetVector(A);
  GetVector(B);
  GetVector(W);
  GetVector(X);

  -- Do calc
  C := Func1(A, B, MA, MD);
  o := Func2(MK, MM);
  T := Func3(MS, MZ, W, X);

  -- Print results
  Put("C = A - B * (MA * MD) = ("); Put(C); Put_Line(")");
  Put("o = Min(MK * MM) = "); Put(o, 2); New_Line;
  Put("T = (MS * MZ) * (W + X) = ("); Put(T); Put_Line(")");
end Lab1;

