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

	--Borra el nodo de la lista
	procedure Delete_Word (List: in out Word_List_Type;
			Word: in ASU.Unbounded_String) is
		Aux1: Word_List_Type;
		Aux2: Word_List_Type;
	begin --Delete_Word

		Aux1:=List;  --Dos punteros auxiliares
		if List=null then		--Lista vacía
			T_IO.Put_Line(" No hay palabras.");

		elsif Aux1.word=Word then	--Word en el primer nodo?
			List:=List.Next;		--Adelanta List
			Free(Aux1);				--Libera el nodo
		else
			Delete_Word(List.Next,Word);							--Con todo esto
		end if;
	end Delete_Word;

	--Buscar el nodo en la lista
	procedure Search_Word (List: in Word_List_Type;
			Word: in ASU.Unbounded_String;
			Count: out Natural) is
		Aux: Word_List_Type;
	begin	--Search_Word
		Count:=0;
		Aux:=List;
		loop
			if Aux.Word=Word then
				Count:=Aux.Count;
			end if;
			Aux:=Aux.Next;
		exit when  Aux=null;
		end loop;
	end Search_Word;

	--Agregar un nodo con un Word
	Procedure New_Node (Last_Pointer: in out Word_List_Type;
				Word : in ASU.Unbounded_String) is
	begin	--New_Node
		Last_Pointer:= New Cell;
		Last_Pointer.Word:=Word;
		Last_Pointer.Count:=1;
		Last_Pointer.Next:=null; --Opcional, pero buena praxis
	end New_Node;


	--Busca la palabra con mayor ocurrencia
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
		if Count=0 then
			T_IO.Put_Line(" No hay dicha palabra.");
		end if;
	end Max_Word;

	--Imprime la lista en pantalla
	procedure Print_All (List: in Word_List_Type) is
		Aux: Word_List_Type;
	begin --Print_All
		if List=null then
			T_IO.Put_Line(" No hay palabras.");
		end if;
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

 	--Añade Word a la lista
	procedure Add_Word (List: in out Word_List_Type;
	 					Word: in ASU.Unbounded_String) is
		Aux_List: Word_List_Type;
	begin	--Add_Word
		Aux_List:=List;
		if Aux_List=null then 		--si no existe la crea
			New_Node(List,Word);
		elsif Aux_List.Word=Word then 		-- Busca si la palabra concuerda (si es así ++Cntr y termina)
			Aux_List.Count:=Aux_List.Count+1;
		else	--Pasa al siguiente
			Add_Word(Aux_List.Next,Word);
		end if;
	end Add_Word;


		procedure Delete_List (List: in out Word_List_Type) is
		        Trasher: Word_List_Type;
	    begin --Delete_List
		       loop
		    		Trasher:=List.Next;
					List:=List.Next;
				    Free(Trasher);
				 	exit when List=null;
				end loop;
	    end Delete_List;


--		procedure Delete_List (List: in out Word_List_Type) is
--			P_Aux_1:Word_List_Type;
--			P_Aux_2:Word_List_Type;
--			End_List:Boolean:=False;
--		begin
--			P_Aux_1:=List;
--			P_Aux_2:=List;
--			if List = null then
--					T_IO.Put(" ");
--				elsif List.Next=null then
--					P_Aux_2:=P_Aux_1.Next;
--					Free(P_Aux_1);
--					List:=P_Aux_2;
--				else
--					P_Aux_1:=P_Aux_2.Next;
--					while not End_List loop
--						if P_Aux_1 /= null then
--								P_Aux_2.Next:=P_Aux_1.Next;
--								Free(P_Aux_1);
--								End_List :=True;
--						elsif P_Aux_1 = null then
--							raise Word_List_Error;
--						else
--							P_Aux_1:=P_Aux_1.Next;
--							P_Aux_2:=P_Aux_2.Next;
--						end if;
--					end loop;
--			end if;
--		end Delete_List;

-------------------------
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
--			Max_Word(List,Aux_Word,Aux_Count);
--	Builded_Node_To(Aux_List.Next,Aux_Word,Aux_Count);
--			Delete_Word (List,Aux_Word);
--			Aux_List:=Aux_List.Next;
--		end loop;
--		List:=New_List;
--	end;

end Word_Lists;
