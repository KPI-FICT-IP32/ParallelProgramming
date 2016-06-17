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
        Put(',');
      end loop;
      New_Line;
    end loop;
  end;

  procedure Put(value: in Vector) is
  begin
    for i in value'range(1) loop
      Put(value(i), 4);
      Put(',');
    end loop;
  end;

end Data;

