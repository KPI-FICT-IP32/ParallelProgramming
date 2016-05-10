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
with Data; use Data;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Synchronous_Task_Control; use Ada.Synchronous_Task_Control;


procedure Lab5 is
    A, B, E: Vector;
    MO, MK: Matrix;
    alpha: Integer;

    -- These semaphores are used to signalize about events
    S_T2_input_finished: Suspension_Object;
    S_T1_computation_finished: Suspension_Object;

    -- Semaphores to controll access to shared variables
    S_Shared_Access: Suspension_Object;


    procedure RunTasks is

        task T1 is
            pragma Storage_Size (300_000_000);
        end T1;
        task body T1 is
            -- Copies of shared data
            MO_1: Matrix;
            B_1: Vector;
            alpha_1: Integer;
        begin
            Put_Line("Task T1 started");

            -- Wait until T2 inputs data
            Suspend_Until_True(S_T2_input_finished);

            -- Copy shared objects
            Suspend_Until_True(S_Shared_Access);
            alpha_1 := alpha;
            B_1 := B;
            MO_1 := MO;
            Set_True(S_Shared_Access);

            -- Compute partial result
            for i in 1 .. H loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + B_1(j) * MO_1(j,k) * MK(k,i);
                    end loop;
                end loop;
                A(i) := A(i) + alpha_1 * E(i);
            end loop;

            -- Signal about T1 finished its computations
            Set_True(S_T1_computation_finished);

            Put_Line("Task T1 finished");
        end T1;

        task T2 is
            pragma Storage_Size (300_000_000);
        end T2;
        task body T2 is
            MO_2: Matrix;
            B_2: Vector;
            alpha_2: Integer;
        begin
            Put_Line("Task T2 started");

            -- Input data
            GetVector(B);
            GetVector(E);
            GetMatrix(MO);
            GetMatrix(MK);
            alpha := 1;

            -- Signal about data input has finished
            Set_True(S_T2_input_finished);

            -- Copy shared objects
            Suspend_Until_True(S_Shared_Access);
            alpha_2 := alpha;
            B_2 := B;
            MO_2 := MO;
            Set_True(S_Shared_Access);

            -- Compute partial result
            for i in H + 1 .. N loop
                A(i) := 0;
                for j in 1 .. N loop
                    for k in 1 .. N loop
                        A(i) := A(i) + B_2(j) * MO_2(j,k) * MK(k,i);
                    end loop;
                end loop;
                A(i) := A(i) + alpha_2 * E(i);
            end loop;

            -- Wait until T1 finishes computations
            Suspend_Until_True(S_T1_computation_finished);

            -- Output result
            if (N < 8) then
                New_Line;
                Put("Result: ");
                Put(A);
                New_Line;
                New_Line;
            end if;

            Put_Line("Task T2 finished");
        end T2;

    begin
        null;
    end RunTasks;
begin
    Put_Line("Lab5 started");

    -- Prepare semaphores:
    Set_True(S_Shared_Access);

    RunTasks;
    Put_Line("Lab5 finished");
end Lab5;

