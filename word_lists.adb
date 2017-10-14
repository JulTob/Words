	---------------------------------------
	--Gestión de palabras en un fichero  --
	---------------------------------------
-- Modo Interactivo: [-i]
--	  Permite añadir/borrar/buscar palabras a la lista, pero no al ficihero!
-- Julio Toboso

--Librerias--
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with Ada.Command_Line;
with Ada.Exceptions;
with Ada.IO_Exceptions;

package body Word_Lists is

	--Renames--
	package T_IO renames Ada.Text_IO;
	package ACL renames Ada.Command_Line;
	use Type ASU.Unbounded_String;

	-- Liberación de Punteros de Lista
	procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);

	procedure Delete_Word (List: in out Word_List_Type;
			Word: in ASU.Unbounded_String) is
		Aux1: Word_List_Type;
		Aux2: Word_List_Type;
	begin --Delete_Word

		Aux1:=List;  --Dos punteros auxiliares
		Aux2:=List;  --Mantener a Aux2 por delante

		if List=null then		--Lista vacía
			T_IO.Put_Line(" No hay palabras.");

		elsif Aux1.word=Word then	--Word en el primer nodo?
			List:=List.Next;		--Adelanta List
			Free(Aux1);				--Libera el nodo
		else
			Aux2:=Aux1.Next;			--Probar si es posible una recurrencia
			while Aux2/=null loop        --Delete_Word(Aux2)???

				if Aux2.Word=Word then
					Aux1.Next:=Aux2.Next;

					Free(Aux2);
					Aux2:=Aux1.Next;
				end if;

				Aux1:=Aux1.Next;
				if  Aux2/=null then
					Aux2:=Aux2.Next;
				end if;
			end loop;
										--Con todo esto
		end if;
	end Delete_Word;







--No toques
	procedure Search_Word (List: in Word_List_Type;
			Word: in ASU.Unbounded_String;
			Count: out Natural) is
		Aux: Word_List_Type;
	begin


		Count:=0;
		Aux:=List;

		loop

			if Aux.Word=Word then
				Count:=Aux.Count;
			end if;


			Aux:=Aux.Next;
		exit when  Aux=null;
		end loop;
	end;




--No toques
	Procedure New_Node (Last_Pointer: in out Word_List_Type;
				Word : in ASU.Unbounded_String) is
	begin
		Last_Pointer:= New Cell;
		Last_Pointer.Word:=Word;
		Last_Pointer.Count:=1;
		Last_Pointer.Next:=null; --Opcional, pero buena praxis
	end New_Node;


--No toques esto
	procedure Max_Word (List: in Word_List_Type;
			Word: out ASU.Unbounded_String;
			Count: out Natural) is
		Aux_List: Word_List_Type;
	begin
		Count:=0;
		Aux_List:=List;

		while not (Aux_List=null) loop
			if Aux_List.Count>Count then
				Count:=Aux_List.Count;
				Word:=Aux_List.Word;
			end if;
			Aux_List:=Aux_List.Next;
		end loop;
	end;



--No toques esto

	procedure Print_All (List: in Word_List_Type) is
		Aux: Word_List_Type;
	begin

		Aux:=List;
		loop
			T_IO.Put("| ");
			T_IO.Put(ASU.To_String(Aux.Word));
			T_IO.Put(" | ");
			T_IO.Put(Integer'Image(Aux.Count));
			T_IO.Put_Line(" times");
			Aux:=Aux.Next;
		exit when Aux= null;
		end loop;
	end Print_All;







--POSIBLE SORT (ORDENA PARA LA LISTA) CON LOS COMANDOS MAX Y DELETE


--	Procedure Builded_Node_To (Last_Pointer: in out Word_List_Type;
--				Word : in ASU.Unbounded_String;
--				Count: in Natural) is
--	begin
--		Last_Pointer:= New Cell;
--		Last_Pointer.Word:=Word;
--		Last_Pointer.Count:=Count;
--		Last_Pointer.Next:=null; --Opcional, pero buena praxis
--	end Builded_Node_To;



--	procedure Sort (List: in out Word_List_Type) is
--		Aux_List: Word_List_Type;
--		New_List: Word_List_Type;
--		Aux_Word: ASU.Unbounded_String;
--		Aux_Count: Natural;
--	begin
--		Aux_Count:=0;
--		Max_Word(List,Aux_Word,Aux_Count);
--		Builded_Node_To(New_List,Aux_Word,Aux_Count);
--		Delete_Word (List,Aux_Word);
--		Aux_List:=New_List;
--		while not (List=null) loop
--
--			Max_Word(List,Aux_Word,Aux_Count);
--			Builded_Node_To(Aux_List.Next,Aux_Word,Aux_Count);
--			Delete_Word (List,Aux_Word);
--			Aux_List:=Aux_List.Next;
--		end loop;
--		List:=New_List;
--	end;





	procedure Add_Word (List: in out Word_List_Type;
			Word: in ASU.Unbounded_String) is

		Aux_List: Word_List_Type;
		finish: boolean:= False;
		auxB: 	boolean:= False;
	begin
		Aux_List:=List;

		--si no existe la crea

		if Aux_List=null then
			New_Node(List,Word);
		else

		-- Busca si la palabra concuerda (si es así ++Cntr y termina)

			loop

				if Aux_List.Word=Word then
					Aux_List.Count:=Aux_List.Count+1;
					finish:=true;

		-- Mira si el siguiente va a tierra (si va, nuevo nodo y termina)

				elsif Aux_List.Next=null then
					New_Node(Aux_List.Next,Word);
					finish:=True;
				end if;

		-- Si nada de lo anterior, siguiente nodo.
				Aux_List:=Aux_List.Next;

		    	exit when finish;
			end loop;
		end if;

-- 	Sort(List);

	end Add_Word;


-------------------------

end Word_Lists;
