---------------------------------------
-- Gestión de palabras en un fichero --
-- Julio Toboso                      --
---------------------------------------

--Analiza las lineas del fichero y almacena --En lista dinámica-- las palabras  y su ocurrencia--

--Además, el modo interactivo permite añadir/borrar/buscar palabras a la lista, pero no al ficihero!

--Muestra la palabra con más ocurrencia al final

---- By Julio Toboso



--Librerias
with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Ada.Exceptions;
with Ada.Unchecked_Deallocation;

with Word_Lists;
with Split;
with Words_Command;
use Word_Lists;

procedure Words is

	--Renames--
	package T_IO 	renames Ada.Text_IO;
	package ASU 	renames Ada.Strings.Unbounded;
	package ACL 	renames Ada.Command_Line;
	package WL 		renames word_lists;
	package WC 		renames Words_Command;
	-----
	
	procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);
	
	--Exceptions--
	Wrong_Command:   Exception;
	Wrong_N_Command: Exception;
	
	--Variables--
	File : T_IO.File_Type;
	List : WL.Word_List_Type;
	File_Name: ASU.Unbounded_String;

	begin -- Words
		case ACL.Argument_Count is
			when 1 =>
				File_Name:= ASU.To_Unbounded_String(ACL.Argument(1));
				T_IO.Open(File, T_IO.In_File, ASU.To_String(File_Name));
				Split.Split_Text_In_Words(File, List);
				T_IO.Close(File);
				WL.Print_All(List);
				--WL.Delete_List(List);   --WTF No se ve????
				WC.Dispose_List(List);
			when 2 =>
				if ACL.Argument(1)/= "-i" then
					raise Wrong_Command;
					end if;
				File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
				T_IO.Open(File, T_IO.In_File, ASU.To_String(File_Name));
				Split.Split_Text_In_Words(File, List);
				T_IO.Close(File);
				WC.Interactive_Mode(List);
			when others =>
				raise Wrong_N_Command;
				end case;
	exception --Words
		when Wrong_Command =>
			T_IO.Put_Line("Paramaters out of correct use.");
			T_IO.Put_Line("Put the -i option for menu.");
		when  ADA.IO_EXCEPTIONS.NAME_ERROR =>
			T_IO.Put_Line("You didn't select an existing file.");
			WC.Interactive_Mode(List);
		when Wrong_N_Command =>
			T_IO.Put_Line("Expected number of paramaters out of range.");
			T_IO.Put_Line("words [-i] <File.txt>");

end Words;

