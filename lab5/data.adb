with Ada.Text_IO, Ada.Integer_Text_IO; 
use  Ada.Text_IO, Ada.Integer_Text_IO;


package body Data is
  
    procedure get_vector(v : out Vector) is
    begin
        -- Generate a vector, filled with ones
        for i in 1 .. N loop
            v(i) := 1;
        end loop;
    end get_vector;

    procedure get_matrix(m : out Matrix) is
    begin
        -- Generate a matrix, filled with ones
        for i in 1 .. N loop
            get_vector(m(i));
        end loop;
    end get_matrix;

    procedure put(v: in Vector) is
    begin
        -- Print vector
        put("[");
        for i in 1 .. N loop
            put(" "); 
            put(v(i), 4);
        end loop;
        put_line(" ]");
    end put;

end Data;
