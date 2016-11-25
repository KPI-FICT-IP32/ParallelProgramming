------------------------------------------
--         Parallel programming         --
--                Lab 5                 --
--         Ada. Protected module        --
--                                      --
-- Task: A = max(Z)*E + min(Z)*T(MO*MK) --
-- @author Olexandr Kovalchuk           --
-- @group IP 32                         --
--                                      --
-- @date 2016-05-11                     --
------------------------------------------
--
--
-- Alg: 
--   1. a_i = min(Z_h), b_i = max(Z_h), i = 1..P
--   2. a = min(a_i); b = max(b_i); i = 1..P
--   3. A_h = b * E_h + a * T * (MO * MK_h)
--
-- Shared resources:
--   a, b, T, MO

with Ada.Text_IO;
use  Ada.Text_IO;

with Data;

procedure Lab5 is
    -- Control parameters
    N : constant Integer := 4;
    P : constant Integer := 4;

    package Data_New is new Data(N => N, P => P); use Data_New;

    -- Protected module definition:
    protected FlowController is
        entry wait_input;
        entry wait_calc_finished;

        procedure compare_and_set_min_max(ai, bi : in Integer); 
        procedure store_T(T : in Vector);
        procedure store_MO(MO : in Matrix);
        procedure signal_input_finished;
        procedure signal_calc_finished;

        entry copy_T(T : out Vector);
        entry copy_MO(MO : out Matrix);
        entry copy_min(a : out Integer);
        entry copy_max(b : out Integer);
    private
        m_min_value : Integer; -- a
        m_max_value : Integer; -- b
        m_T : Vector;
        m_MO : Matrix;

        flag_input : Integer := 0;
        flag_min_max : Integer := 0;
        flag_T_stored : Integer := 0;
        flag_MO_stored : Integer := 0;
        flag_calc_finished : Integer := 0;
    end FlowController;

    protected body FlowController is
        entry wait_input when flag_input = 3 is
            -- Wait until input is finished
        begin
            null;
        end wait_input;

        entry wait_calc_finished when flag_calc_finished = 4 is
            -- Wait until calc is finished
        begin
            null;
        end wait_calc_finished;

        entry copy_T(T : out Vector) when flag_T_stored > 0 is
            -- Copy shared resource T
        begin
            T := m_T;
        end;

        entry copy_MO(MO : out Matrix) when flag_MO_stored > 0 is
            -- Copy shared resource MO
        begin
            MO := m_MO;
        end;

        entry copy_min(a : out Integer) when flag_min_max = 4 is
            -- Copy shared min(Z), also known as a
        begin
            a := m_min_value;
        end;

        entry copy_max(b : out Integer) when flag_min_max = 4 is
            -- Copy shared max(Z), also known as b
        begin
            b := m_max_value;
        end;

        --------------------------------------------------------
        
        procedure compare_and_set_min_max(ai, bi: in Integer) is
        begin
            if (m_min_value > ai) then
                m_min_value := ai;
            end if;

            if (m_max_value < bi) then
                m_max_value := bi;
            end if;

            flag_min_max := flag_min_max + 1;
        end;

        procedure store_T(T : in Vector) is
        begin
            m_T := T;
            flag_T_stored := flag_T_stored + 1;
        end;

        procedure store_MO(MO : in Matrix) is
        begin
            m_MO := MO;
            flag_MO_stored := flag_MO_stored + 1;
        end;

        procedure signal_input_finished is
        begin
            flag_input := flag_input + 1;
        end;

        procedure signal_calc_finished is
        begin
            flag_calc_finished := flag_calc_finished + 1;
        end;

    end FlowController;

    -- Define variables
    A, E, T, Z : Vector;
    MO, MK : Matrix;

    procedure RunTasks is

        task T1 is
            pragma Storage_Size (300_000_000);
        end T1;
        task body T1 is
            -- Copies of shared data
            a_1, b_1 : Integer;
            T_1 : Vector;
            MO_1 : Matrix;
        begin
            Put_Line("Task T1 started");

            get_vector(Z);
            get_vector(E);
            FlowController.signal_input_finished;

            -- Wait until input finished
            FlowController.wait_input;

            -- Calculate min / max
            a_1 := Z(1);
            b_1 := Z(1);
            for i in 1 .. H loop
                if a_1 > Z(i) then
                    a_1 := Z(i);
                end if;
                if b_1 < Z(i) then
                    b_1 := Z(i);
                end if;
            end loop;
            FlowController.compare_and_set_min_max(a_1, b_1);

            -- Copy shared_variables
            FlowController.copy_MO(MO_1);
            FlowController.copy_T(T_1);
            FlowController.copy_min(a_1);
            FlowController.copy_max(b_1);

            -- Compute partial result
            for i in 1 .. H loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + a_1 * T_1(j) * MO_1(j)(k) * MK(k)(i);
                    end loop;
                end loop;
                A(i) := A(i) + b_1 * E(i);
            end loop;

            -- Notify calc finished;
            FlowController.signal_calc_finished;

            -- Wait calc finished
            FlowController.wait_calc_finished;

            if (N < 12) then
                put(A);
            end if;

            Put_Line("Task T1 finished");
        end T1;

        task T2 is
            pragma Storage_Size (300_000_000);
        end T2;
        task body T2 is
            -- Copies of shared data
            a_2, b_2 : Integer;
            T_2 : Vector;
            MO_2 : Matrix;
        begin
            Put_Line("Task T2 started");

            -- Wait until input finished
            FlowController.wait_input;

            -- Calculate min / max
            a_2 := Z(H + 1);
            b_2 := Z(H + 1);
            for i in H + 1 .. 2 * H loop
                if a_2 > Z(i) then
                    a_2 := Z(i);
                end if;
                if b_2 < Z(i) then
                    b_2 := Z(i);
                end if;
            end loop;
            FlowController.compare_and_set_min_max(a_2, b_2);

            -- Copy shared_variables
            FlowController.copy_MO(MO_2);
            FlowController.copy_T(T_2);
            FlowController.copy_min(a_2);
            FlowController.copy_max(b_2);

            -- Compute partial result
            for i in H + 1 .. 2*H loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + a_2 * T_2(j) * MO_2(j)(k) * MK(k)(i);
                    end loop;
                end loop;
                A(i) := A(i) + b_2 * E(i);
            end loop;

            -- Notify calc finished;
            FlowController.signal_calc_finished;

            Put_Line("Task T2 finished");
        end T2;

        task T3 is
            pragma Storage_Size (300_000_000);
        end T3;
        task body T3 is
            -- Copies of shared data
            a_3, b_3 : Integer;
            T_3 : Vector;
            MO_3 : Matrix;
        begin
            Put_Line("Task T3 started");

            get_vector(T);
            FlowController.store_T(T);

            get_matrix(MO);
            FlowController.store_MO(MO);

            FlowController.signal_input_finished;

            -- Wait until input finished
            FlowController.wait_input;

            -- Calculate min / max
            a_3 := Z(2 * H + 1);
            b_3 := Z(2 * H + 1);
            for i in 2 * H + 1 .. 3 * H loop
                if a_3 > Z(i) then
                    a_3 := Z(i);
                end if;
                if b_3 < Z(i) then
                    b_3 := Z(i);
                end if;
            end loop;
            FlowController.compare_and_set_min_max(a_3, b_3);

            -- Copy shared_variables
            FlowController.copy_MO(MO_3);
            FlowController.copy_T(T_3);
            FlowController.copy_min(a_3);
            FlowController.copy_max(b_3);

            -- Compute partial result
            for i in 2*H + 1 .. 3*H loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + a_3 * T_3(j) * MO_3(j)(k) * MK(k)(i);
                    end loop;
                end loop;
                A(i) := A(i) + b_3 * E(i);
            end loop;

            -- Notify calc finished;
            FlowController.signal_calc_finished;
            Put_Line("Task T3 finished");
        end T3;

        task T4 is
            pragma Storage_Size (300_000_000);
        end T4;
        task body T4 is
            -- Copies of shared data
            a_4, b_4 : Integer;
            T_4 : Vector;
            MO_4 : Matrix;
        begin
            Put_Line("Task T4 started");

            get_matrix(MK);
            FlowController.signal_input_finished;

            -- Wait until input finished
            FlowController.wait_input;

            -- Calculate min / max
            a_4 := Z(3 * H + 1);
            b_4 := Z(3 * H + 1);
            for i in 3 * H + 1 .. 4 * H loop
                if a_4 > Z(i) then
                    a_4 := Z(i);
                end if;
                if b_4 < Z(i) then
                    b_4 := Z(i);
                end if;
            end loop;
            FlowController.compare_and_set_min_max(a_4, b_4);

            -- Copy shared_variables
            FlowController.copy_MO(MO_4);
            FlowController.copy_T(T_4);
            FlowController.copy_min(a_4);
            FlowController.copy_max(b_4);

            -- Compute partial result
            for i in 3*H + 1 .. 4*H loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + a_4 * T_4(j) * MO_4(j)(k) * MK(k)(i);
                    end loop;
                end loop;
                A(i) := A(i) + b_4 * E(i);
            end loop;

            -- Notify calc finished;
            FlowController.signal_calc_finished;
            Put_Line("Task T4 finished");
        end T4;
    begin
        null;
    end RunTasks;
begin
    Put_Line("Lab5 started");

    -- Prepare semaphores:
    RunTasks;
    Put_Line("Lab5 finished");
end Lab5;

