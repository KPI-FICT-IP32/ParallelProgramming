generic
    N : Integer;
    P : Integer;
package Data is
    -- Size of partition
    H : Integer := N / P;

    type Vector is array (1 .. N) of Integer;
    type Matrix is array (1 .. N) of Vector;

    procedure get_matrix(m : out Matrix);
    procedure get_vector(v : out Vector);

    procedure put(v: in Vector);
end Data;
