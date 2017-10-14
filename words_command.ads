with Ada.Exceptions;
with Ada.IO_Exceptions;
with Ada.Command_Line;
with Ada.Text_IO;
with Word_Lists;

package Words_Command is

    	package T_IO renames Ada.Text_IO;
    	package ACL renames Ada.Command_Line;
        package I_IO is new Ada.Text_IO.Integer_IO(Integer);

procedure Dispose_List (Word_List: in out Word_Lists.Word_List_Type);

procedure Command_Input (selector: in out integer);

procedure Interactive_Mode (List: in out Word_Lists.Word_List_Type);

end Words_Command;
