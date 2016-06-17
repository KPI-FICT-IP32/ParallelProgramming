------------------------------------
--      Parallel programming      --
--             lab 7              --
--         Ada. Rendezvous        --
--                                --
-- Task: A = max(Z)*B+e*T*(MO*MK) --
-- @author Olexandr Kovalchuk     --
-- @group IP 32                   --
--                                --
-- @date 2016-05-24               --
------------------------------------
with Ada.Integer_Text_IO, Ada.Text_IO; 
use  Ada.Integer_Text_IO, Ada.Text_IO;


procedure Lab7 is
    N : constant Integer := 9;
    P : constant Integer := 9;
    H : constant Integer := N / P;

-- Declare types
    type Vec is array (Positive range <>) of Integer;
    subtype Vec_1 is Vec(1..H);
    subtype Vec_2 is Vec(1..2*H);
    subtype Vec_3 is Vec(1..3*H);
    subtype Vec_4 is Vec(1..4*H);
    subtype Vec_5 is Vec(1..5*H);
    subtype Vec_6 is Vec(1..6*H);
    subtype Vec_7 is Vec(1..7*H);
    subtype Vec_8 is Vec(1..8*H);
    subtype Vec_9 is Vec(1..9*H);

    -- First dim of matrix is column and the second is row
    type Mtx is array (Positive range <>) of Vec_9;
    subtype Mtx_1 is Mtx(1..H);
    subtype Mtx_2 is Mtx(1..2*H);
    subtype Mtx_3 is Mtx(1..3*H);
    subtype Mtx_5 is Mtx(1..5*H);
    subtype Mtx_7 is Mtx(1..7*H);
    subtype Mtx_8 is Mtx(1..8*H);
    subtype Mtx_9 is Mtx(1..9*H);

-- Declare task bodies
    task TS1 is
        -- INITIAL EXCHANGE
        entry recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

    end TS1;

    task TS2 is
        -- INITIAL EXCHANGE
        entry recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx);
        entry recv_ze(inZ: in Vec; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a(inA: in Vec);
    end TS2;

    task TS3 is
        -- INITIAL EXCHANGE
        entry recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx);
        entry recv_ze(inZ: in Vec; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a(inA: in Vec);
    end TS3;

    task TS4 is
        -- INITIAL EXCHANGE
        entry recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx);
        entry recv_ze(inZ: in Vec; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a_5(inA: in Vec);
        entry recv_a_3(inA: in Vec);
    end TS4;

    task TS5 is
        -- INITIAL EXCHANGE
        entry recv_t_b_z_mo_mk_e(inT, inB, inZ: in Vec; inMO, inMK: in Mtx; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);
    end TS5;

    task TS6 is
        -- INITIAL EXCHANGE
        entry recv_tmo(inT: in Vec; inMO: in Mtx);
        entry recv_bmk(inB: in Vec; inMK: in Mtx);
        entry recv_ze(inZ: in Vec; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a_4(inA: in Vec);
        entry recv_a_9(inA: in Vec);
    end TS6;

    task TS7 is
        -- INITIAL EXCHANGE
        entry recv_tmo(inT: in Vec; inMO: in Mtx);
        entry recv_b_z_mk_e(inB, inZ: in Vec; inMK: in Mtx; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a(inA: in Vec);
    end TS7;

    task TS8 is
        -- INITIAL EXCHANGE
        entry recv_b_z_mk_e(inB, inZ: in Vec; inMK: in Mtx; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);

        -- FINAL EXCHANGE
        entry recv_a(inA: in Vec);
    end TS8;

    task TS9 is
        -- INITIAL EXCHANGE
        entry recv_t_z_mo_e(inT, inZ: in Vec; inMO: in Mtx; ine: in Integer);

        -- MAX EXCHANGE
        entry recv_c(inc: in Integer);
    end TS9;

-- Implement task bodies
    task body TS1 is 
        Z, T: Vec_9; 
        A, B: Vec_1;
        MK: Mtx_1;
        MO: Mtx_9;
        e, c: Integer;
    begin
        Put_Line("TS1 Started");
        -- Input Z, e
        for i in Z'range(1) loop Z(i) := 1; end loop;
        e := 1;
        
        -- Send Z, e
        TS2.recv_ze(Z(H+1 .. Z'length), e);

        -- Recieve B, T, MO, MK
        accept recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx) do
            B := inB; 
            T := inT; 
            MO := inMO; 
            MK := inMK;
        end recv_t_b_mo_mk;

        -- Find partial max
        c := Z(1);
        for i in 2 .. H loop
            if Z(i) > c then 
                c := Z(i);
            end if;
        end loop;

        -- Send partial max (c_H)
        TS2.recv_c(c);

        -- Recieve final max
        accept recv_c(inc: in Integer) do
            c := inc;
        end recv_c;

        -- Calculte A_H
        for i in 1 .. H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        -- Send A_H to TS2
        TS2.recv_a(A);

        Put_Line("TS1 Finished");
    end TS1;

    task body TS2 is 
        Z: Vec_8;
        T: Vec_9;
        A, B: Vec_2;
        MO: Mtx_9; 
        MK: Mtx_2;
        c, e: Integer;
    begin
        Put_Line("TS2 Started");
        
        -- Recieve Z, e from TS1
        accept recv_ze(inZ: in Vec; ine: in Integer) do
            Z := inZ;
            e := ine;
        end recv_ze;

        -- Send Z, e to TS3
        TS3.recv_ze(Z(H+1 .. Z'length), e);

        -- Recieve B, T, MO, MK from TS3
        accept recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx) do
            B := inB; 
            T := inT; 
            MO := inMO; 
            MK := inMK;
        end recv_t_b_mo_mk;

        -- Send B, T, MO, MK to TS1
        TS1.recv_t_b_mo_mk(T, B(1..H), MO, MK(1..H));

        -- Find partial max
        c := Z(1);
        for i in 2 .. H loop
            if Z(i) > c then 
                c := Z(i);
            end if;
        end loop;

        accept recv_c(inc: in Integer) do
            if c < inc then
                c := inc;
            end if;
        end recv_c;

        -- Send partial max (c_H)
        TS3.recv_c(c);

        -- Recieve final max
        accept recv_c(inc: in Integer) do
            if c < inc then
                c := inc;
            end if;
        end recv_c;

        -- Send final max
        TS1.recv_c(c);

        -- Calculte A_H
        for i in H+1 .. 2*H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        accept recv_a(inA: in Vec) do
            A(1..H) := inA;
        end recv_a;

        -- Send A_H to TS3
        TS3.recv_a(A);

        Put_Line("TS2 Finished");
    end TS2;

    task body TS3 is 
        A, B: Vec_3;
        T: Vec_9;
        MK: Mtx_3;
        MO: Mtx_9;
        Z: Vec_7;
        c, e: Integer;
    begin
        Put_Line("TS3 Started");

        -- Recieve Z, e from TS2
        accept recv_ze(inZ: in Vec; ine: in Integer) do
            Z := inZ;
            e := ine;
        end recv_ze;

        -- Send Z, e to TS4
        TS4.recv_ze(Z(H+1 .. Z'length), e);

        -- Recieve B, T, MO, MK from TS4
        accept recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx) do
            B := inB; 
            T := inT; 
            MO := inMO; 
            MK := inMK;
        end recv_t_b_mo_mk;

        -- Send B, T, MO, MK to TS2
        TS2.recv_t_b_mo_mk(T, B(1..2*H), MO, MK(1..2*H));

        -- Find partial max
        c := Z(1);
        for i in 2 .. H loop
            if Z(i) > c then 
                c := Z(i);
            end if;
        end loop;

        accept recv_c(inc: in Integer) do
            if c < inc then
                c := inc;
            end if;
        end recv_c;

        -- Send partial max (c_H)
        TS4.recv_c(c);

        -- Recieve final max
        accept recv_c(inc: in Integer) do
            if c < inc then
                c := inc;
            end if;
        end recv_c;

        -- Send final max
        TS2.recv_c(c);

        -- Calculte A_H
        for i in 2*H+1 .. 3*H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        accept recv_a(inA: in Vec) do
            A(1..2*H) := inA;
        end recv_a;

        -- Send A_H to TS4
        TS4.recv_a_3(A);
        Put_Line("TS3 Finished");
    end TS3;

    task body TS4 is 
        Z: Vec_6;
        A, B: Vec_5;
        T: Vec_9;
        MK: Mtx_5;
        MO: Mtx_9;
        c, e: Integer;
    begin
        Put_Line("TS4 Started");
        for i in 1 .. 2 loop
            select
                accept recv_ze(inZ: in Vec; ine: in Integer) do
                    Z := inZ;
                    e := ine;
                end recv_ze;
            or
                accept recv_t_b_mo_mk(inT, inB: in Vec; inMO, inMK: in Mtx) do
                    B := inB; 
                    T := inT; 
                    MO := inMO; 
                    MK := inMK;
                end recv_t_b_mo_mk;
            end select;
        end loop;

        TS5.recv_t_b_z_mo_mk_e(T, B(4*H+1..5*H), Z(H+1..2*H), MO, MK(4*H+1..5*H), e);
        TS3.recv_t_b_mo_mk(T, B(1..3*H), MO, MK(1..3*H));
        TS6.recv_ze(Z(2*H+1..Z'length), e);

        -- Find partial max
        c := Z(1);
        for i in 2 .. H loop
            if Z(i) > c then 
                c := Z(i);
            end if;
        end loop;

        for i in 1..3 loop
            accept recv_c (inc: in Integer) do
                if c < inc then
                    c := inc;
                end if;
            end recv_c;
        end loop;

        TS3.recv_c(c);
        TS5.recv_c(c);
        TS6.recv_c(c);

        -- Calculte A_H
        for i in 3*H+1 .. 4*H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        for i in 0..1 loop
            select
                accept recv_a_3(inA: in Vec) do
                    A(1..3*H) := inA;
                end recv_a_3;
            or
                accept recv_a_5(inA: in Vec) do
                    A(4*H+1..5*H) := inA;
                end recv_a_5;
            end select;
        end loop;

        TS6.recv_a_4(A);
        Put_Line("TS4 Finished");
    end TS4;

    task body TS5 is 
        T: Vec_9;
        MO: Mtx_9;
        A, Z, B: Vec_1;
        MK: Mtx_1;
        c, e: Integer;
    begin
        Put_Line("TS5 Started");
        
        accept recv_t_b_z_mo_mk_e(inT, inB, inZ: in Vec; inMO, inMK: in Mtx; ine: in Integer) do
            T := inT;
            B := inB;
            Z := inZ;
            MO := inMO;
            MK := inMK;
            e := ine;
        end recv_t_b_z_mo_mk_e;

        c := Z(1);
        for i in 2..H loop
            if Z(i) > c then
                c := Z(i);
            end if;
        end loop;

        TS4.recv_c(c);

        accept recv_c(inc: in Integer) do
            if inc > c then
                c := inc;
            end if;
        end recv_c;

        -- Calculte A_H
        for i in 1 .. H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        TS4.recv_a_5(A);
        Put_Line("TS5 Finished");
    end TS5;

    task body TS6 is 
      T: Vec_9;
      A: Vec_7; 
      Z: Vec_4;
      B: Vec_8;
      MO: Mtx_9;
      MK: Mtx_8;
      c, e: Integer;
    begin
        Put_Line("TS6 Started");

        for i in 1..2 loop
            select
                accept recv_bmk(inB: in Vec; inMK: in Mtx) do
                    B := inB;
                    MK := inMK;
                end recv_bmk;
            or
                accept recv_tmo(inT: in Vec; inMO: in Mtx) do
                    T := inT;
                    MO := inMO;
                end recv_tmo;
            end select;
        end loop;

        TS4.recv_t_b_mo_mk(T, B(1..5*H), MO, MK(1..5*H));

        accept recv_ze(inZ: in Vec; ine: in Integer) do
            Z := inZ;
            e := ine;
        end recv_ze;

        TS9.recv_t_z_mo_e(T, Z(3*H+1..4*H), MO, e);
        TS7.recv_b_z_mk_e(B(6*H+1..8*H), Z(H+1..3*H), MK(6*H+1..8*H), e);

        c := Z(1);
        for i in 2..H loop
            if c < Z(i) then
                c := Z(i);
            end if;
        end loop;

        for i in 1..2 loop
            accept recv_c(inc: in Integer) do
                if c < inc then
                    c := inc;
                end if;
            end recv_c;
        end loop;

        TS4.recv_c(c);

        accept recv_c(inc: in Integer) do
            if c < inc then
                c := inc;
            end if;
        end recv_c;

        TS7.recv_c(c);
        TS9.recv_c(c);

        -- Calculte A_H
        for i in 5*H+1 .. 6*H loop
            A(i) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        for i in 1..2 loop
            select
                accept recv_a_4(inA: in Vec) do
                    A(1..5*H) := inA;
                end recv_a_4;
            or
                accept recv_a_9(inA: in Vec) do
                    A(6*H+1..7*H) := inA;
                end recv_a_9;
            end select;
        end loop;


        TS7.recv_a(A);

        Put_Line("TS6 Finished");
    end TS6;

    task body TS7 is 
        T: Vec_9;
        A: Vec_8; 
        Z, B: Vec_2;
        MO: Mtx_9;
        MK: Mtx_2;
        c, e: Integer;
    begin
        Put_Line("TS7 Started");

        accept recv_tmo(inT: in Vec; inMO: in Mtx) do
            T := inT;
            MO := inMO;
        end recv_tmo;

        TS6.recv_tmo(T, MO);

        accept recv_b_z_mk_e(inB, inZ: in Vec; inMK: in Mtx; ine: in Integer) do
            B := inB;
            Z := inZ;
            MK := inMK;
            e := ine;
        end recv_b_z_mk_e;

        TS8.recv_b_z_mk_e(B(H+1..2*H), Z(H+1..2*H), MK(H+1..2*H), e);

        c := Z(1);
        for i in 2..H loop
            if c < Z(i) then
                c := Z(i);
            end if;
        end loop;

        accept recv_c(inc: in Integer) do
            if inc > c then
                c := inc;
            end if;
        end recv_c;

        TS6.recv_c(c);

        accept recv_c(inc: in Integer) do
            if inc > c then
                c := inc;
            end if;
        end recv_c;

        TS8.recv_c(c);

        for i in 1 .. H loop
            A(i+H*6) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i+H*6) := A(i+H*6) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        accept recv_a(inA: in Vec) do
            A(1..6*H) := inA(1..6*H);
            A(7*H+1..8*H) := inA(6*H+1..7*H);
        end recv_a;

        TS8.recv_a(A);

        Put_Line("TS7 Finished");
    end TS7;

    task body TS8 is 
        A, T: Vec_9;
        MO: Mtx_9;
        B, Z: Vec_1;
        MK: Mtx_1;
        c, e: Integer;
    begin
        Put_Line("TS8 Started");
        -- Input
        for i in 1..N loop
            T(i) := 1;
            for j in 1..N loop
                MO(i)(j) := 1;
            end loop;
        end loop;

        TS7.recv_tmo(T, MO);

        accept recv_b_z_mk_e(inB, inZ: in Vec; inMK: in Mtx; ine: in Integer) do
            B :=inB;
            Z := inZ;
            MK := inMK;
            e := ine;
        end recv_b_z_mk_e;

        c := Z(1);
        for i in 2..H loop
            if c < Z(i) then
                c := Z(i);
            end if;
        end loop;

        TS7.recv_c(c);

        accept recv_c(inc: in Integer) do
            if inc > c then
                c := inc;
            end if;
        end recv_c;

        for i in 1 .. H loop
            A(i+H*7) := c * B(i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i+H*7) := A(i+H*7) + e * T(j) * MO(k)(j) * MK(i)(k);
                end loop;
            end loop;
        end loop;

        accept recv_a(inA: in Vec) do
            A(1..7*H) := inA(1..7*H);
            A(8*H+1..9*H) := inA(7*H+1..8*H);
        end recv_a;

        if N < 28 then
            for i in 1..N loop
                Put(A(i), 4);
            end loop;
            Put_Line("");
        end if;

        Put_Line("TS8 Finished");
    end TS8;

    task body TS9 is 
        A, Z: Vec_1;
        B, T: Vec_9;
        MO, MK: Mtx_9;
        c, e: Integer;
    begin
        Put_Line("TS9 Started");
        -- Input 
        for i in 1..N loop
            B(i) := 1;
            for j in 1..N loop
                MK(i)(j) := 1;
            end loop;
        end loop;

        TS6.recv_bmk(B(1..8*H), MK(1..8*H));

        accept recv_t_z_mo_e(inT, inZ: in Vec; inMO: in Mtx; ine: in Integer) do
            T := inT;
            Z := inZ;
            MO := inMO;
            e := ine;
        end recv_t_z_mo_e;

        c := Z(1);
        for i in 2..H loop
            if c < Z(i) then
                c := Z(i);
            end if;
        end loop;

        TS6.recv_c(c);

        accept recv_c(inc: in Integer) do
            if inc > c then
                c := inc;
            end if;
        end recv_c;

        for i in 1 .. H loop
            A(i) := c * B(8*H+i);
            for j in 1 .. N loop
                for k in 1 .. N loop
                    A(i) := A(i) + e * T(j) * MO(k)(j) * MK(8*H+i)(k);
                end loop;
            end loop;
        end loop;

        TS6.recv_a_9(A);
        Put_Line("TS9 Finished");
    end TS9;

begin
    null;
end Lab7;
