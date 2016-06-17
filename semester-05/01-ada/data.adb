with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

package body Data is
  
  procedure Fill(filler: in Integer; mtrx: out Matrix) is
  begin
    for r in mtrx'range(1) loop
      for c in mtrx'range(2) loop
        mtrx(r, c) := filler;
      end loop;
    end loop;
  end;

  procedure Fill(filler: in Integer; vec: out Vector) is
  begin
    for i in vec'range(1) loop
      vec(i) := filler;
    end loop;
  end;

  function "*"(left, right : in Matrix) return Matrix is
    temp : Matrix;
  begin
    Fill(0, temp);
    for i in left'range(1) loop
      for j in right'range(2) loop
        for k in left'range(2) loop
          temp(i, j) := temp(i, j) + left(i, k) * right(k, j);
        end loop;
      end loop;
    end loop;
    return temp;
  end "*";

  function "*"(left : in Vector; right : in Matrix) return Vector is
    temp : Vector;
    helper : Matrix;
  begin
    Fill(0, helper);
    for i in left'range(1) loop
      helper(1, i) := left(i);
    end loop;
    helper := helper * right;
    for i in temp'range(1) loop
      temp(i) := helper(1, i);
    end loop;
    return temp;
  end "*";

  function "*"(left : in Matrix; right : in Vector) return Vector is
    temp : Vector;
    helper : Matrix;
  begin
    Fill(0, helper);
    for i in right'range(1) loop
      helper(i, 1) := right(i);
    end loop;
    helper := left * helper;
    for i in temp'range(1) loop
      temp(i) := helper(i, 1);
    end loop;
    return temp;
  end "*";
  
  function "+"(left, right : in Vector) return Vector is
    temp: Vector;
  begin
    for i in temp'range(1) loop
      temp(i) := left(i) + right(i);
    end loop;
    return temp;
  end;

  function "-"(left, right : in Vector) return Vector is
    temp: Vector;
  begin
    for i in temp'range(1) loop
      temp(i) := left(i) - right(i);
    end loop;
    return temp;
  end;


  function Min(mtrx: in Matrix) return Integer is
    min : Integer;
  begin
    min := mtrx(1, 1);
    for row in mtrx'range(1) loop
      for col in mtrx'range(2) loop
        if min > mtrx(row, col) then
          min := mtrx(row, col);
        end if;
      end loop;
    end loop;
    return min;
  end;

  function Func1(A, B: in Vector; MA, MD: in Matrix) return Vector is 
  begin
    return A - B * (MA * MD);
  end;

  function Func2(MK, MM: in Matrix) return Integer is 
  begin
    return Min(MK * MM);
  end;

  function Func3(MS, MZ: in Matrix; W, X: in Vector) return Vector is
  begin
    return (MS * MZ) * (W + X);
  end;

  procedure GetMatrix(mtrx: out Matrix) is
  begin
    Fill(1, mtrx);
  end;
  
  procedure GetVector(vec: out Vector) is
  begin
    Fill(1, vec);
  end;

  procedure Put(value: in Matrix) is
  begin
    for row in value'range(1) loop
      for col in value'range(2) loop
        Put(value(row, col), 4);
      end loop;
      New_Line;
    end loop;
  end;

  procedure Put(value: in Vector) is
  begin
    for i in value'range(1) loop
      Put(value(i), 4);
    end loop;
  end;

end Data;

