with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Command_Line;
with Ada.Text_IO;
with Word_Lists;

package Control_Words is

	package T_IO	renames Ada.Text_IO;

	package ACL 	renames Ada.Command_Line;

	package Int_IO is new Ada.Text_IO.Integer_IO(Integer);

	procedure 
		lounch_control_mode(
			selector: in out integer);

	procedure 
		Dispose_List(
			Word_List: in out Word_Lists.Word_List_Type);
		
	procedure 
		Activate_Control_Mode(
			Word_List: in out Word_Lists.Word_List_Type);
	
	end Control_Words;
