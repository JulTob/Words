	-------------------------------------
	--Gestión de palabras en un fichero--
	-------------------------------------

--Analiza las lineas del fichero y almacena --En lista dinámica-- las palabras  y su ocurrencia--

--Además, el modo interactivo permite añadir/borrar/buscar palabras a la lista, pero no al ficihero!

--Muestra la palabra con más ocurrencia al final

--By Julio Toboso

--Librerias

with Split;
with Ada.Text_IO;
with word_lists;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Unchecked_Deallocation;

use word_lists;
	
procedure Words is
--Paquetes renames

	package T_IO renames Ada.Text_IO;
	package ASU renames Ada.Strings.Unbounded;
	package ACL renames Ada.Command_Line;
	package Int_IO is new Ada.Text_IO.Integer_IO(Integer);
	package WLst renames word_lists;

	





	procedure lounch_control_mode(selector: in out integer; stop: in out boolean) is
		
	begin
		selector:=0;
		T_IO.Put_Line("Options");
		T_IO.Put_Line("[1] Add word");
		T_IO.Put_Line("[2] Delete word");
		T_IO.Put_Line("[3] Search word");
		T_IO.Put_Line("[4] Show all words");
		T_IO.Put_Line("[5] Quit");
		Int_IO.Get(selector);
		T_IO.Skip_Line;
	exception	
	when ADA.IO_EXCEPTIONS.DATA_ERROR =>
		selector:=0;
		T_IO.Skip_Line;
	
	end lounch_control_mode;




	procedure Activate_Control_Mode (List: in out Word_Lists.Word_List_Type) is	
		
	stop: boolean:=false;
	selector: integer :=0;
	Word:ASU.Unbounded_String;
	Max: Natural:=1;
	
	begin
		while not stop loop 
		lounch_control_mode(selector,stop);
		case selector is
			when 1 =>
				T_IO.Put_Line("Selection: Add");
				T_IO.Put_Line("Write the word");
				Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
				Add_Word (List, Word);

			when 2 =>
				T_IO.Put_Line("Selection: Delete");
				if List=null then
					T_IO.Put_Line("No words to delete");
				else
				T_IO.Put_Line("Write the word");
				Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
				Delete_Word (List,Word);
				end if;

			when 3 =>
				T_IO.Put_Line("Selection: Search");
				if List=null then
					T_IO.Put_Line("No words in text");
				else
					T_IO.Put_Line("Write the word");
					Word:=ASU.To_Unbounded_String(T_IO.Get_Line);
					Search_Word (List,Word,Max);
					if Max=0 then
						T_IO.Put_Line("Word not found");
					else 
						T_IO.Put("Word found ");
						T_IO.Put(Integer'Image(Max));
						T_IO.Put_Line(" times.");
					end if;
				end if;
			when 4 =>
				if List=null then 
					T_IO.Put_Line("No words in text");
				else
					T_IO.Put_Line("Selection: Show all");
					word_lists.Print_All(List);
				end if;

			when 5 =>
				T_IO.Put_Line("Selection: Quit");
				if List=null then
					T_IO.Put_Line("No words in text");
				else
					T_IO.Put_Line("The most frequent word is:");
					Max:=0;
					Max_Word (List,Word,Max);
			
					T_IO.Put(ASU.To_String(Word));
					T_IO.Put(Integer'Image(Max));
					T_IO.Put_Line(" times.");
				end if;
				T_IO.Put_Line("Bye.");
				stop:=true;

			when others =>
				Ada.Text_IO.Put_Line("Not a valid statement. Choose a diferent case");
		end case;
		end loop;
	end Activate_Control_Mode;







	procedure Free is new Ada.Unchecked_Deallocation(word_lists.Cell, word_lists.Word_List_Type);

--Dispose List (Extension)
	procedure Delete_List (List: in out word_lists.Word_List_Type) is
		Trasher: word_lists.Word_List_Type;
	begin
		loop 
			Trasher:=List.Next;
			List:=List.Next;
			Free(Trasher);

		exit when List=null;
		end loop;
	end Delete_List;


--Variables

	Fichero:T_IO.File_Type;
	List: word_lists.Word_List_Type;
	File_Name: ASU.Unbounded_String;
--Nombre de errores
	Wrong_Command: exception;
	Wrong_N_Command: exception;

begin
	case ACL.Argument_Count is

	when 1 =>

		File_Name:=ASU.To_Unbounded_String(ACL.Argument(1));
		T_IO.Open(Fichero, T_IO.In_File, ASU.To_String(File_Name));	
		Split.Split_Text_In_Words(Fichero, List);
		T_IO.Close(Fichero);

	
		word_lists.Print_All(List);

	when 2 =>
		if ACL.Argument(1)/="-i" then
			raise Wrong_Command;
		else
			File_Name:=ASU.To_Unbounded_String(ACL.Argument(2));
			T_IO.Open(Fichero, T_IO.In_File, ASU.To_String(File_Name));	
			Split.Split_Text_In_Words(Fichero, List);
			T_IO.Close(Fichero);
			Activate_Control_Mode(List);
		end if;
	when others =>
		raise Wrong_N_Command;
	end case;

	Delete_List(List);
exception
	when Wrong_Command =>
		T_IO.Put_Line("Paramaters out of correct use.");
		T_IO.Put_Line("Put the -i option for menu.");
	when  ADA.IO_EXCEPTIONS.NAME_ERROR =>
		T_IO.Put_Line("You didn't select an existing file.");
		Activate_Control_Mode(List);
	when Wrong_N_Command =>
		T_IO.Put_Line("Expected number of paramaters out of range.");
		T_IO.Put_Line("words [-i] <File.txt>");

	
end Words;
