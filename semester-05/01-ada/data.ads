generic
  SIZE : in Natural := 2;
package Data is
  type Vector is private;
  type Matrix is private;
   
  function Func1(A, B: in Vector; MA, MD: in Matrix) return Vector;
  function Func2(MK, MM: in Matrix) return Integer;
  function Func3(MS, MZ: in Matrix; W, X: in Vector) return Vector;

  procedure GetMatrix(mtrx: out Matrix);
  procedure GetVector(vec: out Vector);

  procedure Put(value: in Matrix);
  procedure Put(value: in Vector);

  private
    type Vector is array (1 .. SIZE) of Integer;
    type Matrix is array (1 .. SIZE, 1 .. SIZE) of Integer;
end Data;

