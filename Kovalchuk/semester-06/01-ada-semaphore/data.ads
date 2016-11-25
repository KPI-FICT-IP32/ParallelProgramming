package Data is

    -- Size of vector or matrix dimension
    N : Integer := 4;
    -- Size of half
    H : Integer := N / 2;

    type Vector is array (1 .. N) of Integer;
    type Matrix is array (1 .. N, 1 .. N) of Integer;

    procedure GetMatrix(mtrx: out Matrix);
    procedure GetVector(vec: out Vector);

    procedure Put(value: in Matrix);
    procedure Put(value: in Vector);
end Data;

