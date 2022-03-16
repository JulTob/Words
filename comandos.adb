with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;

procedure Comandos is
    package ACL renames Ada.Command_Line;
    package ASU renames Ada.Strings.Unbounded;
    package ATI renames Ada.Text_IO;

    Usage_Error: exception;
	File_Name_Error: exception;
	
	File_Name: ASU.Unbounded_String;
	File: Ada.Text_IO.File_Type;
	
	Option: Integer;

	procedure Print_Menu is
	begin

		ATI.Put_Line("Options");
		ATI.Put_Line("1 Add word");
		ATI.Put_Line("2 Delete word");
		ATI.Put_Line("3 Search word");
		ATI.Put_Line("4 Show all words");
		ATI.Put_Line("5 Quit");
		ATI.Put_Line(" ");
		ATI.Put("Your option? ");

	end Print_Menu;

	procedure Select_Option is
	begin
		Print_Menu;
		Option := Integer'Value(ATI.Get_Line);
		while Option /= 5 loop
			if Option = 1 then
				ATI.Put_Line("1");
				Print_Menu;
			elsif Option = 2 then
				ATI.Put_Line("2");
				Print_Menu;
			elsif Option = 3 then
				ATI.Put_Line("3");
				Print_Menu;
			elsif Option = 4 then
				ATI.Put_Line("4");
				Print_Menu;
			elsif Option = 5 then
				ATI.Put_Line("5");
			else
				ATI.Put_Line("Error: choose one of the options");
				Print_Menu;
			end if;
		
		Option := Integer'Value(ATI.Get_Line);
		end loop;

		exception
  
    when Constraint_Error =>
       Ada.Text_IO.Put_Line("Error: choose one of the options");
	end Select_Option;


begin

    if ACL.Argument_Count /= 1 and ACL.Argument_Count /= 2  then
       raise Usage_Error;
	elsif ACL.Argument_Count = 1 then
		File_Name := ASU.To_Unbounded_String(ACL.Argument(1));        
    	Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));
	--	Cut_File(File);
   		Ada.Text_IO.Close(File);
	elsif ACL.Argument_Count = 2 and ACL.Argument(1) = "-i" then
		 File_Name := ASU.To_Unbounded_String(ACL.Argument(2));
		 Ada.Text_IO.Open(File, Ada.Text_IO.In_File, ASU.To_String(File_Name));
		 Select_Option;
		 Ada.Text_IO.Close(File);
	end if;
   
exception
  
    when Usage_Error =>
       Ada.Text_IO.Put_Line("Use: ");
       Ada.Text_IO.Put_Line("       " & ACL.Command_Name & " <file>");

	when Ada.IO_Exceptions.Name_Error =>
       Ada.Text_IO.Put_Line(ASU.To_String(File_Name) & ": File not found");

end Comandos;
