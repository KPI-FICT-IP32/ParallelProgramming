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
 	
	N: integer :=100;
	type Vector is array (1..N) of integer; 

	type Matrix is array (1..N) of Vector; 
	a : integer;
	alpha : integer := 1; 

	MO1, MO2, ME : Matrix; 
	Z, R : Vector;
	S1, S2, S3, S4, S_end_1: Suspension_Object;
	
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

	function GenerateVector return Vector is
		V: Vector;
	begin		
		for i in 1..N loop
			V(i):=1;
		end loop;
		return V;
	end GenerateVector;
	
	procedure Start is
		a_R, a_R1, a_R2: Vector;
		ME_MO: Matrix;	
		a_R_ME_MO, z: Vector;	
		H: integer :=N/2;
		max_1, max_2: integer;
		task T1;
		
		-- task 1 body
		task body T1 is begin
			Put("T1 started");
			New_Line;			
			-- Data input
			ME := GenerateMatrix;
			Z  := GenerateVector;
			MO1 := GenerateMatrix;
			Suspend_Until_True(S1);
						
			-- alpha*Rh(MEh*MOh)
			for i in 1..H loop
				a_R(i):=alpha*R(i);
			end loop;
			-- MEh*MOh
			for i in 1..N loop
				for j in 1..H loop
					ME_MO(i)(j):= 0;
					for k in 1..N loop
						ME_MO(i)(j):=ME_MO(i)(j)+ME(i)(k)*MO2(k)(j);
					end loop;
				end loop;
			end loop;
			-- a_R*ME_MO
			a_R1:=a_R;
			Set_True(S2);
		
			for j in 1..H loop
				a_R_ME_MO(j):= 0;	
				for k in 1..N loop
					a_R_ME_MO(j) := a_R_ME_MO(j) + a_R1(j)*ME_MO(k)(j);
				end loop;
			end loop;
			-- max(Z+a_R_ME_MO)
			for i in 1..H loop
				z(i):=a_R_ME_MO(i)+Z(i);
				-- max
				if (max_1<Z(i)) then
					max_1:= Z(i);
				end if;
			end loop;
			Suspend_Until_True(S3);
			-- Returning result			
			if (max_2>max_1) then
				put("Result:");
				put(max_2);
				New_Line;	
			else 
				put("Result:");
				put(max_1);
				New_Line;		
			end if;

			Set_True(S_end_1);
			Put("T1 finished");
		end T1;

		-- Test 2 body
		task T2;
			
		task body T2 is
		
		begin				
			Put("T2 started");
			New_Line;
			-- Data input	
			MO2 := GenerateMatrix;
			R  := GenerateVector;
			
			Set_True(S1);
			-- alpha*Rh(MEh*MOh)
			H:=N/2;
			-- alpha * Rh
			for i in H+1..N loop
				a_R(i):=alpha*R(i);
			end loop;
			-- MEh*MOh
			for i in 1..N loop
				for j in H+1..N loop
					ME_MO(i)(j):= 0;
					for k in 1..N loop
						ME_MO(i)(j):=ME_MO(i)(j)+ME(i)(k)*MO2(k)(j);
					end loop;
				end loop;
			end loop;
			-- a_R*ME_MO
			
			Suspend_Until_True(S2);
			a_R2:=a_R;

			for j in H+1..N loop
				a_R_ME_MO(j):= 0;	
				for k in 1..N loop
					a_R_ME_MO(j) := a_R_ME_MO(j) + a_R2(k)*ME_MO(j)(k);
				end loop;
			end loop;

			-- max(Z+a_R_ME_MO)
			for i in H+1..N loop
				z(i):=a_R_ME_MO(i)+Z(i);
				-- max
				if (max_2<Z(i)) then
					max_2:= Z(i);
				end if;
			end loop;
	
			Set_True(S3);
			Put("T2 finished");
			New_Line;			
			Suspend_Until_True(S_end_1);
			
		end T2;
	begin 
		null;
	end Start;

begin 
	Start;
end Lab1;
		
