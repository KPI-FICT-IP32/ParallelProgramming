--------------------------------------------------------------------
--
--	ЛАБ 1: АДА.СЕМАФОРИ
--
-- 	a = max(Z+alpha*R(ME*MO))
--	
--	ВИКОНАВ: Статкевич Роман, ІП-32
--	T1: a, Z, alpha, ME
--	T2: R, MO
--
--------------------------------------------------------------------
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;

use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Synchronous_Task_Control;

procedure Lab1 is
 	
	N: integer :=500;
	type Vector is array (1..N) of integer; 

	type Matrix is array (1..N) of Vector; 
	a : integer;
	alpha, alpha1, alpha2 : integer := 1; 

	MO1, MO2, MO, ME : Matrix; 
	Z, R : Vector;
	S_input_finished_1, S_input_finished_2, S_copy_semaphore, S_T1_finished, S_T2_finished,S_T1_max_found,S_T2_max_found: Suspension_Object;
	
	function GenerateMatrix return Matrix is
		MT: Matrix;
	begin		
		for i in 1..N loop
			for j in 1..N loop
				MT(i)(j):=1;
			end loop;
		end loop;
		return MT;
	end GenerateMatrix;
	
	procedure DisplayMatrix(MMM: Matrix) is
	begin		
		for i in 1..N loop
			for j in 1..N loop
				Put(MMM(i)(j));
			end loop;
			New_Line;
		end loop;
		
	end DisplayMatrix;

	function GenerateVector return Vector is
		V: Vector;
	begin		
		for i in 1..N loop
			V(i):=1;
		end loop;
		return V;
	end GenerateVector;
	
	procedure Start is
		R, R1, R2: Vector;
		ME_MO: Matrix;	
		a_R_ME_MO, z: Vector;	
		H: integer := N/2;
		max_1, max_2: integer;
		a: integer;
		task T1;
		
		-- task 1 body
		task body T1 is
			answ: integer;
		begin
			Put("T1 started");
			New_Line;			
			-- Data input
			ME := GenerateMatrix;
			Z  := GenerateVector;
			MO := GenerateMatrix;
						
			Set_True(S_input_finished_1);
			Suspend_Until_True(S_input_finished_2);
			
			MO1 := MO;
			alpha1 := alpha;
			R1:=R;
			Set_True(S_copy_semaphore);
			for i in 1..N loop
				for j in 1..H loop
					ME_MO(i)(j):=0;					
					for k in 1..N loop
						ME_MO(i)(j):=ME_MO(i)(j)+ME(k)(i)*MO1(i)(k);
					end loop;
				end loop;
			end loop;
			for i in 1..H loop
				for j in 1..N loop
					Z(i):= Z(i)+alpha1*R1(j)*ME_MO(j)(i);
				end loop;	
			end loop;

			answ:= Z(1);
			for i in 1..H loop
				if Z(i) > answ then
					answ:=Z(i);
				end if;
			end loop;
	
			Suspend_Until_True(S_T2_max_found);
			if answ>a then
				a:=answ;
			end if;
			Put("result: ");
						
			Put(a);
			New_Line;
			
			Put("T1 finished");
			
			Set_True(S_T1_finished);
			New_Line;
		end T1;

		-- Test 2 body
		task T2;
			
		task body T2 is
			answ: integer;
		begin				
			Put("T2 started");
			New_Line;
			-- Data input	
			MO := GenerateMatrix;
			R  := GenerateVector;
			Set_True(S_input_finished_2);
			Suspend_Until_True(S_input_finished_1);

			Suspend_Until_True(S_copy_semaphore);
			MO2 := MO;
			alpha2 := alpha;
			R2:=R;
			for i in 1..N loop
				for j in H+1..N loop
					ME_MO(i)(j):=0;
					for k in 1..N loop
						ME_MO(i)(j):=ME_MO(i)(j)+ME(k)(i)*MO2(i)(k);
					end loop;
				end loop;	
			end loop;
		
			for i in H+1..N loop
				for j in 1..N loop
					Z(i):= Z(i)+alpha2*R2(j)*ME_MO(j)(i);
				end loop;	
			end loop;
			answ:= Z(H+1);
			for i in H+1..N loop
				if Z(i) > answ then
					answ:=Z(i);
				end if;
			end loop;	
			
			a:= answ;			
			Set_True(S_T2_max_found);
			
			Put("T2 finished");
			Set_True(S_T2_finished);
			New_Line;
		end T2;
	begin 
		null;
	end Start;

begin 
	Start;
	Suspend_Until_True(S_T1_finished);
	Suspend_Until_True(S_T2_finished);

end Lab1;
		
